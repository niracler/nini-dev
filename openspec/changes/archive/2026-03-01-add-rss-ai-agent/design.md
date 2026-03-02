## Context

当前有两套 RSS 相关基础设施：

1. **Claude Code skill** (`rss-daily-digest`): 通过 `blogwatcher` CLI 抓取 RSS，Claude 做筛选和摘要，投递到 Telegram。需要手动触发或外部 cron 调用 Claude Code，成本较高。
2. **n8n workflows**: 已有 3 个活跃 workflow（blog、douban、pinboard），模式成熟：Schedule → 数据源 → Code 节点去重 → Telegram 投递。pinboard workflow 已实现 Pinboard API 集成和 toread diff 检测。

约束：

- n8n 实例已在运行，复用现有 credentials（Telegram Bot、Pinboard Query Auth）
- Kimi K2 API 使用 OpenAI 兼容格式（`api.moonshot.ai/v1`）
- GitHub 私有仓库作为配置和输出的 single source of truth
- n8n GitHub 节点（Resource: File）支持 Get/Create/Edit 操作，自动处理 SHA

## Goals / Non-Goals

**Goals:**

- 全自动每日 7 篇 RSS 精选，无需人工干预
- 基于 Pinboard 行为的品味画像自动生成和事件驱动更新
- 每月反思性阅读回顾
- 配置（feeds 列表、taste profile）通过 GitHub 仓库版本管理
- 月成本控制在 $1 以内

**Non-Goals:**

- 不替换现有 `rss-daily-digest` Claude Code skill（两者并行）
- 不做多用户/多租户（先跑通自己的流程）
- 不做 Folo 集成（Folo webhook 尚未稳定，未来再考虑）
- 不做实时推送（只做每日批量）
- 不做 embedding 向量匹配（用 prompt-based 评分，够用且简单）
- 不做周精选（每日 7 篇 + 每月回顾足够）

## Decisions

### 1. GitHub 仓库结构

**决定：** 使用以下目录结构

```
rss-agent/                          # 私有仓库
├── feeds.yaml                      # RSS 订阅列表
├── profile/
│   ├── taste.md                    # AI 生成的品味画像
│   ├── context.md                  # 手动维护的当前关注上下文
│   └── history/
│       └── YYYY-MM.md              # 月度分析存档
└── output/
    └── daily/
        └── YYYY-MM-DD.md           # 每日精选存档
```

**原因：**

- `feeds.yaml` 用 YAML 而不是 OPML：更易读、支持注释、方便加自定义字段（如 `priority`、`category`）
- `profile/taste.md` 和 `profile/context.md` 分离：taste.md 由 AI 自动生成，context.md 由用户手动编辑（如「最近在做 HA 集成 PR」），两者不互相覆盖
- 所有输出写回 GitHub：形成可追溯的阅读历史，也为月度分析提供数据源

**feeds.yaml 格式：**

```yaml
feeds:
  - name: Hacker News (Top)
    url: https://hnrss.org/frontpage
    category: tech
    priority: high        # high/medium/low，影响评分权重

  - name: Simon Willison
    url: https://simonwillison.net/atom/everything/
    category: ai
    priority: high

  - name: 椒盐豆豉
    url: https://blog.douchi.space/index.xml
    category: blog
    priority: medium

  # ... more feeds
```

### 2. AI 评分策略：单次批量评分 vs 逐篇评分

**决定：** 逐篇评分（每篇文章一次 Kimi API 调用）

**原因：**

- 逐篇评分输出结构更稳定（不会因为 JSON 解析错误丢失整批结果）
- Kimi 自动缓存会命中 system prompt（taste profile），缓存后 input 成本降到 $0.15/M
- 每日 50 篇 × 每篇 ~1200 token input + 200 token output ≈ $0.05/天，完全可接受
- 如果某篇评分失败，不影响其他文章

**评分 prompt 结构：**

```
System: {taste.md 内容} + {context.md 内容}

User: 请评估以下 RSS 文章与我的兴趣相关度。
输出 JSON: {"score": 0-100, "reason": "一句话理由", "category": "文章类别"}

标题: {title}
来源: {feed_name}
摘要: {description/content 前 500 字}
链接: {url}
```

**备选方案考虑：**

- 批量评分（一次传 10-20 篇）：token 更省但输出不稳定，一次失败全批丢失
- Embedding 相似度：更精确但需要向量数据库，过度工程化

### 3. 去重机制

**决定：** 基于 URL 去重，使用 n8n staticData 存储最近 7 天的已推送 URL

**原因：**

- n8n `$getWorkflowStaticData('global')` 已在 pinboard workflow 中验证可靠
- 存储最近 7 天（而不是全部历史）避免 staticData 无限膨胀
- URL 是最可靠的去重键（标题可能有微小差异）

### 4. 品味画像更新的事件检测

**决定：** 在每日 workflow 中顺便检测 Pinboard 变化，达到阈值触发独立的 profile 更新 sub-workflow

**原因：**

- 不需要额外的定时 trigger
- 复用现有 pinboard workflow 的 credentials
- 检测逻辑：对比 staticData 中记录的「上次 profile 更新时的最新 bookmark hash」与当前最新 hash，计算差值

**流程：**

```
每日 workflow 启动
  ├─ 主路径: RSS 抓取 → 评分 → Top 7 → 投递
  └─ 副路径: Pinboard /posts/recent → 计算新增数量
              → if 新增 >= 10: 触发 profile 更新 sub-workflow
```

### 5. 月度分析的 token 管理

**决定：** 将 30 天的 daily output 做预处理压缩后再传给 Kimi

**原因：**

- 30 天 × 7 篇 × ~500 字/篇 ≈ 105,000 字 ≈ ~70K token，在 Kimi K2 Exacto 的 262K 上下文内
- 但直接传全文浪费 token。预处理步骤：提取每篇的标题、分数、一句话理由、类别，压缩到 ~15K token
- 月度分析的输出要求是反思性长文（~2000 字），output token ~3K

## Architecture

### Workflow 1: 每日精选 (`rss-daily-digest`)

```
┌─────────┐   ┌──────────┐   ┌──────────┐   ┌───────────┐
│Schedule  │──▶│ GitHub   │──▶│ GitHub   │──▶│ RSS Feed  │
│ 06:00   │   │Get feeds │   │Get taste │   │ Read ×N   │
│         │   │ .yaml    │   │profile.md│   │ (并行)    │
└─────────┘   └──────────┘   └──────────┘   └─────┬─────┘
                                                    │
              ┌──────────┐   ┌──────────┐   ┌──────┴──────┐
              │ Code:    │◀──│ Code:    │◀──│ Code:       │
              │ Top 7    │   │ 去重     │   │ 合并+清洗   │
              └────┬─────┘   └──────────┘   └─────────────┘
                   │
    ┌──────────────┼──────────────┐
    ▼              ▼              ▼
┌────────┐  ┌───────────┐  ┌──────────┐
│Kimi K2 │  │ Telegram  │  │ GitHub   │
│摘要生成 │  │ 投递      │  │ Edit     │
│ ×7     │  │           │  │daily/    │
└────────┘  └───────────┘  └──────────┘
                   │
              ┌────┴─────┐
              │Pinboard  │─── if 新增>=10 ──▶ [Workflow 2]
              │check diff│
              └──────────┘
```

**关键节点说明：**

| 节点 | 类型 | 说明 |
|------|------|------|
| GitHub Get feeds | GitHub Node (File → Get) | 读取 `feeds.yaml`，解析为 feed URL 列表 |
| GitHub Get taste profile | GitHub Node (File → Get) | 读取 `profile/taste.md` + `profile/context.md` |
| RSS Feed Read ×N | RSS Feed Read + SplitInBatches | 遍历 feed URL 列表逐个抓取 |
| Code: 合并+清洗 | Code Node | 合并所有 feed 结果，提取 title/description/url/pubDate，过滤 24h 内 |
| Code: 去重 | Code Node | 对比 staticData 中最近 7 天 URL，排除已推送 |
| Kimi K2 评分 | HTTP Request (POST api.moonshot.ai/v1/chat/completions) | 逐篇评分，system=taste profile，返回 JSON |
| Code: Top 7 | Code Node | 按 score 排序，同源不超过 2 篇，取 Top 7 |
| Kimi K2 摘要 | HTTP Request | 为 Top 7 生成摘要 + 关联分析 |
| Telegram 投递 | Telegram Node | 格式化投递，复用现有 group + thread 配置 |
| GitHub Edit daily/ | GitHub Node (File → Create) | 写回每日精选存档 |

### Workflow 2: 品味画像更新 (`taste-profile-update`)

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ 被 WF1  │──▶│Pinboard  │──▶│ GitHub   │──▶│ Kimi K2  │
│ 触发    │   │/posts/all│   │Get recent│   │分析兴趣   │
│         │   │recent N  │   │daily/*.md│   │生成profile│
└──────────┘   └──────────┘   └──────────┘   └────┬─────┘
                                                    │
                                              ┌─────┴─────┐
                                              │ GitHub    │
                                              │ Edit      │
                                              │taste.md   │
                                              └───────────┘
```

### Workflow 3: 月度回顾 (`monthly-review`)

```
┌─────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│Schedule  │──▶│ GitHub   │──▶│ Code:    │──▶│ Kimi K2  │──▶│ GitHub   │
│每月1号   │   │Get daily/│   │压缩为    │   │生成反思   │   │ Create   │
│ 08:00   │   │过去30天   │   │摘要列表  │   │性长文    │   │history/  │
└─────────┘   └──────────┘   └──────────┘   └──────────┘   └────┬─────┘
                                                                  │
                                            ┌──────────┐   ┌─────┴─────┐
                                            │ GitHub   │   │ Telegram  │
                                            │ Edit     │   │ 投递摘要  │
                                            │context.md│   └───────────┘
                                            └──────────┘
```

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Kimi K2 API 不稳定或下线 | 每日精选中断 | API 使用 OpenAI 兼容格式，可快速切换到其他模型（GPT-4o-mini、Claude Haiku）只需改 base URL |
| RSS 源大量超时导致文章不足 | 当日精选质量下降 | spec 已定义 <7 篇时 best-effort 降级；设置合理 timeout（10s/feed） |
| Taste profile 漂移（AI 生成的画像逐渐偏离真实偏好） | 推荐质量下降 | context.md 作为人工锚点；月度回顾的「阅读方向调整」反馈回 profile |
| n8n staticData 丢失（实例重启/升级） | 去重失效，重复推送 | 可容忍——最坏情况是重复推一次，GitHub 存档可作为 fallback 去重源 |
| 每日 50+ 篇逐篇调 Kimi API 耗时过长 | workflow 执行时间过长 | n8n SplitInBatches 可控制并发；Kimi K2.5 Instant 模式 3-8s 响应 |
| GitHub API rate limit | 读写 GitHub 失败 | 个人 PAT 5000 次/小时，每日 workflow 约 10 次调用，远低于限制 |

## Open Questions

1. **feeds.yaml 的初始列表**：从现有 `blogwatcher` 配置迁移还是重新整理？需要用户确认订阅源列表
2. **Kimi API credential 在 n8n 中的配置方式**：使用 Header Auth（Bearer token）还是配置为 OpenAI 兼容 credential？需要在 n8n 中测试
3. **Telegram 投递格式**：完全复用现有 `rss-daily-digest` skill 的格式，还是简化为适配 n8n 的版本？
4. **profile/context.md 的初始内容**：需要用户手写第一版当前关注上下文
