# Tasks: add-comment-oauth

> **流程**: Phase 1 → 2 → 3 → 4 → 5 → 6，每个 Phase 有 Gate 条件。
> **交付策略**: 单 PR 交付（变更集中在 `repos/bokushi`）。

## 1. 基础设施与依赖

- [x] 1.1 安装 `arctic` 依赖（`pnpm add arctic`）
- [x] 1.2 在 Cloudflare Dashboard 创建 KV namespace `bokushi-sessions`，在 `wrangler.toml` 中添加 SESSIONS binding
- [ ] 1.3 在 GitHub 创建 OAuth App（Settings > Developer settings > OAuth Apps），获取 Client ID 和 Client Secret，callback URL 设为 `https://niracler.com/api/auth/github/callback` ⚠️ 需手动操作
- [ ] 1.4 配置 Cloudflare Pages 环境变量：`GITHUB_CLIENT_ID`、`GITHUB_CLIENT_SECRET`、`TELEGRAM_BOT_TOKEN`（复用 nyaruko bot token）、`ADMIN_GITHUB_ID` ⚠️ 需手动操作
- [ ] 1.5 配置本地开发 `.dev.vars`：添加上述环境变量（GitHub OAuth App 可配 localhost callback 用于本地测试） ⚠️ 需手动操作
- [x] 1.6 更新 `src/env.d.ts`：添加 `SESSIONS` KV、`GITHUB_CLIENT_ID`、`GITHUB_CLIENT_SECRET`、`TELEGRAM_BOT_TOKEN`、`ADMIN_GITHUB_ID` 类型声明

**Gate**: `wrangler pages dev` 启动正常，新环境变量可在 `locals.runtime.env` 中访问

## 2. 数据库 Migration

- [x] 2.1 创建 `migrations/0002_add_users.sql`：`users` 表（id, name, avatar_url, role, created_at, updated_at）+ `oauth_accounts` 表（provider, provider_id, user_id, provider_name, provider_avatar, created_at）+ 索引
- [x] 2.2 创建 `migrations/0003_add_comment_user_id.sql`：`ALTER TABLE comments ADD COLUMN user_id TEXT REFERENCES users(id)` + 索引
- [ ] 2.3 在本地 D1 和 Cloudflare Dashboard 执行 migration ⚠️ 需手动操作

**Gate**: `SELECT * FROM users` 和 `SELECT user_id FROM comments LIMIT 1` 可执行，表结构正确

## 3. Session 与 Auth 工具模块

- [x] 3.1 创建 `src/lib/auth.ts`：实现 `createSession(kv, userId)` — 生成 crypto.randomUUID() token，写入 KV（TTL 30 天），返回 Set-Cookie 头字符串
- [x] 3.2 实现 `getSession(kv, request)` — 从 Cookie 头解析 session token，查 KV，返回 session 数据或 null
- [x] 3.3 实现 `destroySession(kv, request)` — 删除 KV 条目，返回清除 cookie 的 Set-Cookie 头
- [x] 3.4 实现 `getSessionUser(db, kv, request)` — 组合 getSession + 查 users 表，返回完整用户对象或 null
- [x] 3.5 实现 `verifyTelegramAuth(botToken, data)` — HMAC-SHA256 验签 Telegram Login Widget 回调数据，验证 auth_date 不超过 5 分钟

**Gate**: 工具函数类型正确，`pnpm build` 无编译错误

## 4. Auth API 端点

- [x] 4.1 创建 `src/pages/api/auth/github.ts`（GET）：用 arctic 创建 GitHub OAuth client，生成 state（存入 KV，TTL 10 分钟，含 redirect_url），302 重定向到 GitHub 授权页
- [x] 4.2 创建 `src/pages/api/auth/github/callback.ts`（GET）：验证 state、用 arctic 换 access_token、调 GitHub API 获取用户信息、upsert users + oauth_accounts、检查 ADMIN_GITHUB_ID 设 role、创建 session、302 回原页面
- [x] 4.3 创建 `src/pages/api/auth/telegram/callback.ts`（POST）：调用 verifyTelegramAuth 验签、upsert users + oauth_accounts、创建 session、返回 JSON
- [x] 4.4 创建 `src/pages/api/auth/me.ts`（GET）：调用 getSessionUser，返回 `{ user }` 或 `{ user: null }`
- [x] 4.5 创建 `src/pages/api/auth/logout.ts`（POST）：调用 destroySession，返回成功
- [x] 4.6 创建 `src/pages/api/auth/link/telegram.ts`（POST）：验证当前 session、验签 Telegram 数据、检查 provider_id 冲突（409）、创建 oauth_accounts 记录关联当前 user_id

**Gate**: 用 curl 测试 GitHub 登录全流程（redirect → callback → me → logout），Telegram 用 mock 数据测试验签逻辑

## 5. 现有 API 适配

- [x] 5.1 修改 `src/pages/api/comments.ts` POST handler：检测 session cookie，有则从 users 表获取 author/avatar 并设 user_id，无则保持现有匿名逻辑
- [x] 5.2 修改 `src/pages/api/comments.ts` GET handler：查询时 JOIN users 表，返回中增加 `avatar_url`、`user_id`、`is_admin` 字段
- [x] 5.3 修改 `src/pages/api/comments/[id].ts` `verifyAdmin`：同时支持 session-based（role='admin'）和 Bearer token 两种鉴权方式

**Gate**: 匿名发表评论行为不变，登录用户评论携带 user_id 和头像，管理 API 两种鉴权均通过

## 6. 前端 UI

- [x] 6.1 修改 `src/components/CommentSection.astro`：添加登录状态栏区域的 HTML 结构
- [x] 6.2 修改 `src/scripts/comments.ts`：页面加载时调用 `/api/auth/me` 获取登录状态
- [x] 6.3 实现未登录状态 UI：显示「GitHub 登录」和「Telegram 登录」按钮，点击 GitHub 按钮跳转 `/api/auth/github?redirect=当前URL`
- [x] 6.4 实现 Telegram Login Widget 集成：动态加载 `<script data-telegram-login="..." data-onauth="...">` 脚本，回调函数 POST 数据到 `/api/auth/telegram/callback`
- [x] 6.5 实现已登录状态 UI：显示头像、昵称、「登出」按钮，未关联的 provider 显示「关联」按钮
- [x] 6.6 实现表单切换逻辑：登录用户隐藏 author/email/website 字段，只显示内容输入框；匿名用户保持现有完整表单
- [x] 6.7 实现登出逻辑：POST `/api/auth/logout`，成功后刷新评论区状态
- [x] 6.8 实现账号关联：点击「关联 Telegram」弹出 widget，回调 POST `/api/auth/link/telegram`，成功后更新 UI
- [x] 6.9 修改评论渲染：登录用户的评论显示 OAuth 头像（avatar_url），管理员评论显示标识，匿名评论保持 Gravatar 逻辑
- [x] 6.10 确保 Astro view transition 兼容：`astro:after-swap` 时重新初始化登录状态和 Telegram widget

**Gate**: 本地 `pnpm dev` 可完成 GitHub 登录 → 发表评论 → 登出全流程，匿名评论不受影响，暗色模式和 view transition 正常

## 7. 验证与部署

- [ ] 7.1 本地完整测试：GitHub 登录 → 发评论 → 回复 → 登出 → 匿名发评论，验证两种身份态
- [ ] 7.2 验证 Telegram 登录流程（需要 HTTPS 环境，可用 `wrangler pages dev` 或部署后测试）
- [ ] 7.3 验证账号关联：GitHub 登录后关联 Telegram，再用 Telegram 登录验证同一用户
- [ ] 7.4 验证管理员功能：session-based 删除/隐藏、Bearer token 删除/隐藏均正常
- [ ] 7.5 验证 GET 响应：登录用户评论含 avatar_url/user_id/is_admin，匿名评论 user_id 为 null
- [ ] 7.6 验证安全性：Cookie HttpOnly/Secure/SameSite、OAuth state 防 CSRF、Telegram auth_date 防重放
- [ ] 7.7 `pnpm build && pnpm preview` 完整构建验证
- [ ] 7.8 部署到 Cloudflare Pages，线上验证全流程
