## Context

`repos/skill` 仓库使用 `.claude-plugin/marketplace.json` 管理 skill 注册，目录结构为 `src/<skill-name>/SKILL.md`。用户希望同时支持 `npx skills add`（Vercel Labs 的跨 agent skill 安装工具），并保留现有 Claude marketplace 安装方式。

当前 SKILL.md 文件已符合 `npx skills` 格式要求（YAML frontmatter 含 `name` + `description`），唯一的问题是目录名。

## Goals / Non-Goals

**Goals:**
- `npx skills add niracler/skill` 能通过标准路径发现所有 skills
- `claude plugin marketplace add` 继续正常工作
- 开发工具（validate.sh、init_skill.py）继续正常工作

**Non-Goals:**
- 不迁移 SKILL.md 内容格式（已兼容）
- 不移除 `.claude-plugin/marketplace.json`（保持共存）
- 不添加 `package.json` 或其他 npm 生态文件

## Decisions

### D1: 目录重命名 `src/` → `skills/`

**选择**：直接重命名为 `skills/`
**替代方案**：
- 保留 `src/` 依赖递归回退搜索 → 不够规范，首次搜索会 miss
- 创建 symlink `skills -> src` → 增加复杂性，git 处理 symlink 不稳定

**理由**：`skills/` 是 `npx skills` 的标准搜索目录，零歧义。`src/` 对于纯 Markdown skill 集合来说语义也不够准确。

### D2: 路径引用统一更新

所有引用 `src/` 的文件同步更新为 `skills/`：
- `.claude-plugin/marketplace.json`（4 个 plugin 的 skills 数组）
- `scripts/validate.sh`（glob 模式）
- `README.md`（安装说明、结构图、开发命令）

`scripts/init_skill.py` 使用 `--path` 参数，无需改动。

## Risks / Trade-offs

- **已 clone 的用户需要重新拉取** → 个人仓库，影响面极小
- **两套安装系统维护** → skill 内容只有一份，入口两个，维护成本可控
