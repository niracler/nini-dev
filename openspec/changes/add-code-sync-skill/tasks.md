# Tasks: add-code-sync-skill

> **流程**: Phase 1 → 2 → 3 → 4 (动态) → 5，每个 Phase 有 Gate 条件，通过后才进入下一阶段。

## Phase 1: scan.sh 脚本

- [x] 1.1 创建 `repos/skill/skills/code-sync/scripts/` 目录结构
- [x] 1.2 实现 `scan.sh` 核心扫描逻辑：遍历 `~/code/*/` 和 `~/code/*/repos/*/`，识别 git 仓库，跳过非 git 目录
- [x] 1.3 实现 JSON 输出：path, name, branch, remote, remote_url, dirty_count, has_upstream, ahead, behind
- [x] 1.4 实现 `--fetch` 参数：扫描前 `git fetch`，超时 10 秒，失败标记 `fetch_error: true` 并继续
- [x] 1.5 终端验证：运行 `scan.sh` 和 `scan.sh --fetch`，确认 JSON 输出正确且覆盖全部仓库

**Gate**: `scan.sh` 输出有效 JSON，覆盖全部 28 个仓库

## Phase 2: SKILL.md 编写

- [x] 2.1 研究现有 skill 模式：阅读 `git-workflow` 和 `schedule-manager` 的 SKILL.md，了解触发词写法和工作流组织方式
- [x] 2.2 编写 frontmatter：name (`code-sync`) + description（符合 CSO 规范，"Use when..." 开头，包含触发词 `同步代码` / `code-sync` / `下班同步` / `上班更新`）
- [x] 2.3 编写 Push 模式完整工作流（扫描 → 分类 → 批量 push → 异常处理 → 汇总）
- [x] 2.4 编写 Pull 模式完整工作流（fetch+扫描 → 分类 → 批量 pull → 异常处理 → 汇总）
- [x] 2.5 编写异常处理指引（dirty repo 检查流程、ff-only 失败处理、无 upstream 处理）
- [x] 2.6 编写汇总报告格式（push: pushed/up-to-date/resolved/skipped，pull: updated/up-to-date/resolved/skipped）
- [x] 2.7 自审：对照 specs/code-sync/spec.md 逐项检查所有 requirement 和 scenario 是否覆盖

**Gate**: SKILL.md 完整覆盖 specs 中所有 requirement

## Phase 3: Skill Review（skill-reviewer）

> 调用 `skill-reviewer` skill 对完成的 skill 进行 4 步审查。

- [x] 3.1 结构校验：运行 `repos/skill/scripts/validate.sh` 确认 skill 格式合规
- [x] 3.2 内容质量：调用 `writing-skills` 进行深度审查（token 效率、渐进式披露、反模式、CSO 合规）
- [x] 3.3 兼容性审计：按 skill-reviewer checklist 逐项检查——跨平台 (3a)、跨 Agent (3b)、npx skills 生态 (3c)、工具引用规范 (3d)
- [x] 3.4 输出审查报告：按 Critical / High / Medium / Low 分级汇总所有发现

**Gate**: 审查报告已生成

## Phase 4: Issue Resolution（🔍 用户协商）

> 此阶段的具体 tasks **在 Phase 3 审查报告生成后动态填充**。
>
> 每个 Critical/High issue 将作为独立 task，流程为：
>
> 1. 描述问题（是什么、影响范围）
> 2. 提出修复方案（可能多个选项）
> 3. 🔍 用户决策（选方案 / 跳过 / 其他）
> 4. 执行修复
>
> Medium/Low issues 列出清单，🔍 用户批量决定哪些需要处理。

- [x] 4.1 Critical: marketplace.json 注册 code-sync 到 workflow-skills 组
- [x] 4.2 High: CSO description 移除工作流摘要，只保留触发条件
- [x] 4.3 High: Token 效率优化（869 → 450 words），合并 Push/Pull 共享结构
- [x] 4.4 Medium/Low: 用户决定全部跳过（scan.sh 无 Windows 替代、路径硬编码）

**Gate**: 所有 Critical/High 已解决或用户明确跳过

## Phase 5: Final Verification

- [x] 5.1 重跑 `repos/skill/scripts/validate.sh` 确认修复后 skill 格式仍然合规
- [ ] 5.2 新会话测试触发词：说「同步代码」确认触发 code-sync 而非 git-workflow（需新会话）
- [ ] 5.3 新会话测试 Push 模式：完整执行一次 push 流程（需新会话）
- [ ] 5.4 新会话测试 Pull 模式：完整执行一次 pull 流程（需新会话）
