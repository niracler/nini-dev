# Change: 为评论系统添加 OAuth 登录

## Why

当前评论系统是完全匿名的——用户手填昵称和邮箱，没有真实身份。这导致无法实现用户自编辑/删除、回复通知、投票防刷、用户封禁等后续功能，因为系统不知道"谁是谁"。OAuth 登录是这些功能的基础设施，先把身份体系建起来，后续功能才能自然生长。

## What Changes

- 新增 GitHub OAuth 2.0 登录（首选 provider，技术博客读者覆盖率高）
- 新增 Telegram Login Widget 登录（复用现有 nyaruko-telegram-bot 的 bot token）
- 保留匿名评论能力，登录和匿名两种身份并存
- 新增用户体系：`users` 表 + `oauth_accounts` 表（支持同一用户关联多个 provider）
- 新增 session 管理：使用独立的 Cloudflare KV namespace (`SESSIONS`)
- 修改 `comments` 表：新增可空 `user_id` 字段关联登录用户
- 新增管理员身份识别：通过 `ADMIN_GITHUB_ID` 环境变量，GitHub 登录时自动判定 admin 角色
- 现有 `ADMIN_TOKEN` 机制在过渡期并存，后续退役
- 登录用户评论时自动填充头像和昵称，隐藏手填表单字段
- 支持已登录用户手动关联另一个 OAuth provider（账号合并）

## Capabilities

### New Capabilities

- `comment-auth`: 评论系统的用户认证与 session 管理——OAuth 登录（GitHub、Telegram）、session 生命周期、用户数据模型、账号关联/合并、管理员角色识别

### Modified Capabilities

- `blog-comments`: 评论发表流程需适配两种身份态（匿名 vs 登录用户），评论数据关联 user_id，管理员认证从 ADMIN_TOKEN 扩展为支持 session-based 角色检查

## Impact

- Affected repo: `repos/bokushi`
- New files:
  - `src/pages/api/auth/github.ts` — GitHub OAuth 入口
  - `src/pages/api/auth/github/callback.ts` — GitHub OAuth 回调
  - `src/pages/api/auth/telegram/callback.ts` — Telegram Login 验签
  - `src/pages/api/auth/me.ts` — 当前用户信息
  - `src/pages/api/auth/logout.ts` — 登出
  - `src/pages/api/auth/link/telegram.ts` — 关联 Telegram 账号
  - `migrations/0002_add_users.sql` — users + oauth_accounts 表
  - `migrations/0003_add_comment_user_id.sql` — comments 表加 user_id
- Modified files:
  - `src/scripts/comments.ts` — 登录 UI、表单切换逻辑
  - `src/components/CommentSection.astro` — 登录按钮区域
  - `src/pages/api/comments.ts` — POST 支持 user_id、GET 关联用户信息
  - `src/pages/api/comments/[id].ts` — 管理员认证扩展
  - `src/lib/utils.ts` — session 相关工具函数
  - `src/env.d.ts` — 新增环境变量类型
  - `wrangler.toml` — 新增 SESSIONS KV binding
- New dependencies: `arctic` (轻量 OAuth 库)
- Environment variables (new):
  - `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET` — GitHub OAuth App
  - `TELEGRAM_BOT_TOKEN` — 复用现有 bot token
  - `ADMIN_GITHUB_ID` — 管理员 GitHub 用户 ID
- Rollback plan: user_id 为可空字段，migration 向后兼容；删除 auth API 路由和 users 表即可回退到纯匿名模式
