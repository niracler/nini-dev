# Change: Bokushi 博客功能增强

## Why

博客已完成基础功能（文章、标签、RSS、评论、动态页），进入「添砖加瓦」阶段。当前存在以下可提升空间：

1. **内容发现困难** — 没有搜索功能，读者只能通过标签或滚动浏览
2. **传播能力弱** — 没有分享按钮，读者分享文章需要手动复制链接
3. **独立博客孤岛** — 没有接入 IndieWeb，无法与其他独立博客互动
4. **相关内容推荐缺失** — 读者看完一篇文章后没有引导，容易流失

## What Changes

### Phase 1: 全文搜索

- 基于 [Pagefind](https://pagefind.app/) 实现零服务端全文搜索
- 搜索 UI 整合到导航栏或独立搜索页

### Phase 2: 文章分享按钮

- 在文章内容页左侧 sidebar 添加分享按钮
- 支持 Twitter、Telegram、复制链接

### Phase 3: IndieWeb / Webmentions

- 接入 [Webmention](https://indieweb.org/Webmention) 协议
- 展示来自其他网站的互动（点赞、转发、评论）
- 可选：接入 [Bridgy](https://brid.gy/) 从 Twitter/Mastodon 拉取互动

### Phase 4: AI 相关文章推荐

- 使用向量数据库存储文章 embedding
- 在文章末尾展示语义相关的文章推荐
- 可选：build 时生成，运行时查询

## 设计方法论

前端实现遵循 **Vercel Design Guidelines** + **Rams 无障碍审查**：

- 交互：键盘可操作、`:focus-visible` 焦点、触控区域 ≥44px
- 视觉：层次阴影、同心圆角、明暗主题一致
- 无障碍：WCAG 2.1 AA 级别，每个组件完成后运行 `/rams` 审查

详见 [design.md](./design.md) 中的完整检查清单。

## Impact

- Affected specs: 新增 4 个 capability（blog-search, blog-social-sharing, blog-indieweb, blog-recommendations）
- Affected code: `repos/bokushi/`
- 每个 Phase 独立分支、独立 PR、独立上线

## 分期策略

| Phase | 功能 | 复杂度 | 依赖 |
|-------|------|--------|------|
| 1 | 全文搜索 | 低 | 无 |
| 2 | 分享按钮 | 低 | 无 |
| 3 | IndieWeb | 中 | 无 |
| 4 | AI 推荐 | 高 | 无 |

各 Phase 完全独立，可并行开发或按顺序推进。
