## Context

13 个 skill 的外部依赖声明存在 6 种不同模式：专门章节、前置条件章节、description 标注、依赖 Skill 章节、内联工具选择、完全隐式。用户安装 skill 后执行失败时，Claude 无法快速定位安装方法。

schedule-manager 已有最完整的模式（专门的检查脚本 + 依赖章节），但格式与其他 skill 不一致。

## Goals / Non-Goals

**Goals:**

- 每个 SKILL.md 在 body 开头有统一格式的 Prerequisites 表格
- Claude 在执行失败时能查表找到安装命令并引导用户
- skill-reviewer 能自动审查 Prerequisites 格式
- README 汇总展示所有 skill 的外部依赖

**Non-Goals:**

- 不做启动时预检（被动检查，失败时才触发）
- 不新增检查脚本（现有的 schedule-manager 检查脚本保留但不推广）
- 不修改 SKILL.md frontmatter 格式（保持标准兼容）
- 不修改 skill 的核心逻辑

## Decisions

### 1. Prerequisites 表格格式

**决定**: 固定 4 列表格 — Tool / Type / Required / Install

```markdown
## Prerequisites

| Tool | Type | Required | Install |
|------|------|----------|---------|
| reminders-cli | cli | Yes | `brew install keith/formulae/reminders-cli` |
| yunxiao MCP | mcp | No | See MCP config docs |
| schedule-manager | skill | Yes | Included in `npx skills add niracler/skill` |
```

表格后可选跟一段简短说明（平台限制、权限配置等）。

**替代方案**:

- 5 列加 Notes → 表格太宽，Markdown 渲染差
- 只列名称不列安装方式 → Claude 无法引导安装
- YAML 代码块 → 人类不友好

**理由**: 4 列平衡了信息量和可读性。Type 列让 Claude 区分处理方式（cli 可以 `which` 检测，mcp 需要检查工具列表，skill 需要检查是否已安装）。

### 2. Type 分类标准

**决定**: 4 种类型 — `cli` / `mcp` / `skill` / `system`

| Type | 含义 | Claude 检测方式 |
|------|------|----------------|
| cli | 命令行工具 | `which <tool>` 或 `command -v` |
| mcp | MCP 服务器 | 检查可用的 MCP 工具列表 |
| skill | 其他 Claude Code skill | 检查 skill 是否已加载 |
| system | 操作系统/平台要求 | `uname` 或环境检测 |

**替代方案**:

- 不分类 → Claude 不知道怎么检测
- 更细粒度（npm/brew/pip）→ 过度分类，安装方式已在 Install 列说明

### 3. 无依赖的 skill 处理

**决定**: 不加 Prerequisites 章节。skill-reviewer 只在有外部依赖时要求此章节。

**替代方案**:

- 加空表格 `No external dependencies` → 冗余
- 所有 skill 都必须有 → 增加噪音

**理由**: `anki-card-generator`、`zaregoto-miko`、`writing-inspiration` 无外部依赖，强制加章节无意义。

### 4. 旧格式清理策略

**决定**: 合并到 Prerequisites 表格后删除旧章节，保留非依赖内容（如权限配置步骤）移到表格下方作为补充说明。

受影响的 skill：

| Skill | 旧格式 | 处理方式 |
|-------|--------|---------|
| schedule-manager | `## 依赖与权限` | 依赖信息移入表格，权限配置保留为表格下方说明 |
| markdown-lint | `## 前置条件` | 合并为表格 |
| diary-assistant | `## 依赖 Skill` + description 标注 | 合并为表格，description 标注保留 |
| worklog | 散落在正文 | 汇总为表格 |
| yunxiao | `## 工具选择` 表格 | 工具选择逻辑保留，依赖信息提取到 Prerequisites |

### 5. skill-reviewer 审查规则

**决定**: 新增 2 条审查项

1. **有外部依赖的 skill 必须有 `## Prerequisites` 章节**（位于 body 最前面的 `##` 章节）
2. **表格必须包含 Tool / Type / Required / Install 四列**

不审查内容正确性（人工负责），只审查格式。

### 6. README 依赖展示

**决定**: 在现有 skill 表格增加 Dependencies 列，只列关键外部依赖（cli + mcp），不列 skill 间依赖（已有架构图）。

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| 表格同步问题：依赖变了忘记更新表格 | skill-reviewer 检查格式，但内容正确性靠人工 |
| Install 命令跨平台差异 | 表格只列推荐安装方式，补充说明列备选方案 |
| 无依赖 skill 以后加了依赖忘记加章节 | skill-reviewer 审查时应提醒（需要人工判断） |
