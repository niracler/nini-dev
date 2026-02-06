# Tasks: add-d1-comment-system

> **流程**: Phase 1 → 2 → 3 → 4 → 5 → 6，每个 Phase 有 Gate 条件。
> **交付策略**: 单 PR 交付（变更集中在 `repos/bokushi`）。

## Phase 1: D1 数据库与基础设施

- [ ] 1.1 在 Cloudflare Dashboard 创建 D1 数据库 `bokushi-comments`
- [ ] 1.2 在 `wrangler.toml` 中添加 D1 binding（`COMMENTS_DB`）
- [ ] 1.3 创建 `migrations/0001_create_comments.sql`：comments 表 + 索引（参照 design 中的数据模型）
- [ ] 1.4 运行 migration 创建表结构（`wrangler d1 migrations apply`）
- [ ] 1.5 在 Cloudflare Dashboard 注册 Turnstile site，获取 site key 和 secret key，配置为环境变量（`PUBLIC_TURNSTILE_SITE_KEY`、`TURNSTILE_SECRET_KEY`）
- [ ] 1.6 配置管理员 token 环境变量（`ADMIN_TOKEN`）

**Gate**: `wrangler d1 execute` 可查询 comments 表，Turnstile key 配置就绪

## Phase 2: 评论 API 端点

- [ ] 2.1 创建 `src/pages/api/comments.ts`（`prerender = false`），实现 GET handler：按 slug 查询评论，组装树形结构返回
- [ ] 2.2 实现 POST handler：验证 Turnstile token（调用 siteverify API）、验证必填字段、写入 D1、返回新评论
- [ ] 2.3 实现 DELETE handler：验证 admin token、软删除（status → deleted）
- [ ] 2.4 实现 PATCH handler：验证 admin token、切换 hidden/visible 状态
- [ ] 2.5 创建 `src/pages/api/comments/count.ts`，实现评论计数 API（支持单个和批量 slug 查询）
- [ ] 2.6 提取共用工具函数（`hashIP`、`getClientIP`）到 `src/lib/utils.ts`，与 `like.ts` 共享

**Gate**: 用 curl 测试所有 API 端点（GET/POST/DELETE/PATCH/count），本地 `pnpm dev` 运行正常

## Phase 3: 前端评论组件

- [ ] 3.1 创建 `src/components/CommentSection.astro`，替换 `Remark42Comments.astro` 的位置和 props 接口（slug、data attributes）
- [ ] 3.2 创建 `src/scripts/comments.ts`，实现 `initCommentSection()`：获取评论列表、渲染评论树
- [ ] 3.3 实现评论表单：昵称（必填）、邮箱（可选）、网站（可选）、内容（必填）、Turnstile widget
- [ ] 3.4 实现 `submitComment()`：收集表单数据 + Turnstile token，POST 到 API，成功后刷新评论列表
- [ ] 3.5 实现回复功能：点击"回复"展开表单、回复回复时自动添加 `@昵称` 前缀、parent_id 归属顶层评论
- [ ] 3.6 实现 Markdown 渲染：用 `markdown-it` 渲染评论内容，用 `sanitize-html` 过滤 XSS

**Gate**: 本地 `pnpm dev` 可发表评论、查看评论列表、嵌套回复，Markdown 正确渲染

## Phase 4: 主题与导航兼容

- [ ] 4.1 实现暗色模式联动：复用 `theme.ts` 的 `onThemeChange`，评论区样式跟随切换
- [ ] 4.2 实现 Astro view transition 支持：监听 `astro:after-swap` 事件，重新初始化评论区
- [ ] 4.3 用 Tailwind CSS 编写评论区样式：评论卡片、嵌套缩进、表单、按钮，明暗两套配色

**Gate**: 切换主题时样式即时更新，页面导航后评论区正确重新加载

## Phase 5: 布局集成与旧代码清理

- [ ] 5.1 更新 `src/layouts/BlogPost.astro`：将 `Remark42Comments` 替换为 `CommentSection`
- [ ] 5.2 更新 `src/layouts/Page.astro`：将 `Remark42Comments` 替换为 `CommentSection`，保留 `commentsEnabled` frontmatter 控制
- [ ] 5.3 删除 `src/components/Remark42Comments.astro`
- [ ] 5.4 删除 `src/scripts/remark42.ts`
- [ ] 5.5 清理 `PUBLIC_REMARK_URL` 和 `PUBLIC_REMARK_SITE_ID` 环境变量引用
- [ ] 5.6 更新 `README.md`：评论系统描述从 Remark42 改为 D1 自建

**Gate**: `pnpm build` 构建成功，无 remark42 相关引用残留

## Phase 6: 验证与部署

- [ ] 6.1 本地完整测试：发表评论、嵌套回复、Markdown 渲染、暗色模式切换、view transition 导航
- [ ] 6.2 验证 Turnstile 集成：确认 managed mode 正常工作
- [ ] 6.3 验证管理功能：用 admin token 测试删除和隐藏评论
- [ ] 6.4 验证评论计数 API：单个和批量查询
- [ ] 6.5 `pnpm build && pnpm preview` 完整构建验证
- [ ] 6.6 部署到 Cloudflare Pages，线上验证评论功能
