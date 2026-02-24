# comment-auth Specification

## Purpose

评论系统的用户认证与 session 管理。支持 GitHub OAuth 2.0 和 Telegram Login Widget 两种登录方式，提供 session 生命周期管理、用户数据模型、账号关联/合并、以及基于 GitHub ID 的管理员角色识别。

## ADDED Requirements

### Requirement: GitHub OAuth 登录

用户 SHALL 能够通过 GitHub 账号登录评论系统，系统使用 OAuth 2.0 Authorization Code 流程完成认证。

#### Scenario: 成功登录（新用户）

- **WHEN** 用户点击「GitHub 登录」按钮
- **THEN** 浏览器重定向到 GitHub 授权页面
- **AND** 用户在 GitHub 授权后，浏览器重定向回原文章页面
- **AND** 系统创建 users 记录和 oauth_accounts 记录
- **AND** 系统设置 HttpOnly session cookie
- **AND** 评论区显示用户的 GitHub 头像和用户名

#### Scenario: 成功登录（已有用户）

- **WHEN** 已注册用户通过 GitHub 登录
- **THEN** 系统更新 oauth_accounts 中的 provider_name 和 provider_avatar
- **AND** 系统创建新 session
- **AND** 用户回到原文章页面，显示登录状态

#### Scenario: OAuth state 验证失败

- **WHEN** GitHub 回调中的 state 参数与 KV 中存储的值不匹配
- **THEN** 系统返回 400 错误
- **AND** 不创建 session

#### Scenario: OAuth state 过期

- **WHEN** 用户在发起授权请求 10 分钟后才完成回调
- **THEN** KV 中的 state 已被 TTL 自动清除
- **AND** 系统返回 400 错误，提示用户重新登录

#### Scenario: GitHub API 获取用户信息失败

- **WHEN** 用 authorization code 换取 token 或获取用户信息失败
- **THEN** 系统返回 500 错误
- **AND** 不创建 session，重定向回原页面并显示错误提示

### Requirement: Telegram Login Widget 登录

用户 SHALL 能够通过 Telegram 账号登录评论系统，系统使用 Telegram Login Widget 协议完成认证。

#### Scenario: 成功登录（新用户）

- **WHEN** 用户在 Telegram Login Widget 中授权
- **THEN** 前端将 widget 回调数据 POST 到后端
- **AND** 后端使用 HMAC-SHA256 验签通过
- **AND** 系统创建 users 记录和 oauth_accounts 记录
- **AND** 系统设置 HttpOnly session cookie
- **AND** 评论区显示用户的 Telegram 头像和用户名

#### Scenario: 成功登录（已有用户）

- **WHEN** 已注册用户通过 Telegram 登录
- **THEN** 系统更新 oauth_accounts 中的 provider_name 和 provider_avatar
- **AND** 系统创建新 session

#### Scenario: 验签失败

- **WHEN** Telegram 回调数据的 hash 与服务端计算的 HMAC-SHA256 不匹配
- **THEN** 系统返回 401 错误
- **AND** 不创建 session

#### Scenario: auth_date 过期

- **WHEN** Telegram 回调数据中的 auth_date 距当前时间超过 5 分钟
- **THEN** 系统返回 401 错误（防重放攻击）
- **AND** 不创建 session

### Requirement: Session 管理

系统 SHALL 使用 Cloudflare KV 存储 session，通过 HttpOnly Cookie 传递 session token。

#### Scenario: Session 创建

- **WHEN** 用户成功完成 OAuth 登录
- **THEN** 系统生成随机 session token
- **AND** 将 session 数据写入 SESSIONS KV（TTL 30 天）
- **AND** 设置 Cookie：`session=<token>; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=2592000`

#### Scenario: Session 读取

- **WHEN** 请求携带有效的 session cookie
- **THEN** 系统从 SESSIONS KV 读取 session 数据
- **AND** 返回关联的用户信息

#### Scenario: Session 过期

- **WHEN** session 超过 30 天 TTL
- **THEN** KV 自动删除该条目
- **AND** 下次请求时 session 验证失败，用户需重新登录

#### Scenario: 主动登出

- **WHEN** 用户点击「登出」按钮
- **THEN** 前端 POST `/api/auth/logout`
- **AND** 系统删除 KV 中的 session 条目
- **AND** 系统清除 session cookie（Max-Age=0）
- **AND** 评论区恢复为未登录状态

### Requirement: 查询当前用户

系统 SHALL 提供 API 查询当前登录用户的信息。

#### Scenario: 已登录用户

- **WHEN** 前端请求 GET `/api/auth/me` 且 session 有效
- **THEN** 返回用户信息：`{ user: { id, name, avatar_url, role } }`

#### Scenario: 未登录用户

- **WHEN** 前端请求 GET `/api/auth/me` 且无有效 session
- **THEN** 返回 `{ user: null }`
- **AND** HTTP 状态码为 200（不是 401）

### Requirement: 账号关联

已登录用户 SHALL 能够将另一个 OAuth provider 关联到当前账号，实现多 provider 登录同一用户。

#### Scenario: 成功关联 Telegram（从 GitHub 主账号）

- **WHEN** 已通过 GitHub 登录的用户点击「关联 Telegram」按钮
- **AND** 在 Telegram Login Widget 中完成授权
- **THEN** 系统验签通过后，将 Telegram oauth_account 记录关联到当前 user_id
- **AND** 之后用户可以通过 GitHub 或 Telegram 任一方式登录同一账号

#### Scenario: Telegram 已被其他用户关联

- **WHEN** 用户尝试关联的 Telegram 账号已经关联了另一个用户
- **THEN** 系统返回 409 Conflict 错误
- **AND** 提示该 Telegram 账号已被使用

#### Scenario: 重复关联

- **WHEN** 用户尝试关联一个已经属于自己的 Telegram 账号
- **THEN** 系统返回成功（幂等操作）

#### Scenario: 未登录时尝试关联

- **WHEN** 未登录用户请求 POST `/api/auth/link/telegram`
- **THEN** 系统返回 401 错误

### Requirement: 管理员角色识别

系统 SHALL 在 GitHub 登录时根据 `ADMIN_GITHUB_ID` 环境变量自动识别管理员。

#### Scenario: 管理员登录

- **WHEN** GitHub 用户的 ID 等于 `ADMIN_GITHUB_ID` 环境变量的值
- **THEN** 系统将该用户的 role 设为 `admin`

#### Scenario: 非管理员登录

- **WHEN** GitHub 用户的 ID 不等于 `ADMIN_GITHUB_ID`
- **THEN** 系统将该用户的 role 保持为 `user`

#### Scenario: 管理员角色动态更新

- **WHEN** 管理员每次通过 GitHub 登录
- **THEN** 系统重新检查 `ADMIN_GITHUB_ID` 以反映环境变量的更改

#### Scenario: Telegram 登录不触发管理员判定

- **WHEN** 用户通过 Telegram 登录
- **THEN** 不检查管理员条件，保持用户现有 role 不变
