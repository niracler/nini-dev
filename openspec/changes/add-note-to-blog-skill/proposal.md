## Why

Obsidian Note 仓库中积累了 ~150 篇笔记，其中不少完成度高、观点独特的文章适合稍加改写后发布到 bokushi 博客。但目前缺乏系统化的方式来筛选、评估和转换这些笔记。每周想写一篇博文时，往往不知道从哪篇开始，也容易遗漏成熟的素材。需要一个 skill 来自动化「选题→评估→格式转换→草稿生成」的流程，并利用 Claude Code session 历史作为活跃度信号，推荐近期关注的话题。

## What Changes

- **新增 skill**: `note-to-blog`，提供 Obsidian Note → bokushi Blog 的选题和转换功能
  - Phase 1 收集：扫描 Note 仓库全部 *.md + 读取近 30 天 session 活跃信号 + 读取 blog/til/monthly 已发布列表
  - Phase 2 评估：LLM 一次调用，输出 Top 5~8 推荐（适配分、目标 collection、工作量、session 活跃度）
  - Phase 3 交互：用户选一篇 / 批量标记 skip（不适合发布的笔记）
  - Phase 4 转换：Obsidian 语法转标准 Markdown + 生成 frontmatter + 基本可读性修复 → 写入 bokushi 作为草稿 (`hidden: true`)
- **新增状态文件**: Note 仓库根目录 `.note-to-blog.json`，持久化存储已发布 (published) 和已跳过 (skipped) 的标记
- **与 writing-proofreading 联动**: 草稿生成后，用户可单独运行 `/writing-proofreading` 进行 6 步审校，完成后改 `hidden: false` 发布

**涉及仓库**: `repos/skill`

## Capabilities

### New Capabilities

- `note-to-blog`: Obsidian Note 到博客的选题推荐、语义去重、格式转换和草稿生成 skill，包含 Note 扫描、session 活跃度分析、LLM 评估打分、Obsidian 语法转换、状态持久化

### Modified Capabilities

<!-- 无需修改现有 capability -->

## Impact

- **新建**: `repos/skill/skills/note-to-blog/SKILL.md`, `repos/skill/skills/note-to-blog/references/user-config.md`, `repos/skill/skills/note-to-blog/references/obsidian-conversion.md`, `repos/skill/skills/note-to-blog/references/scoring-criteria.md`
- **新建**: Note 仓库根目录 `.note-to-blog.json`（首次运行时自动创建）
- **触发词**: `选一篇笔记发博客` / `note to blog` / `写博客` / `博客选题`
- **依赖 skill**: `writing-proofreading`（草稿审校，非强依赖）
- **依赖数据**: Obsidian Note 仓库路径、bokushi 博客 content 路径、`~/.claude/projects/` 下的 `sessions-index.json` 和 `~/.claude/history.jsonl`
- **目标 collection**: LLM 自动判断写入 `blog/`、`til/` 或 `monthly/`
- **审查依赖**: 实现完成后需调用 `skill-reviewer` 进行质量审计
- **Rollback**: 删除 `skills/note-to-blog/` 目录即可，`.note-to-blog.json` 独立保留不影响其他功能
