# Tasks: add-worklog-skill

> **流程**: Phase 1 → 2 → 3 → 4 → 5 → 6 (动态) → 7，每个 Phase 有 Gate 条件，通过后才进入下一阶段。
> **交付策略**: 单 PR 交付（变更集中在 `repos/skill`，涉及新增 + 小范围修改）。

## Phase 1: stats.sh 脚本 ✅

- [x] 1.1 创建 `repos/skill/skills/worklog/scripts/` 目录结构
- [x] 1.2 实现仓库扫描逻辑：遍历 `~/code/*/` 和 `~/code/*/repos/*/`，识别 git 仓库，跳过非 git 目录
- [x] 1.3 实现参数解析：`--since YYYY-MM-DD`（必须）、`--until YYYY-MM-DD`（必须）、`--author <name|email>`（可选，默认 `git config user.name`）
- [x] 1.4 实现 per-repo 统计：使用 `git log --numstat` 聚合 commits、insertions、deletions、files_changed、authors、first_commit、last_commit
- [x] 1.5 实现 JSON 输出：period + repos 数组 + totals（repos_active, repos_scanned, commits, insertions, deletions）
- [x] 1.6 处理边界情况：零 commit 仓库排除出 repos 数组但计入 repos_scanned，非 git 目录静默跳过
- [x] 1.7 终端验证：运行 `stats.sh --since <today> --until <today>` 和 `stats.sh --since <week-start> --until <today>`，确认 JSON 输出正确

**Gate**: stats.sh 输出符合 design D2 定义的 JSON 结构，覆盖所有仓库

## Phase 2: github.sh 脚本 ✅

- [x] 2.1 实现参数解析：`--since YYYY-MM-DD`（必须）、`--until YYYY-MM-DD`（必须）、`--username <github-username>`（可选，默认 `gh api user`）
- [x] 2.2 实现 PR 查询：created in period + merged in period + currently open by user
- [x] 2.3 实现 Issue 查询：created in period
- [x] 2.4 实现 JSON 输出：period + prs 数组 + issues 数组 + totals (prs_merged, prs_open, issues_opened, issues_closed)
- [x] 2.5 处理边界情况：gh 未认证时报错退出、无活动时输出空数组
- [x] 2.6 终端验证：运行 daily 和 weekly 范围，确认 JSON 输出正确

**Gate**: github.sh 输出符合 design D8 定义的 JSON 结构

## Phase 3: SKILL.md + 模板更新 ✅

- [x] 3.1 更新 SKILL.md Step 2：stats.sh + github.sh 并行执行，替代内联 gh api 命令
- [x] 3.2 更新 SKILL.md Step 2c：补充云效 MCP 查询细节（list_change_requests + search_workitems 的具体参数）
- [x] 3.3 重写 `references/template.md`：叙事 + 表格混合格式，主题分组规则，MR 按主题合并行规则，Bug 逐条列规则
- [x] 3.4 自审：对照 specs/worklog/spec.md 检查所有 requirement 覆盖

**Gate**: SKILL.md + template.md 反映新的数据流和模板规范

## Phase 4: diary-assistant 重构 ✅

- [x] 4.1 修改 `skills/diary-assistant/SKILL.md`：Work Log 步骤改为调用 worklog skill（daily 模式），移除内联数据获取逻辑
- [x] 4.2 删除 `skills/diary-assistant/references/worklog-automation.md`
- [x] 4.3 修改 `skills/diary-assistant/references/user-config.md`：移除 worklog_sources、yunxiao_org_id、github_user 配置项，保留日记路径和关联 skill 配置
- [x] 4.4 更新 `repos/skill/README.md`：新增 worklog 到 Workflow 技能列表，更新依赖架构图（diary-assistant → worklog）

**Gate**: diary-assistant 的 worklog 步骤正确引用 worklog skill，无残留的旧逻辑

## Phase 5: Skill Review ✅

- [x] 5.1 结构校验：运行 `repos/skill/scripts/validate.sh` 确认 skill 格式合规
- [x] 5.2 内容质量：调用 `writing-skills` 进行深度审查
- [x] 5.3 兼容性审计：按 skill-reviewer checklist 逐项检查
- [x] 5.4 输出审查报告：按 Critical / High / Medium / Low 分级汇总

**Gate**: 审查报告已生成

## Phase 6: Issue Resolution ✅

- [x] 6.1 Critical: marketplace.json 注册 worklog 到 workflow-skills 组
- [x] 6.2 High: Step 2 并行模式添加 Agent fallback 注释
- [x] 6.3 High: stats.sh 无 Windows 替代 — 用户决定跳过（同 code-sync 决策）
- [x] 6.4 Medium/Low: 用户决定全部跳过（hardcoded 路径、description 可搜索性）

**Gate**: 所有 Critical/High 已解决或用户明确跳过

## Phase 7: Final Verification

- [x] 7.1 重跑 `repos/skill/scripts/validate.sh` 确认修复后 skill 格式仍然合规
- [ ] 7.2 新会话测试触发词隔离：说「工作回顾」确认触发 worklog 而非 diary-assistant
- [ ] 7.3 新会话测试 daily 模式：完整执行一次日回顾，确认输出包含概览 + 主题叙事 + 表格
- [ ] 7.4 新会话测试 weekly 模式：完整执行一次周回顾，确认输出包含统计分布 + 亮点
