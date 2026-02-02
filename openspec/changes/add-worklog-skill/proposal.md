## Why

diary-assistant 中的 Work Log 功能与日记流程强耦合，无法独立使用。用户希望在非日记场景下也能进行工作回顾（如单独生成周报、随时查看统计），但目前只能通过写日记触发。同时现有 worklog 只做事实罗列（"做了什么"），缺少量化分析（commit 数、代码增删行数、活跃仓库分布等），无法满足个人开发回顾的需求。

## What Changes

- **新增 skill**: `worklog`，提供独立的工作回顾能力
  - Daily 模式：获取单日工作记录 + 统计
  - Weekly 模式：获取一周工作记录 + 趋势分析
  - 每次独立从 git/API 重算，不依赖中间存储
- **新增脚本**: `stats.sh`（本地 git 统计，输出 JSON）+ `github.sh`（GitHub PR/Issue 活动，通过 `gh` CLI 输出 JSON）
- **数据源整合**: 本地 git 统计（stats.sh）+ GitHub 活动（github.sh）+ 云效 MCP（MR/Bug/任务，agent 运行时直接调 MCP 工具，不脚本化——`aliyun devops` CLI 可靠性不足）
- **输出模板**: 叙事 + 表格混合格式。按工作主题分组（非数据源分组），MR/PR 按主题合并行（不逐条列），Bug 逐条列。包含概览引用行、commit 分布图（ASCII）、亮点
- **重构 diary-assistant**: Work Log 步骤改为调用 worklog skill，删除 `references/worklog-automation.md`，数据源配置迁移到 worklog skill

**涉及仓库**: `repos/skill`

## Capabilities

### New Capabilities

- `worklog`: 个人工作回顾 skill，包含 daily/weekly 两种模式、本地 git 统计脚本、多数据源整合、结构化模板输出

### Modified Capabilities

- `code-sync`: 无需修改（worklog 复用 scan.sh 的仓库发现逻辑，但统计由独立的 stats.sh 完成）

## Impact

- **新建**: `repos/skill/skills/worklog/SKILL.md`, `repos/skill/skills/worklog/scripts/stats.sh`, `repos/skill/skills/worklog/scripts/github.sh`, `repos/skill/skills/worklog/references/template.md`, `repos/skill/skills/worklog/references/user-config.md`
- **修改**: `repos/skill/skills/diary-assistant/SKILL.md`（Work Log 步骤改为调用 worklog skill）
- **删除**: `repos/skill/skills/diary-assistant/references/worklog-automation.md`（迁移到 worklog skill）
- **修改**: `repos/skill/skills/diary-assistant/references/user-config.md`（移除数据源配置，保留日记配置）
- **触发词**: `工作回顾` / `日报` / `周报` / `worklog`（与 diary-assistant 的触发词隔离）
- **依赖 skill**: `yunxiao`（云效数据获取）
- **依赖工具**: `gh` CLI（GitHub 数据获取）、`git`（本地统计）
- **审查依赖**: 实现完成后需调用 `skill-reviewer` 进行质量审计
- **Rollback**: 删除 `skills/worklog/` 目录，恢复 diary-assistant 原有 worklog 逻辑
