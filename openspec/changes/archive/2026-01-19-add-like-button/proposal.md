# Change: 为博客文章添加点赞功能

## Why

社交分享按钮（Twitter/Telegram）经常被广告拦截器屏蔽，导致用户无法便捷地表达对内容的喜爱。点赞功能提供了一种不受广告拦截器影响的互动方式，同时也能让作者了解内容的受欢迎程度。

## What Changes

- 在 ShareSidebar 组件中添加爱心点赞按钮（位于复制链接按钮下方）
- 创建新的 API 端点 `/api/like` 用于存储和获取点赞数据
- 使用 Cloudflare KV 进行持久化存储，配合 IP 限制防止刷赞
- 爱心图标旁显示点赞数量，点击时提供视觉反馈

## Impact

- Affected specs: 新增 `blog-interactions` capability
- Affected code:
  - `repos/bokushi/src/pages/api/like.ts`（新增）
  - `repos/bokushi/src/components/ShareSidebar.astro`（修改）
  - `repos/bokushi/wrangler.toml`（KV 绑定配置）
