## Why

`repos/skill` 仓库目前只支持通过 `claude plugin marketplace add` 安装，限于 Claude Code 用户。`npx skills`（Vercel Labs）已成为跨 agent 的 skill 安装标准，支持 30+ 种 agent。添加 `npx skills` 支持可以让 skill 集合被更广泛地发现和使用，同时保留现有 Claude 生态的安装方式。

## What Changes

- 将 `src/` 目录重命名为 `skills/`，匹配 `npx skills` 的标准搜索路径
- 更新 `.claude-plugin/marketplace.json` 中的路径引用（`./src/...` → `./skills/...`）
- 更新 `scripts/validate.sh` 中的路径（`src/*/SKILL.md` → `skills/*/SKILL.md`）
- 更新 `README.md`：安装说明添加 `npx skills` 方式、目录结构图更新路径、开发命令更新路径

**涉及仓库**：`repos/skill`

## Capabilities

### New Capabilities

- `npx-skills-install`: 支持通过 `npx skills add niracler/skill` 安装 skill 集合，与现有 marketplace 安装方式共存

### Modified Capabilities

（无现有 spec 需要修改）

## Impact

- **目录结构**：`src/` → `skills/`，纯重命名，skill 内容不变
- **现有安装方式**：`claude plugin marketplace add` 继续工作（更新 marketplace.json 路径即可）
- **开发工具**：`validate.sh` 和 `init_skill.py`（后者使用 `--path` 参数，无需改动）
- **Rollback**：重命名回 `skills/` → `src/` 并还原路径引用即可
