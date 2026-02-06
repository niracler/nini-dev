# Change: 用 D1 自建评论系统替换 Remark42

## Why

原有的 Remark42 评论系统部署在自建服务器上，服务器遭受攻击导致评论数据全部丢失。需要迁移到 Cloudflare 的 serverless 架构，消除对独立服务器的依赖，保障数据安全和服务稳定性。博客已在使用 Cloudflare Pages + KV + D1，自建评论系统可以完全内聚在现有架构中。

## What Changes

- **BREAKING**: 移除 Remark42 集成（`Remark42Comments.astro`、`remark42.ts`），替换为自建评论组件
- 新增 Cloudflare D1 数据库存储评论数据（嵌套评论、作者信息、状态管理）
- 新增 API 端点 `/api/comments`（CRUD + 评论计数），复用现有 `like.ts` 的 Pages Functions 模式
- 新增前端评论组件，对齐 Remark42 核心体验：嵌套回复、Markdown 渲染、暗色模式联动
- 使用 Cloudflare Turnstile 替代 Remark42 内建反垃圾机制

### 分阶段交付

| 阶段 | 范围 |
|------|------|
| v1 | 评论 CRUD、嵌套回复、Markdown、匿名评论（昵称+可选邮箱）、Turnstile 反垃圾、管理员删除、评论计数、暗色模式 |
| v2 | 投票/点赞、排序、用户编辑/删除自己的评论、置顶、Telegram 通知 |
| v3 | OAuth 登录、图片上传(R2)、邮件通知、RSS、JSON 导出/备份、博主认证标记 |

## Capabilities

### New Capabilities

- `blog-comments`: 博客文章评论系统——发表评论、嵌套回复、Markdown 渲染、反垃圾、管理功能

### Modified Capabilities

- `blog-interactions`: 评论计数将与现有的点赞功能并列展示，可能需要调整交互区域布局

## Impact

- Affected repo: `repos/bokushi`
- Affected code:
  - `src/components/Remark42Comments.astro` → 替换为新评论组件
  - `src/scripts/remark42.ts` → 删除，替换为新的评论前端逻辑
  - `src/layouts/BlogPost.astro` → 更新组件引用
  - `src/layouts/Page.astro` → 更新组件引用
  - `src/pages/api/comments.ts`（新增）
  - `wrangler.toml` → 新增 D1 binding
- Dependencies: 无新增外部依赖（markdown-it 已在项目中）
- Rollback plan: 保留 Remark42 组件代码在 git 历史中，如需回退切换组件引用即可
