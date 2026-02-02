## Why

`~/code` 下有 28+ 个 git 仓库分布在多个 workspace（nini-dev, ha-dev, homey-dev 等），每天下班前需要确保所有仓库都 push 到远程，上班第一步需要 pull 更新。手动逐个操作不现实，而仓库状态各异（dirty working tree、feature branch、无 upstream 等），简单的 `git push` 循环无法覆盖所有情况。需要一个智能同步工具，确定性操作由脚本完成，模糊决策由 Claude Code 处理。

## What Changes

- **新增 skill**: `code-sync`，提供每日代码同步功能
  - Push 模式（下班前）：扫描所有仓库 → 批量 push 干净仓库 → Claude Code 逐个处理异常
  - Pull 模式（上班时）：fetch + pull --ff-only → Claude Code 处理冲突
- **新增脚本**: `scan.sh`，扫描 `~/code/*/` 和 `~/code/*/repos/*/` 下所有 git 仓库，输出 JSON 状态报告
- **Claude Code 作为主循环**: 脚本只负责扫描，所有决策（dirty repo 怎么处理、冲突怎么解决）由 Claude Code 在当前会话中直接处理

**Explore 阶段参考**:

创建 Skill 类 change 时，explore 阶段应先了解以下 skill 的规范，以确保 proposal 的完整度：

- `writing-skills`: skill 的结构规范、CSO（Claude Search Optimization）、测试方法
- `skill-reviewer`: 审查维度（结构校验、内容质量、兼容性审计）

这些输入决定了 design 中流程的完整度和 tasks 中审查环节的颗粒度。

**涉及仓库**: `repos/skill`

## Capabilities

### New Capabilities

- `code-sync`: 每日代码同步 skill，包含 push/pull 两种模式、扫描脚本、Claude Code 主循环异常处理

### Modified Capabilities

<!-- 无需修改现有 capability -->

## Impact

- **新建**: `repos/skill/skills/code-sync/SKILL.md`, `repos/skill/skills/code-sync/scripts/scan.sh`
- **触发词**: `同步代码` / `code-sync` / `下班同步` / `上班更新`（与 git-workflow 的触发词隔离）
- **依赖**: 无外部依赖，仅使用 git CLI
- **审查依赖**: 实现完成后需调用 `skill-reviewer` 进行质量审计，审查结果动态生成修复任务并与用户逐项协商
- **Rollback**: 删除 `skills/code-sync/` 目录即可
