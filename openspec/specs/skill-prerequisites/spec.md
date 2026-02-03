## ADDED Requirements

### Requirement: Prerequisites table format

每个有外部依赖的 SKILL.md SHALL 在 body 最前面包含 `## Prerequisites` 章节，章节内 MUST 包含一个 4 列 Markdown 表格，列为 Tool / Type / Required / Install。

#### Scenario: Skill with CLI and MCP dependencies

- **WHEN** skill 依赖 CLI 工具和 MCP 服务器
- **THEN** Prerequisites 表格 MUST 列出每个依赖，Type 列分别标注 `cli` 和 `mcp`

#### Scenario: Skill with no external dependencies

- **WHEN** skill 不依赖任何外部工具（如 anki-card-generator）
- **THEN** 不需要 Prerequisites 章节

### Requirement: Type classification

Type 列 MUST 使用以下 4 种值之一：`cli`（命令行工具）、`mcp`（MCP 服务器）、`skill`（其他 Claude Code skill）、`system`（操作系统/平台要求）。

#### Scenario: macOS-only skill

- **WHEN** skill 仅限 macOS 使用（如 schedule-manager）
- **THEN** 表格 MUST 包含一行 Type 为 `system` 的条目标注平台要求

#### Scenario: Optional MCP dependency

- **WHEN** skill 可选依赖 MCP 服务器（如 worklog 可选 yunxiao MCP）
- **THEN** 表格中该行 Required 列 MUST 为 `No`，Install 列 MUST 提供配置指引或替代方案

### Requirement: Passive dependency detection

Prerequisites 表格用于被动错误恢复，不用于主动预检。Claude SHALL 仅在执行命令失败时查阅表格。

#### Scenario: Command not found during skill execution

- **WHEN** skill 执行过程中某命令返回 "command not found"
- **THEN** Claude SHALL 查阅 Prerequisites 表格找到对应工具的安装命令，并询问用户是否要安装

#### Scenario: MCP tool not available

- **WHEN** skill 尝试使用 MCP 工具但不可用
- **THEN** Claude SHALL 查阅 Prerequisites 表格，如果 Required 为 `No` 则使用替代方案继续，如果为 `Yes` 则引导用户配置

### Requirement: Legacy format cleanup

现有的旧格式依赖声明（`依赖与权限`、`前置条件`、`依赖 Skill` 等章节）MUST 合并到 Prerequisites 表格后删除。非依赖内容（如权限配置步骤）MAY 保留在表格下方作为补充说明。

#### Scenario: Schedule-manager migration

- **WHEN** schedule-manager 的 `依赖与权限` 章节被迁移
- **THEN** 依赖信息移入 Prerequisites 表格，权限配置步骤保留在表格下方

#### Scenario: Markdown-lint migration

- **WHEN** markdown-lint 的 `前置条件` 章节被迁移
- **THEN** 所有安装命令合并到 Prerequisites 表格，原章节删除

### Requirement: skill-reviewer validation

skill-reviewer MUST 检查有外部依赖的 SKILL.md 是否包含标准格式的 Prerequisites 章节。

#### Scenario: Missing Prerequisites section

- **WHEN** skill-reviewer 审查一个使用了外部 CLI 或 MCP 工具的 skill
- **AND** SKILL.md 不包含 `## Prerequisites` 章节
- **THEN** 审查报告 MUST 标记为警告，提示需要添加 Prerequisites

#### Scenario: Malformed Prerequisites table

- **WHEN** Prerequisites 章节存在但表格不包含 Tool / Type / Required / Install 四列
- **THEN** 审查报告 MUST 标记为错误

### Requirement: README dependency overview

README.md 的 skill 列表表格 MUST 包含 Dependencies 列，展示各 skill 的关键外部依赖（CLI 和 MCP）。

#### Scenario: Skill with multiple dependencies

- **WHEN** skill 依赖多个外部工具（如 worklog 依赖 git、gh、jq）
- **THEN** Dependencies 列列出主要依赖，用逗号分隔

#### Scenario: Skill with no dependencies

- **WHEN** skill 无外部依赖
- **THEN** Dependencies 列显示 `—`
