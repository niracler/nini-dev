## Why

当前 13 个 skill 的依赖声明方式不统一（有 6 种不同模式），部分 skill 完全不声明外部依赖。用户安装后首次使用才发现缺少 CLI 工具或 MCP 配置，体验差。需要标准化依赖声明格式，让 Claude 在执行失败时能自动查表并引导安装。

## What Changes

- **标准化 Prerequisites 章节**：每个 SKILL.md body 开头统一加 `## Prerequisites` 表格，声明 CLI、MCP、skill 依赖及安装方式
- **去除冗余格式**：删除现有的 `依赖与权限`、`前置条件`、散落在正文中的安装说明等旧格式，合并到 Prerequisites 表格
- **更新 skill-reviewer**：新增审查项，检查 SKILL.md 是否包含标准格式的 Prerequisites 章节
- **更新 README**：在 skill 列表中展示各 skill 的关键外部依赖

## Capabilities

### New Capabilities

- `skill-prerequisites`: 标准化的 Prerequisites 声明格式规范，包括表格结构、Type 分类标准（cli/mcp/skill/other）、被动检查策略

### Modified Capabilities

<!-- 无需修改现有 spec，这是新增规范 -->

## Impact

- **仓库**: `repos/skill`
- **改动文件**: 13 个 SKILL.md（全部 skill）+ 1 个 README.md + skill-reviewer SKILL.md
- **不影响**: skill 的核心逻辑不变，只增加/替换依赖声明章节
- **Rollback**: 删除 Prerequisites 章节、恢复旧格式即可，无数据风险
