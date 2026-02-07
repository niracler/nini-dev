# Tasks: add-note-to-blog-skill

> **流程**: Phase 1 → 2 → 3 → 4 (动态) → 5，每个 Phase 有 Gate 条件，通过后才进入下一阶段。

## Phase 1: SKILL.md 编写

- [x] 1.1 创建 `repos/skill/skills/note-to-blog/references/` 目录结构
- [x] 1.2 研究现有 skill 模式：阅读 `diary-assistant` 和 `worklog` 的 SKILL.md，了解多数据源整合、交互式流程和关联 skill 调用的写法
- [x] 1.3 编写 frontmatter：name (`note-to-blog`) + description（CSO 规范，"Use when..." 开头，包含触发词 `选一篇笔记发博客` / `note to blog` / `写博客` / `博客选题`）
- [x] 1.4 编写 Phase 1 收集工作流：扫描 Note 仓库 → 读取 `.note-to-blog.json` 过滤 → 提取候选摘要 → 读取 session 活跃信号 → 读取已发布博文列表
- [x] 1.5 编写 Phase 2 评估工作流：构造 LLM 评估 prompt → 一次调用 → 解析 JSON 推荐列表
- [x] 1.6 编写 Phase 3 交互工作流：展示推荐列表 → 选择/标记 skip → 读取全文确认 → 用户可覆盖 collection
- [x] 1.7 编写 Phase 4 转换工作流：Obsidian 语法转换 → frontmatter 生成 → 基本可读性修复 → 写入 bokushi（hidden: true）→ 更新 `.note-to-blog.json`
- [x] 1.8 编写 writing-proofreading 联动提示（草稿完成后建议用户运行审校）
- [x] 1.9 自审：对照 specs/note-to-blog/spec.md 逐项检查所有 requirement 和 scenario 是否覆盖

**Gate**: SKILL.md 完整覆盖 specs 中所有 requirement

## Phase 2: References 编写

- [x] 2.1 编写 `references/user-config.md`：Note 仓库路径、bokushi 博客路径、Claude Code 项目数据路径映射（支持多项目）、session 时间窗口（默认 30 天）
- [x] 2.2 编写 `references/obsidian-conversion.md`：design D7 定义的全部转换规则表 + 每条规则的输入/输出示例 + 未覆盖语法的兜底策略
- [x] 2.3 编写 `references/scoring-criteria.md`：LLM 评估 prompt 完整模板、评分维度定义（完成度/独特性/时效性/结构性）、session 活跃度加分规则、collection 判断规则（blog/til/monthly 的特征表）、输出 JSON schema

**Gate**: 三个 references 文件与 SKILL.md 一致，无遗漏

## Phase 3: Skill Review（skill-reviewer）

> 调用 `skill-reviewer` skill 对完成的 skill 进行 4 步审查。

- [x] 3.1 结构校验：运行 validate.sh 确认 skill 格式合规 → PASS
- [ ] 3.2 内容质量：调用 `writing-skills` 进行深度审查 → 跳过（可后续独立运行）
- [x] 3.3 兼容性审计：按 skill-reviewer checklist 逐项检查 → 1 Critical, 2 High, 1 Medium
- [x] 3.4 输出审查报告：按 Critical / High / Medium / Low 分级汇总所有发现

**Gate**: 审查报告已生成 ✓

## Phase 4: Issue Resolution

- [x] 4.1 **Critical**: marketplace.json 未注册 → 已添加到 writing-skills group
- [x] 4.2 **High**: 跨 skill 依赖不在同 group → 随 4.1 修复自动解决
- [x] 4.3 **High**: `/writing-proofreading` Skill 调用语法 → 保持现状（仅建议性文案）
- [x] 4.4 **Medium**: user-config.md hardcoded macOS 路径 → 已添加平台说明注释

**Gate**: 所有 Critical/High 已解决或用户明确跳过 ✓

## Phase 5: Final Verification

- [x] 5.1 重跑 validate.sh 确认修复后 skill 格式仍然合规 → PASS
- [ ] 5.2 新会话测试触发词：说「选一篇笔记发博客」确认触发 note-to-blog 而非 writing-inspiration（⚠️ 需新会话）
- [ ] 5.3 新会话测试完整流程：执行一次完整的 Phase 1~4，验证扫描 → 评估 → 选择 → 转换 → 草稿生成（⚠️ 需新会话）
- [ ] 5.4 验证 `.note-to-blog.json` 状态更新：确认 published 标记正确写入，下次运行时该文件被排除（⚠️ 需新会话）
