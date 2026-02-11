## Why

现有 `note-to-blog` skill 将所有操作（文件扫描、frontmatter 解析、Obsidian 语法转换、状态管理）全部写在 SKILL.md 中由 LLM 逐步执行，导致每次运行重复消耗大量 token 做确定性操作，且转换结果不稳定、不可测试。此外，原设计只支持"每次选 1 篇直接转换"的线性流程，不支持批量选题、多篇并行处理、关联笔记聚合等实际需求。

实际 Obsidian 仓库有 ~988 篇笔记（远超原始估计的 ~150 篇），笔记之间通过 wikilink 存在关联关系，许多主题散落在多篇笔记中需要先整理再写作。需要重构为「确定性脚本 + LLM 编排 + Agent 并行」的架构。

## What Changes

- **新增 Python 脚本**: `note-to-blog.py`（唯一依赖 PyYAML），承担所有确定性操作
  - `collect` 子命令：全量扫描 Note 仓库 → 过滤已标记条目 → 提取摘要 → 构建 wikilink 关系图发现主题簇 → 读取已发布博文 → 提取 session 活跃信号 → 输出结构化 JSON
  - `convert` 子命令：Obsidian 语法 → 标准 Markdown 的正则转换（wikilink、callout、inline tag、highlight、comment 等）
  - `state` 子命令：管理 `.note-to-blog.json`（draft / publish / skip 操作 + status 查看）
- **重写 SKILL.md**: 从"全流程指令"变为"编排层"，只负责调用脚本 + 拼接 LLM prompt + 处理交互
- **新增双通道模式**:
  - 快速通道：独立成篇的笔记 → 脚本 convert + Agent 审查 → 草稿
  - 深度通道：散落关联的主题簇 → Agent 读取多篇笔记 → 梳理关系/大纲 → 用户决定下一步
- **新增编辑部模式（Agent Teams）**: 用户选 N 篇/主题后，并行派发 Agent（每篇文章一个），各自独立完成转换+审查+建议
- **状态模型扩展**: `.note-to-blog.json` 新增 `drafted` 状态（已转为草稿但未发布），支持跨天异步 review 工作流
- **删除旧 skill 文件**: 替换 `skills/writing/note-to-blog/` 下的所有现有文件

**涉及仓库**: `repos/skill`

## Capabilities

### New Capabilities

- `note-to-blog`: 重构后的 Obsidian Note 到博客 skill，包含 Python 脚本（collect/convert/state）、SKILL.md 编排层、双通道模式（快速/深度）、Agent Teams 并行处理、主题簇发现、状态持久化

### Modified Capabilities

<!-- 无需修改现有 capability，这是对旧 skill 的完全重写 -->

## Impact

- **替换**: `repos/skill/skills/writing/note-to-blog/SKILL.md` 及全部 `references/`
- **新建**: `repos/skill/skills/writing/note-to-blog/scripts/note-to-blog.py`
- **新建**: Note 仓库根目录 `.note-to-blog.json`（首次运行时自动创建）
- **触发词**: 沿用 `选一篇笔记发博客` / `note to blog` / `写博客` / `博客选题`（与 writing-inspiration 隔离）
- **依赖**: Python 3 + PyYAML（唯一外部依赖）
- **依赖 skill**: `writing-proofreading`（草稿审校，非强依赖）
- **依赖数据**: Obsidian Note 仓库、bokushi 博客 content、Claude Code session 数据
- **审查依赖**: 实现完成后需调用 `skill-reviewer` 进行质量审计
- **Rollback**: 从 archive 恢复旧版 `skills/writing/note-to-blog/` 目录即可；`.note-to-blog.json` 独立保留不影响其他功能
