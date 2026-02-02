# 技术设计：博客点赞功能

## 设计方法论

本功能实现遵循 **Vercel Design Guidelines** 和 **Rams 无障碍审查** 原则。

### 交互设计原则 (Vercel)

| 原则 | 要求 |
|------|------|
| 键盘可操作 | 点赞按钮支持 Tab 聚焦和 Enter/Space 触发 |
| 焦点可见 | 使用 `:focus-visible` 提供清晰的焦点指示器 |
| 触控区域 | 最小 44×44px，与现有分享按钮一致 |
| 即时反馈 | 点击后立即更新 UI，不等待 API 响应 |

### 视觉设计原则 (Vercel)

| 原则 | 要求 |
|------|------|
| 状态区分 | 未赞（空心）→ 已赞（实心红色），状态变化有过渡动画 |
| 风格统一 | 与 ShareSidebar 现有按钮使用相同的 padding、border-radius、hover 效果 |
| 明暗主题 | 爱心颜色在亮/暗主题下都清晰可见 |

### 无障碍检查清单 (Rams / WCAG 2.1)

**Critical (必须修复)**

| 检查项 | WCAG | 说明 |
|--------|------|------|
| 按钮标签 | 4.1.2 | 点赞按钮需要 `aria-label`（如 "点赞" 或 "取消点赞"） |
| 状态通知 | 4.1.3 | 点赞状态变化时使用 `aria-pressed` 或 `aria-live` 通知 |
| 语义化交互 | 2.1.1 | 使用 `<button>` 元素，而非 `<div onClick>` |

**Serious (应该修复)**

| 检查项 | WCAG | 说明 |
|--------|------|------|
| 焦点轮廓 | 2.4.7 | 移除 `outline` 时必须提供替代焦点样式 |
| 非色彩信息 | 1.4.1 | 不仅靠颜色区分状态，实心/空心图标也能区分 |
| 触控目标 | 2.5.5 | 按钮尺寸 ≥ 44×44px |
| 动画安全 | 2.3.3 | 点赞动画遵循 `prefers-reduced-motion` |

## Context

bokushi 博客需要一个轻量级的用户互动功能。当前已有 ShareSidebar 组件用于社交分享，但这些按钮容易被广告拦截器屏蔽。点赞功能作为补充，可以不受拦截器影响地运行。

**约束条件：**

- 博客是静态站点，部署在 Cloudflare Pages
- 已有 Astro hybrid 模式配置，支持 SSR API 端点
- 无用户登录系统，需要匿名点赞

## Goals / Non-Goals

**Goals:**

- 提供简单的点赞/取消点赞功能
- 显示文章的总点赞数
- 防止单用户恶意刷赞
- 与现有 ShareSidebar 风格统一

**Non-Goals:**

- 不实现用户账号系统
- 不实现评论功能（已有 Remark42）
- 不追踪用户行为数据

## Decisions

### 1. 存储方案：Cloudflare KV

**决定：** 使用 Cloudflare KV 存储点赞数据

**原因：**

- 博客已部署在 Cloudflare Pages，KV 是原生集成
- 读多写少的场景非常适合 KV
- 成本低，免费额度足够个人博客使用

**数据结构：**

```
Key: like:{slug}
Value: { "count": 42, "ips": ["hash1", "hash2", ...] }
```

### 2. 防刷策略：IP 哈希 + localStorage

**决定：** 双重验证机制

- 服务端：存储 IP 的 SHA-256 哈希，同一 IP 只能点赞一次
- 客户端：localStorage 记录已点赞的文章 slug，提供即时 UI 反馈

**原因：**

- IP 限制可防止恶意刷赞
- 哈希存储保护用户隐私
- localStorage 提供离线状态恢复，减少 API 请求

### 3. UI 设计：爱心图标 + 数字

**决定：**

- 图标：`ri:heart-line`（未赞）→ `ri:heart-fill`（已赞，红色）
- 显示：图标 + 数字（如 ♥ 42）
- 位置：ShareSidebar 复制链接按钮下方
- 交互：点击切换点赞状态，支持取消

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| IP 可被伪造或共享（NAT） | 可接受，个人博客不需要精确计数 |
| KV 最终一致性可能导致计数不准 | 可接受，几秒延迟对点赞场景无影响 |
| 清除 localStorage 后 UI 状态丢失 | API 返回当前 IP 是否已赞，可恢复状态 |

## API 设计

### GET /api/like

**请求：** `?slug=article-slug`

**响应：**

```json
{
  "count": 42,
  "liked": true
}
```

### POST /api/like

**请求：**

```json
{
  "slug": "article-slug",
  "action": "like" | "unlike"
}
```

**响应：**

```json
{
  "count": 43,
  "liked": true
}
```

## Open Questions

- 无
