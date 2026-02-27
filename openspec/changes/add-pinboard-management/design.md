## Context

Pinboard 是用户的主要书签管理服务（约 200 条 bookmark，313 个 tag，43 条未读）。当前存在两个独立但相关的问题：

1. **Tag 混乱**: 拼写错误（`ainme`→`anime`）、大小写不一致（`Health`/`health`）、中英文重复（`终极文档`/`ultimate_document`）、概念重叠（`ai`/`llm`/`claude`）、14 条无 tag。需要建立规范并按规范整理。

2. **n8n 推送盲区**: 现有 pinboard workflow 只推送新增的 shared bookmark，但用户有 43 条标记为 toread 的文章，读完标记已读后不会被推送。需要增加 "未读→已读" 检测逻辑。

现有 n8n pinboard workflow（ID: RpBf8OnthvmaZYjm）结构：`Interval(15min)` → `HTTP /posts/recent` → `Split posts` → `Code(hash 去重 + shared=yes 过滤)` → `Telegram`。

现有 skill 体系中无 Pinboard 相关 skill。Pinboard 提供简单的 REST API（`api.pinboard.in/v1/`），使用 `auth_token` query param 认证。

## Goals / Non-Goals

**Goals:**

- 新建 `pinboard-manager` skill，提供交互式 tag 审计和死链检测
- 定义 tag 规范（全英文小写、`_` 连接、主题 tag + 元 tag 体系）
- 修改 n8n workflow：`/posts/recent` 分支排除 toread 文章，新增 toread diff 分支推送刚读完的文章
- 所有推送均以 `shared=yes` 为前提

**Non-Goals:**

- 不做自动 tag 纠正（所有修改需用户确认）
- 不做 Pinboard 数据备份/导出
- 不做 bookmark 内容摘要或 AI 分析
- 不做 n8n workflow 的完整重构（保留现有架构，增量修改）
- 不处理 Pinboard 的 RSS feed 功能

## Decisions

### D1: Pinboard API 认证方式——环境变量 + skill 运行时传入

**选择**: auth_token 不硬编码在 skill 中，在 `references/user-config.md` 中说明配置方式，skill 运行时通过用户提供或环境变量获取。

**替代方案**:

- 硬编码在 SKILL.md → 泄露风险
- 每次交互时询问 → 体验差

**理由**: 与其他 skill（如 yunxiao）保持一致的凭证管理模式。用户在首次使用时配置一次即可。

### D2: Tag 规范存储——`references/tag-convention.md`

**选择**: tag 规范作为 skill 的 reference 文件存储，包含：
- 基本规则（全英文小写、`_` 连接、单数优先）
- 完整的主题 tag 列表（tech / smart home / life / culture / meta 分类）
- 元 tag 列表（`evergreen`, `tool`, `reference`, `collection`）
- 迁移映射表（现有 tag → 新 tag）

**替代方案**:

- 规范写在 SKILL.md 里 → SKILL.md 会太长，且规范可能需要单独迭代
- 规范存在 Pinboard 外部（如 Obsidian 笔记）→ 与 skill 分离，维护成本高

**理由**: reference 文件是 skill 体系中存放领域知识的标准位置。tag 规范本身就是 skill 的领域知识。

### D3: Tag 审计交互模式——分批展示 + 确认后批量修改

**选择**: 审计流程

```
1. 拉取全量 bookmark（/posts/all）
2. 按问题类型分组（拼写错误、无 tag、中文 tag、概念重叠等）
3. 每组展示 5-10 条，给出修改建议
4. 用户确认/修改/跳过
5. 确认后通过 /posts/add（覆盖模式）批量应用
```

**替代方案**:

- 一次性展示所有问题 → 信息量过大，用户难以逐条判断
- 全自动修改 → 可能误改用户有意为之的 tag

**理由**: 分批处理降低认知负荷，交互式确认保证修改安全。Pinboard 的 `/posts/add` 对已有 URL 会覆盖而非创建新的，天然支持更新。

### D4: 死链检测策略——HTTP HEAD + 超时 + 分批

**选择**:

- 使用 `curl -I`（HEAD 请求）检测链接状态
- 超时设为 10 秒
- 分批处理（每批 10 条），避免触发目标网站限流
- 检测结果分类：✅ 正常 (2xx/3xx)、❌ 失效 (4xx/5xx)、⏱ 超时、⚠️ 无法连接

**替代方案**:

- GET 请求 → 浪费带宽，某些大文件会下载完整内容
- 并发请求 → 容易被目标网站封 IP
- 只检查 404 → 遗漏其他失效状态

**理由**: HEAD 请求最轻量，10 秒超时覆盖大多数慢站点。分批串行简单可靠，200 条 bookmark 全量检测约 3-5 分钟，可接受。

### D5: n8n workflow 修改——在现有 workflow 中加分支

**选择**: 在同一个 workflow 中增加并行分支，共用同一个定时触发器

```
Interval (15min)
    ├──▶ HTTP Request (/posts/recent)
    │      → Split → Code (hash去重 + shared=yes + toread≠yes) → Telegram
    │
    └──▶ HTTP Request (/posts/all?toread=yes)
           → Code (toread diff 逻辑) → Telegram
```

**替代方案**:

- 新建独立 workflow → 两个 workflow 各自轮询，浪费 API 调用，触发时间不同步
- 串行执行（recent 完了再 toread）→ 增加延迟，且两个逻辑无依赖关系

**理由**: 并行分支共用触发器，逻辑隔离但执行同步。Pinboard API 无速率限制的硬性约束。

### D6: toread diff 的 staticData 结构

**选择**: 在 n8n `staticData.global` 中存储上次 toread 列表的 URL 集合

```javascript
staticData.toreadUrls = ["https://...", "https://...", ...]
```

每次轮询：
1. 拉取当前 `toread=yes` 全量
2. 对比 `staticData.toreadUrls`
3. 消失的 URL 调 `/posts/get?url=` 验证：还存在 + shared=yes + toread=no → 推送
4. 更新 `staticData.toreadUrls` 为本次列表

**替代方案**:

- 存 hash 而非 URL → `/posts/get` 只支持 URL 查询，存 hash 无法反查
- 存完整 bookmark 对象 → 浪费存储，URL 足以做 diff

**理由**: URL 是 Pinboard 的唯一标识符（同一 URL 不能有两条 bookmark），且 `/posts/get` API 用 URL 查询，存 URL 最直接。43 条 toread 的 URL 列表存储量极小。

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Pinboard API 限流（官方建议每 3 秒一次调用） | `/posts/all?toread=yes` 和 `/posts/recent` 并行但总共只有 2 次主调用；验证消失的 bookmark 通常只有 1-2 次额外调用 |
| `/posts/add` 覆盖模式修改 tag 可能丢失其他字段 | 调用时传入完整的 description、extended、tags、shared、toread 等字段，不只传 tags |
| 死链检测的 HEAD 请求被某些站点拒绝（返回 403/405） | 对 HEAD 失败的 URL 降级为 GET 请求重试一次 |
| toread diff 首次运行时 staticData 为空 | 首次运行只记录当前列表，不触发推送（与现有 hash 去重的首次行为一致） |
| n8n staticData 丢失（如 n8n 重部署） | 与现有 hash 去重面临相同风险，可接受；重部署后首次运行等同于"首次运行"逻辑 |
