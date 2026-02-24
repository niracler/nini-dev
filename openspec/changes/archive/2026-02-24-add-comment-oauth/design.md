## Context

博客评论系统 v1 已上线运行，基于 Cloudflare D1 + Pages Functions，采用纯匿名模式（手填昵称+可选邮箱）。管理员通过环境变量 `ADMIN_TOKEN` + Bearer 头鉴权，没有管理 UI。

现有基础设施：

- Astro `output: "static"` + `prerender = false` 的混合模式
- Cloudflare Pages 部署，已有 KV binding（LIKES）和 D1 binding（COMMENTS_DB）
- 前端为原生 TypeScript，无框架
- `comments` 表已有 `ip_hash` 字段用于匿名身份追踪

本次需要在现有系统上叠加 OAuth 登录层，同时保持匿名评论的能力。

## Goals / Non-Goals

**Goals:**

- GitHub OAuth 2.0 登录
- Telegram Login Widget 登录
- 匿名评论与登录评论并存
- 同一用户可关联多个 OAuth provider（账号合并）
- 管理员角色通过 GitHub ID 自动识别
- 登录用户评论时自动填充头像和昵称

**Non-Goals:**

- 不做 Google / Email 等其他 provider（后续按需添加）
- 不实现用户自编辑/删除评论（依赖 OAuth 但不在本次范围）
- 不实现投票、通知、封禁等功能（后续 change）
- 不做管理员 UI（本次只建身份基础设施）
- 不迁移现有匿名评论到用户账号

## Decisions

### 1. OAuth 库选择：GitHub 用 arctic，Telegram 手写

**决定：** GitHub OAuth 使用 [arctic](https://arcticjs.dev/) 库；Telegram Login Widget 手写验签

**原因：**

- arctic 轻量（只做 token 交换），运行时无关，原生支持 Cloudflare Workers
- arctic 支持 70+ provider 包括 GitHub，但不支持 Telegram（因为 Telegram Login 不是标准 OAuth 2.0）
- Telegram 验签逻辑简单：HMAC-SHA256(bot_token_hash, callback_data)，约 20 行代码
- 不使用 better-auth 等全家桶——项目不需要那么多功能，且 CF Workers 兼容性需额外验证

### 2. 数据模型：users + oauth_accounts 分表

**决定：** 新建 `users` 表和 `oauth_accounts` 表，`comments` 表新增可空 `user_id`

**原因：**

- 分表支持同一用户关联多个 provider（1:N 关系）
- `user_id` 为可空，向后兼容现有匿名评论
- 管理员角色存在 `users.role` 中，登录时根据 `ADMIN_GITHUB_ID` 环境变量自动设定

**Schema：**

```sql
-- Migration 0002: 用户体系
CREATE TABLE users (
  id         TEXT PRIMARY KEY,     -- crypto.randomUUID()
  name       TEXT NOT NULL,        -- 显示名（可改）
  avatar_url TEXT,                 -- 头像 URL
  role       TEXT DEFAULT 'user',  -- 'user' | 'admin'
  created_at TEXT NOT NULL,
  updated_at TEXT
);

CREATE TABLE oauth_accounts (
  provider      TEXT NOT NULL,       -- 'github' | 'telegram'
  provider_id   TEXT NOT NULL,       -- provider 侧的用户 ID
  user_id       TEXT NOT NULL,       -- → users.id
  provider_name TEXT,                -- provider 侧的用户名（快照）
  provider_avatar TEXT,              -- provider 侧的头像（快照）
  created_at    TEXT NOT NULL,
  PRIMARY KEY (provider, provider_id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_oauth_user ON oauth_accounts(user_id);

-- Migration 0003: comments 关联用户
ALTER TABLE comments ADD COLUMN user_id TEXT REFERENCES users(id);
CREATE INDEX idx_comments_user ON comments(user_id);
```

### 3. Session 管理：独立 KV namespace + HttpOnly Cookie

**决定：** 新建 `SESSIONS` KV namespace，session token 通过 HttpOnly Cookie 传递

**原因：**

- KV 天然支持 TTL（设 30 天过期），不需要自己做过期清理
- 独立 namespace 与 LIKES 职责分离，可以独立清空
- HttpOnly + Secure + SameSite=Lax 防止 XSS 和 CSRF
- 不用 JWT（stateless）——需要支持主动登出和 session 失效

**Session 结构（KV value）：**

```json
{
  "userId": "uuid",
  "createdAt": "2026-02-13T10:00:00Z"
}
```

**Cookie 配置：**

```
Set-Cookie: session=<token>; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=2592000
```

### 4. GitHub OAuth 流程

**决定：** 标准 OAuth 2.0 Authorization Code 流程

**流程：**

```
1. GET /api/auth/github
   → 生成 state（存入 KV，TTL 10 分钟）
   → 302 重定向到 github.com/login/oauth/authorize

2. GET /api/auth/github/callback?code=xxx&state=yyy
   → 验证 state（从 KV 取出并删除）
   → 用 code 换 access_token（arctic 处理）
   → 用 token 调 GitHub API 获取用户信息
   → 查 oauth_accounts(provider='github', provider_id=github_id)
     → 存在 → 更新 provider_name/avatar，获取 user_id
     → 不存在 → 创建 users 记录 + oauth_accounts 记录
   → 检查 github_id == ADMIN_GITHUB_ID → 设 role='admin'
   → 创建 session（KV），Set-Cookie
   → 302 重定向回原页面（通过 state 中的 redirect_url）
```

**State 存储：** 使用 SESSIONS KV（前缀 `oauth_state:`），TTL 10 分钟。State 中编码 redirect_url 以便回调后跳回原文章页。

**所需环境变量：** `GITHUB_CLIENT_ID`、`GITHUB_CLIENT_SECRET`

### 5. Telegram Login Widget 流程

**决定：** 前端嵌入 Telegram Login Widget，回调数据 POST 到后端验签

**流程：**

```
1. 前端：加载 Telegram Login Widget（<script data-telegram-login="bot_name">）
   → 用户点击授权
   → Widget 回调 JS 函数，携带签名数据：
     { id, first_name, last_name, username, photo_url, auth_date, hash }

2. POST /api/auth/telegram/callback (JSON body = widget 数据)
   → 验签：
     a. secret = SHA256(bot_token)
     b. data_check_string = 按字母排序拼接所有字段（不含 hash）
     c. 验证 HMAC-SHA256(secret, data_check_string) == hash
   → 验证 auth_date 不超过 5 分钟（防重放）
   → 查 oauth_accounts(provider='telegram', provider_id=telegram_id)
     → 存在 → 更新信息，获取 user_id
     → 不存在 → 创建 users + oauth_accounts
   → 创建 session，Set-Cookie
   → 返回 JSON { success: true, user: {...} }
```

**所需环境变量：** `TELEGRAM_BOT_TOKEN`（复用 nyaruko-telegram-bot 的 token）

### 6. 账号关联（合并）流程

**决定：** 已登录用户手动关联另一个 provider

**流程：**

```
已登录 GitHub 的用户想关联 Telegram：
1. 前端显示「关联 Telegram」按钮
2. 点击后弹出 Telegram Login Widget
3. Widget 回调数据 POST /api/auth/link/telegram
   → 验证当前 session（必须已登录）
   → Telegram 验签（同上）
   → 查 oauth_accounts(provider='telegram', provider_id=telegram_id)
     → 已存在且属于另一个 user → 返回错误（该 Telegram 已关联其他账号）
     → 已存在且属于当前 user → 返回成功（已关联）
     → 不存在 → 创建 oauth_accounts 记录，user_id = 当前用户
   → 返回 JSON { success: true }
```

反向（已登录 Telegram 关联 GitHub）同理，但需要 `/api/auth/link/github` 走 OAuth redirect 流程，稍复杂。v1 先只支持「GitHub 关联 Telegram」方向，因为 GitHub 是管理员身份来源，更常作为主账号。

### 7. 管理员识别

**决定：** 通过 `ADMIN_GITHUB_ID` 环境变量，GitHub 登录时自动判定

**规则：**

- GitHub 登录时，若 `github_user.id.toString() === env.ADMIN_GITHUB_ID`，则 `users.role = 'admin'`
- 每次 GitHub 登录都重新检查（支持动态更改环境变量）
- Telegram 登录不触发管理员判定（管理员身份只绑定 GitHub）

**过渡期：** 现有 `ADMIN_TOKEN` Bearer 鉴权继续生效。管理 API (`[id].ts`) 同时接受两种鉴权方式：

```
verifyAdmin(request, env):
  1. 检查 session cookie → 查 user → role === 'admin' → 通过
  2. 检查 Authorization: Bearer <ADMIN_TOKEN> → 通过
  3. 都没有 → 401
```

### 8. 评论发表流程适配

**决定：** POST `/api/comments` 同时支持匿名和登录两种模式

**匿名（现有行为不变）：**

```json
{ "slug": "...", "author": "昵称", "content": "..." }
```

→ `user_id = NULL`，author/email/website 从 body 取

**登录用户：**

```json
{ "slug": "...", "content": "..." }
```

→ 从 session cookie 获取 user_id
→ author/avatar 从 `users` 表取
→ body 中的 author/email/website 字段被忽略

**GET 响应扩展：**

```json
{
  "id": "...",
  "author": "Kyoko",
  "avatar_url": "https://avatars.githubusercontent.com/u/xxx",
  "user_id": "uuid-or-null",
  "is_admin": true,
  "content": "..."
}
```

### 9. 前端 UI 变化

**决定：** 评论区顶部新增登录/用户状态栏

**未登录状态：**

```
┌─────────────────────────────────────────┐
│  [GitHub 登录]  [Telegram 登录]          │
│  ─────────── 或匿名评论 ───────────      │
├─────────────────────────────────────────┤
│  昵称: [________]                        │
│  邮箱: [________] (可选)                 │
│  网站: [________] (可选)                 │
│  内容: [________________________]        │
│            [提交]                         │
└─────────────────────────────────────────┘
```

**已登录状态：**

```
┌─────────────────────────────────────────┐
│  [avatar] Kyoko · 登出 · 关联 Telegram   │
├─────────────────────────────────────────┤
│  内容: [________________________]        │
│            [提交]                         │
└─────────────────────────────────────────┘
```

登录后隐藏 author/email/website 字段，简化表单。

### 10. API 路由文件结构

**决定：** auth 路由独立于 comments 路由

```
src/pages/api/
├── auth/
│   ├── github.ts              -- GET: 重定向到 GitHub
│   ├── github/
│   │   └── callback.ts        -- GET: GitHub OAuth 回调
│   ├── telegram/
│   │   └── callback.ts        -- POST: Telegram 验签
│   ├── me.ts                  -- GET: 当前用户信息
│   ├── logout.ts              -- POST: 登出
│   └── link/
│       └── telegram.ts        -- POST: 关联 Telegram
├── comments.ts                -- (现有) GET + POST
└── comments/
    ├── [id].ts                -- (现有) DELETE + PATCH
    └── count.ts               -- (现有) GET
```

### 11. Session 工具函数

**决定：** 在 `src/lib/` 下新增 `auth.ts` 工具模块

**职责：**

- `createSession(kv, userId)` → 生成 token，写入 KV，返回 Set-Cookie 头
- `getSession(kv, request)` → 从 cookie 解析 token，查 KV，返回 session 数据或 null
- `destroySession(kv, request)` → 删除 KV 条目，返回清除 cookie 头
- `verifyTelegramAuth(botToken, data)` → HMAC-SHA256 验签
- `getSessionUser(db, kv, request)` → 组合：getSession → 查 users 表 → 返回用户对象

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| GitHub OAuth App 需要固定 callback URL，preview 部署无法测试 | 开发时用 `wrangler pages dev` 本地测试；GitHub 支持多个 callback URL |
| Telegram Login Widget 需要 HTTPS 域名 | 生产环境 OK；本地开发需要 Telegram test mode 或 mock |
| KV 最终一致性可能导致刚创建的 session 在极少数情况下读不到 | 个人博客流量下概率极低，可接受 |
| OAuth state 存 KV 可能被 replay | state 验证后立即删除 + TTL 10 分钟兜底 |
| 账号合并只支持「GitHub → 关联 Telegram」方向 | v1 够用，反向关联可后续添加 |
| 现有匿名评论无法关联到后来注册的用户 | 明确的 Non-Goal，不迁移 |

## Open Questions

- Telegram Login Widget 在本地开发环境（localhost）如何测试？可能需要 mock 或使用 Telegram 的 test bot token
- GitHub OAuth App 的 callback URL 是否需要同时配置 production 和 development 两个？还是用同一个 App 配多个 redirect URI？
