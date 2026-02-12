# Tasks: refactor-note-to-blog-skill

> **流程**: Phase 1 → 2 → 3 → 4 → 5 (动态) → 6，每个 Phase 有 Gate 条件，通过后才进入下一阶段。
> **分支策略**: 单 PR 交付（变更集中在 `repos/skill/skills/writing/note-to-blog/`）。

## Phase 1: Python 脚本 (`note-to-blog.py`)

- [x] 1.1 创建 `repos/skill/skills/writing/note-to-blog/scripts/` 目录，初始化 `note-to-blog.py` 骨架（argparse 子命令结构：collect / convert / state）
- [x] 1.2 实现 `collect` 核心扫描：遍历 Note 仓库全部 `*.md`，读取 `.note-to-blog.json` 过滤 drafted/published/skipped 条目
- [x] 1.3 实现 `collect` 摘要提取：解析 frontmatter（PyYAML）、提取标题、截取前 20 行、统计字数、提取 outgoing `[[wikilink]]`
- [x] 1.4 实现 `collect` wikilink 图谱：构建有向图，识别被 3+ 篇引用的 hub 节点，输出 `clusters` 数组
- [x] 1.5 实现 `collect` session 信号提取：读取 `sessions-index.json` 和 `history.jsonl`，过滤近 30 天条目，输出 `session_keywords`
- [x] 1.6 实现 `collect` 已发布博文读取：扫描 bokushi `blog/`、`til/`、`monthly/` 的 frontmatter，输出 `published_posts`
- [x] 1.7 实现 `collect` 完整 JSON 输出：整合 candidates + clusters + published_posts + session_keywords + stats
- [x] 1.8 实现 `convert` 子命令：所有 Obsidian 语法正则转换（wikilink、image embed、callout、highlight、comment、inline tag 收集）
- [x] 1.9 实现 `convert` frontmatter 转换：剥离 Obsidian 字段，生成 bokushi 兼容 frontmatter（title、pubDate、tags、hidden:true），不含 description
- [x] 1.10 实现 `state status`：读取 `.note-to-blog.json`，输出 drafted/published/skipped 统计和 drafted 列表
- [x] 1.11 实现 `state draft`：标记笔记为 drafted，记录 target 路径和日期
- [x] 1.12 实现 `state publish`：将 drafted 条目移动到 published
- [x] 1.13 实现 `state skip`：标记笔记为 skipped，记录 reason 和日期
- [x] 1.14 终端验证：运行 `collect`、`convert`、`state` 全部子命令，确认输出正确

**Gate**: 三个子命令均能正确执行，`collect` 输出有效 JSON，`convert` 正确转换 Obsidian 语法，`state` 正确读写 `.note-to-blog.json`

## Phase 2: SKILL.md 重写

- [x] 2.1 研究现有 skill 模式：阅读 `code-sync` 和 `diary-assistant` 的 SKILL.md，了解脚本集成写法和交互式流程组织
- [x] 2.2 编写 frontmatter + Prerequisites（PyYAML 安装引导）+ Workflow Overview（总览图）
- [x] 2.3 编写 Phase 1 Collect：调用 `note-to-blog.py collect`，读取 JSON 输出
- [x] 2.4 编写 Phase 2 Evaluate：LLM 评估 prompt 构造（引用 scoring-criteria.md），混排单篇和主题簇推荐
- [x] 2.5 编写 Phase 3 Interact：展示推荐列表（单篇 + 主题簇混排），批量选择、skip 标记、track 分配（快速/深度）、collection 覆盖
- [x] 2.6 编写 Phase 4 快速通道：Agent 调用 `convert` 脚本 → 审查内容 → 生成 description → 写草稿 → 返回 review feedback
- [x] 2.7 编写 Phase 4 深度通道：Agent 读取主题簇所有笔记 → 输出研究报告（主题地图、重叠/矛盾、缺口、建议大纲）
- [x] 2.8 编写 Agent Teams 并行派发逻辑：N 个 Agent 并行执行，总编收集结果，统一执行 `state` 更新
- [x] 2.9 编写 Phase 5 Summary：汇总所有 Agent 结果，展示草稿位置和建议
- [x] 2.10 自审：对照 specs/note-to-blog/spec.md 逐项检查所有 requirement 和 scenario 是否覆盖

**Gate**: SKILL.md 完整覆盖 specs 中所有 requirement，脚本调用路径正确

## Phase 3: References 更新

- [x] 3.1 更新 `references/user-config.md`：Note 仓库路径、bokushi 路径、session 数据路径
- [x] 3.2 更新 `references/scoring-criteria.md`：新增主题簇评估规则（type: cluster 的评分维度和输出格式）
- [x] 3.3 决定 `references/obsidian-conversion.md` 去留：规则已内化到脚本中，可删除或保留为文档参考

**Gate**: references 与 SKILL.md 一致，无遗漏

## Phase 4: Skill Review（skill-reviewer）

> 调用 `skill-reviewer` skill 对完成的 skill 进行 4 步审查。

- [x] 4.1 结构校验：运行 `repos/skill/scripts/validate.sh` 确认 skill 格式合规
- [x] 4.2 内容质量：调用 `writing-skills` 进行深度审查（token 效率、渐进式披露、反模式、CSO 合规）
- [x] 4.3 兼容性审计：按 skill-reviewer checklist 逐项检查——跨平台、跨 Agent、npx skills 生态、工具引用规范
- [x] 4.4 输出审查报告：按 Critical / High / Medium / Low 分级汇总所有发现

**Gate**: 审查报告已生成

## Phase 5: Issue Resolution（🔍 用户协商）

> 此阶段的具体 tasks **在 Phase 4 审查报告生成后动态填充**。
>
> 每个 Critical/High issue 将作为独立 task，流程为：
>
> 1. 描述问题（是什么、影响范围）
> 2. 提出修复方案（可能多个选项）
> 3. 🔍 用户决策（选方案 / 跳过 / 其他）
> 4. 执行修复
>
> Medium/Low issues 列出清单，🔍 用户批量决定哪些需要处理。

**Gate**: 所有 Critical/High 已解决，Medium/Low 用户选择跳过

## Phase 5b: Level 系统 + 路径规范

> 基于 skill-review 后的设计迭代（D11、D12），修改 SKILL.md 和 references。

- [x] 5b.1 重构 SKILL.md 流程：collect 后插入 Level 选择步骤，展示数据规模 + Level 1-3 菜单 + 推荐逻辑
- [x] 5b.2 实现 Level 1 浏览分支：跳过 LLM 评估，候选列表按字数降序展示，用户直选 → fast track
- [x] 5b.3 实现 Level 3 深探分支：在 Level 2 基础上，增加读取 hub 笔记全文附加到 LLM prompt 的指令
- [x] 5b.4 统一路径引用：SKILL.md 和 agent-instructions.md 中所有 `scripts/` 引用改为 `<skill-dir>/scripts/...`
- [x] 5b.5 更新 scoring-criteria.md：Level 3 的 prompt 模板增加 hub 全文输入格式说明

**Gate**: Level 1/2/3 流程在 SKILL.md 中清晰分叉，所有脚本路径使用 `<skill-dir>` 前缀

## Phase 6: Final Verification

- [x] 6.1 重跑 `repos/skill/scripts/validate.sh` 确认修复后 skill 格式仍然合规
- [ ] 6.2 新会话测试触发词：说「选一篇笔记发博客」确认触发 note-to-blog 而非 writing-inspiration（⚠️ 需新会话）
- [ ] 6.3 新会话测试完整流程：执行一次 collect → evaluate → select → fast track convert → 草稿生成（⚠️ 需新会话）
- [ ] 6.4 新会话测试深度通道：选一个主题簇走深度通道，确认研究报告输出正确（⚠️ 需新会话）
- [x] 6.5 验证 `.note-to-blog.json` 状态：确认 drafted 标记正确写入，下次 collect 时被排除（✓ 端到端验证通过）
