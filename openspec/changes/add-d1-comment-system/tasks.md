# Tasks: add-d1-comment-system

> **流程**: Phase 1 → 2 → 3 → 4 → 5 → 6，每个 Phase 有 Gate 条件。
> **交付策略**: 单 PR 交付（变更集中在 `repos/bokushi`）。

## Phase 1: D1 数据库与基础设施

- [x] 1.1 在 Cloudflare Dashboard 创建 D1 数据库 `bokushi-comments`
- [x] 1.2 在 `wrangler.toml` 中添加 D1 binding（`COMMENTS_DB`）
- [x] 1.3 创建 `migrations/0001_create_comments.sql`：comments 表 + 索引（参照 design 中的数据模型）
- [x] 1.4 运行 migration 创建表结构（通过 D1 Console 执行）
- [x] 1.5 在 Cloudflare Dashboard 注册 Turnstile site（site key: `0x4AAAAAACaqvcOA4H-DU2p6`），配置环境变量
- [x] 1.6 配置管理员 token 环境变量（`ADMIN_TOKEN`）— 已在 Pages secrets 中设置
- [x] 1.7 配置本地开发用 Turnstile 测试 key（site key: `1x00000000000000000000AA`，secret key: `1x0000000000000000000000000000000AA`），通过 `.dev.vars` 或环境变量区分

**Gate**: `wrangler d1 execute` 可查询 comments 表，Turnstile key 配置就绪

## Phase 2: 评论 API 端点

- [x] 2.1 创建 `src/pages/api/comments.ts`（`prerender = false`），实现 GET handler：按 slug 查询评论，组装树形结构返回（已删除且有回复的评论返回占位数据，无回复的已删除评论不返回）
- [x] 2.2 实现 POST handler：验证 Turnstile token（调用 siteverify API）、验证必填字段和长度限制（author ≤ 50, content ≤ 5000, website ≤ 200, email ≤ 200）、用 `crypto.randomUUID()` 生成 ID、写入 D1、返回新评论
- [x] 2.3 创建 `src/pages/api/comments/[id].ts`（`prerender = false`），实现 DELETE handler：验证 admin token、软删除（status → deleted）
- [x] 2.4 在 `src/pages/api/comments/[id].ts` 中实现 PATCH handler：验证 admin token、切换 hidden/visible 状态
- [x] 2.5 创建 `src/pages/api/comments/count.ts`，实现评论计数 API（支持单个和批量 slug 查询）
- [x] 2.6 提取共用工具函数（`hashIP`、`getClientIP`）到 `src/lib/utils.ts`，与 `like.ts` 共享
- [x] 2.7 实现 D1 不可用时的 mock 返回（GET 返回空列表，POST 返回模拟评论），与 `like.ts` 处理 KV 不可用的模式一致

**Gate**: 用 curl 测试所有 API 端点（GET/POST/DELETE/PATCH/count），本地 `pnpm dev` 运行正常

## Phase 3: 前端评论组件

- [x] 3.1 创建 `src/components/CommentSection.astro`，替换 `Remark42Comments.astro` 的位置和 props 接口（slug、data attributes）
- [x] 3.2 创建 `src/scripts/comments.ts`，实现 `initCommentSection()`：获取评论列表、渲染评论树（含已删除评论占位符逻辑）
- [x] 3.3 实现评论表单：昵称（必填，≤ 50）、邮箱（可选，≤ 200）、网站（可选，≤ 200）、内容（必填，≤ 5000）、Turnstile widget
- [x] 3.4 实现 `submitComment()`：收集表单数据 + Turnstile token，POST 到 API，成功后清空表单、即时插入新评论到列表、重置 Turnstile widget；失败时保留内容、显示错误提示
- [x] 3.5 实现回复功能：点击"回复"展开表单、回复回复时自动添加 `@昵称` 前缀、parent_id 归属顶层评论
- [x] 3.6 实现 Markdown 渲染：用 `markdown-it` 渲染评论内容（禁用 heading 规则），用 `sanitize-html` 过滤 XSS（allowedTags 排除 h1-h6）
- [x] 3.7 实现作者信息展示：有 website 时昵称为可点击链接（`target="_blank" rel="nofollow noopener"`），有 email 时显示 Gravatar 头像（MD5 哈希），无 email 时显示默认占位头像
- [x] 3.8 实现提交按钮 loading 状态：提交时禁用按钮、显示 loading 指示，防止重复提交

**Gate**: 本地 `pnpm dev` 可发表评论、查看评论列表、嵌套回复，Markdown 正确渲染，Gravatar 头像正确显示

## Phase 4: 主题与导航兼容

- [x] 4.1 实现暗色模式联动：复用 `theme.ts` 的 `onThemeChange`，评论区样式跟随切换
- [x] 4.2 实现 Astro view transition 支持：监听 `astro:after-swap` 事件，重新初始化评论区
- [x] 4.3 用 Tailwind CSS 编写评论区样式：评论卡片、头像、嵌套缩进、表单、按钮、loading 状态，明暗两套配色

**Gate**: 切换主题时样式即时更新，页面导航后评论区正确重新加载

## Phase 5: 布局集成与旧代码清理

- [x] 5.1 更新 `src/layouts/BlogPost.astro`：将 `Remark42Comments` 替换为 `CommentSection`
- [x] 5.2 更新 `src/layouts/Page.astro`：将 `Remark42Comments` 替换为 `CommentSection`，保留 `commentsEnabled` frontmatter 控制
- [x] 5.3 删除 `src/components/Remark42Comments.astro`
- [x] 5.4 删除 `src/scripts/remark42.ts`
- [x] 5.5 清理 `PUBLIC_REMARK_URL` 和 `PUBLIC_REMARK_SITE_ID` 环境变量引用
- [x] 5.6 更新 `README.md`：评论系统描述从 Remark42 改为 D1 自建

**Gate**: `pnpm build` 构建成功，无 remark42 相关引用残留

## Phase 6: 验证与部署

- [x] 6.1 本地完整测试：发表评论、嵌套回复（API curl 验证通过，tree 结构正确）
- [x] 6.2 验证 Turnstile 集成：本地使用测试 key，token 验证链路正常（managed mode 需线上验证）
- [x] 6.3 验证管理功能：DELETE 软删除（占位符保留回复）、PATCH 隐藏/显示（admin token 验证正确）
- [x] 6.4 验证评论计数 API：单个和批量查询均返回正确计数
- [x] 6.5 验证输入长度限制：author>50、content>5000 被正确拒绝
- [x] 6.6 `pnpm build && pnpm preview` 完整构建验证
- [x] 6.7 部署到 Cloudflare Pages（GitHub Actions #21911780991 成功，1m30s）
