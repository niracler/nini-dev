# Tasks: add-pinboard-management

> **流程**: Phase 1 → 2 → 3 → 4 → 5 (动态) → 6，每个 Phase 有 Gate 条件，通过后才进入下一阶段。
> **交付策略**: 单 PR 交付（skill 部分在 `repos/skill`，n8n 部分通过 API 更新）。

## Phase 1: Skill 基础结构 + Tag 规范

- [x] 1.1 创建 `repos/skill/skills/workflow/pinboard-manager/` 目录结构
- [x] 1.2 创建 `references/tag-convention.md`：基本规则（全英文小写、`_` 连接、单数优先）+ 主题 tag 列表 + 元 tag 列表 + 迁移映射表
- [x] 1.3 创建 `references/user-config.md`：Pinboard auth_token 配置说明、环境变量设置方式
- [x] 1.4 创建 `SKILL.md` 骨架：frontmatter（name, description, triggers）、Prerequisites（Pinboard auth_token）、两个模式入口（tag audit / dead link check）

**Gate**: 目录结构完整，tag-convention.md 包含完整的 tag 体系和迁移映射表 ✅

## Phase 2: SKILL.md 完整实现

- [x] 2.1 实现 Tag 审计模式流程：拉取全量 → 按规范检查 → 分批展示（5-10 条/批）→ 确认后通过 `/posts/add` 覆盖
- [x] 2.2 实现死链检测模式流程：拉取全量 → `curl -I`（HEAD 请求，10 秒超时）→ HEAD 失败时 GET 重试 → 分批处理（10 条/批）→ 报告结果 → 用户决定删除或保留
- [x] 2.3 确保 `/posts/add` 调用时传入完整字段（description, extended, tags, shared, toread），避免数据丢失
- [x] 2.4 自审：对照 specs/pinboard-manager/spec.md 检查所有 requirement 和 scenario 覆盖

**Gate**: SKILL.md 覆盖所有 spec 中的 requirement 和 scenario ✅

## Phase 3: n8n Workflow 修改

- [x] 3.1 修改现有 Function1 节点：在 `shared === 'yes'` 过滤基础上增加 `toread !== 'yes'` 条件
- [x] 3.2 新增 HTTP Request 节点：调用 `/posts/all`（全量，用于内存中做 toread diff 和验证）
- [x] 3.3 新增 Code 节点（toread diff 逻辑）：对比 `staticData.toreadUrls`，在全量列表中验证消失的 URL（存在 + shared=yes + toread=no）
- [x] 3.4 新增 Telegram Read 节点（消息格式标注为 ✅ 已读）
- [x] 3.5 将 Interval 触发器同时连接到两个 HTTP Request 节点（并行分支）
- [x] 3.6 通过 n8n REST API 更新 workflow（PUT /api/v1/workflows/:id）

**Gate**: workflow 结构正确，8 节点，两个分支并行执行 ✅

## Phase 4: Skill Review

- [x] 4.1 结构校验：手动验证 SKILL.md frontmatter + 目录结构（validate.sh 有预存 bug，glob 层级不匹配）
- [x] 4.2 内容质量：code-reviewer 审查完成，6 个问题全部修复
- [x] 4.3 更新 `repos/skill/README.md`：新增 pinboard-manager 到 Workflow 技能列表 + 架构图
- [x] 4.4 注册到 `marketplace.json`：workflow-skills 组新增 pinboard-manager

**Gate**: 审查报告已生成，Critical/High 问题已解决或用户明确跳过

## Phase 5: Issue Resolution

- [x] 5.1 修复: `/posts/add` 示例硬编码 shared/toread → 改为 ORIGINAL 占位符
- [x] 5.2 修复: `posts/all` 5 分钟限流未记录 → 添加特殊限流说明
- [x] 5.3 修复: 死链检测不跟随重定向 → 添加 `-L --max-redirs 5`
- [x] 5.4 修复: `blog` tag 未定义但在迁移表中引用 → 改为 `writing`
- [x] 5.5 修复: user-config.md 缺少安全提示 → 添加 Security note

**Gate**: 所有 Critical/High 已解决 ✅

## Phase 6: Final Verification

- [ ] 6.1 重跑 `repos/skill/scripts/validate.sh` 确认修复后 skill 格式仍然合规
- [ ] 6.2 新会话测试 Tag 审计模式：触发 "pinboard 整理 tag"，确认能拉取 bookmark 并展示问题
- [ ] 6.3 新会话测试死链检测模式：触发 "pinboard 检查死链"，确认能检测链接状态
- [ ] 6.4 验证 n8n workflow：确认 `/posts/recent` 分支不推送 toread 文章，toread diff 分支能检测已读变化
