## Context

Obsidian Note 仓库（`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Note/`）实际包含 ~988 篇 Markdown 笔记（远超原始估计的 ~150 篇），其中 Archives/日记 471 篇、Areas 229 篇、Inbox 9 篇等。Frontmatter 格式统一为 `aliases, tags, date, modified` 四个字段（aliases 和 tags 通常为空）。笔记之间通过 `[[wikilink]]` 形成关联关系，部分主题散落在多篇笔记中。

bokushi 博客有 3 个 content collection（blog 20 篇、til 16 篇、monthly 13 篇），共享 frontmatter schema（title, pubDate, tags, description, socialImage, hidden）。

现有 `note-to-blog` skill 将所有操作写在 SKILL.md 中由 LLM 逐步执行，存在以下问题：

- 确定性操作（文件扫描、正则转换）每次重复消耗 token
- 转换结果不稳定、不可测试
- 只支持单篇线性流程，不支持批量/并行
- 不支持关联笔记聚合

现有 `repos/skill/` 使用 `skills/<group>/<name>/SKILL.md` + 可选 `references/` + 可选 `scripts/` 的结构。

## Goals / Non-Goals

**Goals:**

- 确定性操作（扫描、转换、状态管理）由 Python 脚本完成，可独立运行、可测试
- SKILL.md 变为编排层，只负责调用脚本 + LLM 评估 + 用户交互
- 支持批量选题：一次推荐 5~8 篇，用户选 N 篇并行处理
- 支持双通道：快速通道（独立文章直接转换）和深度通道（关联主题簇先研究再写）
- 支持 Agent Teams：选中的文章/主题簇并行派发 Agent 处理
- 新增 `drafted` 中间态，支持跨天异步 review 工作流
- 通过 wikilink 图谱自动发现主题簇
- 唯一外部依赖：PyYAML

**Non-Goals:**

- 不做全自动发布（始终需要用户手动 review 和改 `hidden: false`）
- 不做 embedding 向量索引（语义判断由 LLM 直接完成）
- 不修改 Note 仓库中的原始文件（标记存储在独立 JSON）
- 不处理图片上传/迁移（保留原始图片引用）
- 不替代 writing-inspiration（本 skill 是「从笔记选题」，不是「从零创作」）
- 不做定时自动运行（用户手动触发）

## Decisions

### D1: 架构——脚本 + LLM 编排 + Agent 并行

**选择**: Python 脚本处理确定性操作，SKILL.md 编排 LLM 调用和 Agent 派发

```
note-to-blog.py (确定性)          SKILL.md (编排)
├── collect  → JSON          ──▶  LLM 评估打分
├── convert  → stdout        ──▶  Agent 调用脚本 + 审查
└── state    → 状态管理       ──▶  Agent 调用脚本更新状态
```

**替代方案**:

- 全部写在 SKILL.md 中（旧方案） → 不稳定、不可测试、浪费 token
- Shell 脚本 → 复杂正则处理困难，难以测试
- Node.js 脚本 → repos/skill 是 Python 项目，增加技术栈

**理由**: Python 标准库覆盖大部分需求（pathlib, re, json, datetime），PyYAML 作为唯一依赖处理 frontmatter 解析。脚本可独立运行验证，输出结构化 JSON 供 LLM 消费

### D2: 候选扫描——全量扫描 + 状态过滤

**选择**: 扫描 Note 仓库全部 `*.md`，排除 `.note-to-blog.json` 中已标记的条目（drafted / published / skipped）

**替代方案**:

- 按目录过滤（只扫描 Areas/） → 遗漏有价值内容
- 按字数/日期预筛 → 可能误排好文章

**理由**: 用户明确希望全量扫描、主动标记。候选池随使用逐步收敛。~988 篇 × (标题 + 前 20 行) 的 JSON 大小可控

### D3: 主题簇发现——wikilink 图谱

**选择**: `collect` 子命令扫描所有 `[[wikilink]]` 引用关系，构建有向图，识别被多篇笔记引用的 hub 节点作为主题簇

```json
{
  "clusters": [
    {
      "hub": "Areas/.../优雅的哲学-v2.0.md",
      "hub_title": "优雅的哲学",
      "related": ["Areas/.../思考与反思.md", "Areas/.../关于我.md"],
      "link_count": 9
    }
  ]
}
```

**替代方案**:

- LLM 语义聚类 → 需要读取所有文章内容，token 消耗过大
- 手动标记关联 → 工作量大，不可持续
- 基于目录/标签分组 → Obsidian 笔记的 tags 字段为空，目录不反映主题关联

**理由**: wikilink 是 Obsidian 原生的语义关联信号，提取是纯确定性操作（正则匹配 `[[...]]`），且数据显示存在明显的 hub 节点（如「优雅的哲学」被 9+ 篇引用）

### D4: 双通道模式——用户选择

**选择**: LLM 评估后，推荐列表中混排单篇文章和主题簇，由用户决定每一项走快速通道还是深度通道

```
快速通道: convert(脚本) → Agent 审查 → 草稿 (hidden: true)
深度通道: Agent 读取所有关联笔记 → 主题报告 + 大纲 → 用户决定下一步
```

**替代方案**:

- 所有文章都走深度通道 → 简单文章没必要，浪费时间
- 自动判断走哪个通道 → 用户更希望自己选择

**理由**: 用户明确表示"让我选"。快速通道覆盖独立成篇的文章（多数情况），深度通道处理需要整理关联笔记的主题

### D5: Agent Teams——每篇文章一个全能编辑

**选择**: 用户选 N 项后，并行派发 N 个 Agent，每个 Agent 独立处理一篇文章/主题簇

```
总编 (Main Agent)
├── 编辑 Agent 1: 文章 A (快速通道)
├── 编辑 Agent 2: 文章 B (快速通道)
└── 编辑 Agent 3: 主题簇 C (深度通道)
```

**替代方案**:

- 按角色分工（选题编辑→格式编辑→内容编辑→校对） → 串行处理，对 3 篇文章反而更慢
- 串行逐篇处理 → 不利用并行能力

**理由**: 文章之间没有依赖，天然适合并行。每个 Agent 有完整上下文（该文章原文 + 博客风格），判断更准确。Claude Code 的 Task tool 天然支持并行派发

### D6: 状态模型——新增 drafted 中间态

**选择**: `.note-to-blog.json` 三种状态：drafted / published / skipped

```json
{
  "drafted": {
    "Areas/.../xxx.md": {
      "target": "blog/xxx.md",
      "date": "2026-02-11"
    }
  },
  "published": {
    "Areas/.../yyy.md": {
      "target": "til/yyy.md",
      "date": "2026-02-10"
    }
  },
  "skipped": {
    "Areas/.../zzz.md": {
      "reason": "private",
      "date": "2026-02-09"
    }
  }
}
```

**替代方案**:

- 只有 published / skipped（旧方案） → 无法追踪已转换但未发布的草稿

**理由**: 用户希望跨天异步 review。drafted 状态让 `collect` 排除已转换的笔记，`state status` 可以展示待 review 的草稿列表

### D7: Obsidian 语法转换——沿用旧规则，脚本实现

**选择**: 转换规则沿用旧 design 的 D7（wikilink、callout、inline tag、highlight、comment 等），但从 LLM 执行改为 Python 正则实现

| Obsidian 语法 | 转换结果 | 实现方式 |
|---------------|----------|----------|
| `![[image.png]]` | `![](image.png)` | 正则 |
| `![[image.png\|400]]` | `![](image.png)` | 正则 |
| `[[wikilink]]` | 纯文本 | 正则 |
| `[[wikilink\|display]]` | display 文本 | 正则 |
| `:span[text]{.spoiler}` | `<span class="spoiler">text</span>` | 正则 |
| `> [!type] title` | `> **Type:** title` | 正则 |
| `==highlight==` | `**highlight**` | 正则 |
| `%%comment%%` | 删除 | 正则 |
| `#tag` 行内标签 | 收集到 frontmatter tags + 从正文移除 | 正则 |
| Obsidian frontmatter 字段 | 删除非 bokushi 字段 | PyYAML |

**理由**: 所有规则都是明确的模式匹配，正则实现确定性强、可测试、不会漂移

### D8: collect 输出格式

```json
{
  "candidates": [
    {
      "path": "Areas/大模型(LLM)/关于后LLM时代的代码Review.md",
      "title": "关于后 LLM 时代的代码 Review 的看法",
      "summary": "first 20 non-empty lines...",
      "word_count": 1200,
      "outgoing_links": ["优雅的哲学-v2.0", "费曼学习法"]
    }
  ],
  "clusters": [
    {
      "hub": "Areas/.../优雅的哲学-v2.0.md",
      "hub_title": "优雅的哲学",
      "related": ["Areas/.../思考与反思.md", "Areas/.../关于我.md"],
      "link_count": 9
    }
  ],
  "published_posts": [
    {"title": "SSH Key Management", "tags": ["SSH"], "collection": "til"}
  ],
  "session_keywords": [
    "LLM code review workflow discussion",
    "bokushi blog deployment fix"
  ],
  "stats": {
    "total_scanned": 988,
    "filtered_out": 45,
    "candidates_count": 943
  }
}
```

### D9: LLM 评估——沿用旧方案，输入改为脚本 JSON

**选择**: LLM 评估 prompt 模板沿用旧 design（scoring-criteria.md），但输入不再由 LLM 自己扫描收集，而是直接读取 `collect` 输出的 JSON

**变化**: 推荐列表中新增主题簇类型

```json
[
  {"type": "single", "path": "...", "title": "...", "score": 92, "collection": "blog", ...},
  {"type": "cluster", "hub": "...", "hub_title": "...", "related_count": 9, "theme_summary": "...", ...}
]
```

### D10: 深度通道 Agent 的输出格式

深度通道 Agent 读取主题簇所有笔记后，输出结构化报告：

```markdown
## 主题报告：优雅的哲学

### 涉及笔记 (9 篇)
- 优雅的哲学 v2.0 (hub, 2800字)
- 思考、创作与反思 (1200字)
- ...

### 主题地图
- 核心论点：...
- 子话题 A：...（涉及 3 篇）
- 子话题 B：...（涉及 2 篇）

### 重叠与矛盾
- 笔记 X 和笔记 Y 对「...」的观点不一致
- 笔记 Z 的第二节与笔记 W 内容高度重复

### 缺口
- 缺少对「...」的论证
- 结尾部分多篇笔记都没有写完

### 建议大纲
1. 引言：...
2. 第一部分：...（来源：笔记 A、B）
3. 第二部分：...（来源：笔记 C、需要补充）
4. 结论：...
```

用户基于此报告决定：直接按大纲写、修改大纲、或暂不处理。

## Skill 创建与审查流程

### 流程总览

```
Phase 1        Phase 2         Phase 3           Phase 4          Phase 5          Phase 6
Scripts  ──▶  SKILL.md  ──▶  References  ──▶  Skill Review ──▶ Issue Resolution ──▶ Final
               + refs                         (skill-reviewer)  (用户协商)        Verification
```

### Phase 1: Python 脚本

| Step | 内容 | Gate |
|------|------|------|
| 1.1 | 创建 `scripts/` 目录 | 目录存在 |
| 1.2 | 实现 `collect` 子命令：扫描 + 过滤 + 摘要提取 | 输出有效 JSON |
| 1.3 | 实现 `collect` 的 wikilink 图谱和主题簇发现 | clusters 字段正确 |
| 1.4 | 实现 `collect` 的 session 信号提取 | session_keywords 字段正确 |
| 1.5 | 实现 `collect` 的已发布博文读取 | published_posts 字段正确 |
| 1.6 | 实现 `convert` 子命令：全部 D7 正则规则 | 所有转换规则通过测试 |
| 1.7 | 实现 `state` 子命令：status / draft / publish / skip | 状态正确读写 |
| 1.8 | 终端验证：运行所有子命令 | 输出正确 |

### Phase 2: SKILL.md 重写

| Step | 内容 | Gate |
|------|------|------|
| 2.1 | 研究现有 skill 模式：阅读 `code-sync` 和 `diary-assistant` 的 SKILL.md | 了解脚本集成、交互流程 |
| 2.2 | 编写 frontmatter + 工作流总览 | CSO 合规 |
| 2.3 | 编写 Phase 1~3（collect → evaluate → interact） | 流程完整 |
| 2.4 | 编写 Phase 4 快速通道（Agent 转换+审查） | 流程完整 |
| 2.5 | 编写 Phase 4 深度通道（Agent 研究+大纲） | 流程完整 |
| 2.6 | 编写 Agent Teams 并行派发逻辑 | 编排清晰 |
| 2.7 | 自审：对照 specs 检查覆盖度 | 无遗漏 |

### Phase 3: References 更新

| Step | 内容 | Gate |
|------|------|------|
| 3.1 | 更新 `user-config.md` | 路径配置完整 |
| 3.2 | 更新 `scoring-criteria.md`：新增主题簇评估规则 | prompt 模板完整 |
| 3.3 | `obsidian-conversion.md` 可删除（规则已内化到脚本中），或保留作为文档参考 | 决策明确 |

### Phase 4~6: 同 code-sync 的审查流程

调用 `skill-reviewer` → 逐项与用户协商 → 最终验证

### D11: Level 系统——评估深度选择

**选择**: collect 完成后展示数据规模，用户选 Level 1-3 控制评估深度

| Level | 名称 | 评估方式 | 后续流程 |
|:---:|:---|:---|:---|
| 1 | 浏览 | 无 LLM，候选列表按字数降序展示 | 用户直选 → 全部 fast track |
| 2 | 推荐 | LLM 评估摘要 + 主题簇 → 5-8 推荐 | fast/deep track 分配（原流程） |
| 3 | 深探 | Level 2 + 读取 hub 笔记全文附加到 prompt | fast/deep track，cluster 推荐更准确 |

推荐逻辑：candidates ≤ 10 → 推荐 Level 1；candidates > 10 → 推荐 Level 2。用户明确要求"发现主题"时推荐 Level 3。

**替代方案**:

- 无 Level（旧方案） → 每次都走 LLM 评估，候选少时浪费 token
- 自适应分叉（不让用户选） → 用户失去控制感
- 5 级 Level（如 cli-weekly-report） → note-to-blog 的变量维度少于周报，3 级足够

**理由**: 参考 cli-weekly-report 的 Level 系统。让用户根据数据规模选择投入程度。Level 1 省 token，Level 3 给深度主题探索提供更准确的 hub 内容分析

### D12: `<skill-dir>` 路径规范

**选择**: SKILL.md 中引用自身 scripts/ 时，统一使用 `<skill-dir>/scripts/...` 占位符，不使用裸相对路径 `scripts/...`

**替代方案**:

- 裸相对路径 `scripts/note-to-blog.py`（旧方案） → npx skills 安装后 CWD 不在 skill 目录，执行失败

**理由**: npx skills 安装后 skill 以 symlink 形式存在于 `~/.claude/skills/` 或 `~/.agents/skills/`，CWD 是用户工作目录。`<skill-dir>` 明确提醒 Agent 先解析 skill 安装路径

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| ~988 篇笔记的 collect JSON 过大 | 每篇只取标题 + 前 20 行 + 字数 + outgoing links，预估 ~50KB，可控 |
| 首次运行候选池太大，LLM 评估 token 消耗高 | 摘要输入预估 ~20K tokens（988 篇 × ~20 tokens/篇），在 context 限制内 |
| wikilink 图谱可能有噪声（如日记中的随意引用） | 按 link_count 排序，只推荐 3+ 引用的 hub 节点 |
| 深度通道 Agent 需要读取多篇全文，context 可能不够 | 主题簇通常 3~10 篇，平均 ~1000 字/篇，总量可控 |
| PyYAML 作为外部依赖需要安装 | 明确在 SKILL.md prerequisites 中说明，首次运行时引导安装 |
| Obsidian 语法转换规则遗漏 | 对未识别语法保留原文 + 添加 `<!-- TODO -->` 注释；脚本可后续追加规则 |
| 并行 Agent 写入同一个 `.note-to-blog.json` 可能冲突 | 每个 Agent 返回状态更新指令，由总编统一执行 state 命令 |
| skill-reviewer 发现大量问题 | Phase 5 逐项与用户协商，Medium/Low 可批量跳过 |
