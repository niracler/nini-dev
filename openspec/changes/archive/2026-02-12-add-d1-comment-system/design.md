## Context

博客评论系统原先使用 Remark42（Go 二进制 + BoltDB），部署在自建服务器上。服务器遭受攻击导致数据丢失，需要迁移到 Cloudflare serverless 架构。

博客现有基础设施：

- Astro `output: "static"` + 个别路由 `prerender = false` 的混合模式
- Cloudflare Pages 部署，已有 KV binding（点赞功能）
- `like.ts` 和 `mangas.ts` 提供了成熟的 API Route 模式
- `remark42.ts` 提供了暗色模式联动和 Astro view transition 处理的现有实现

约束：

- 不引入独立 Worker，所有逻辑内聚在 bokushi 项目
- 不依赖外部数据库服务，使用 Cloudflare D1
- v1 不实现登录系统，匿名评论为主

## Goals / Non-Goals

**Goals:**

- 提供与 Remark42 核心体验对齐的评论功能（嵌套回复、Markdown、暗色模式）
- 使用 Cloudflare D1 持久化，消除对独立服务器的依赖
- 复用现有 API Route 模式（`prerender = false` + `locals.runtime.env`）
- Turnstile 反垃圾保护
- 管理员可删除/隐藏评论

**Non-Goals:**

- v1 不实现 OAuth 社交登录
- v1 不实现图片上传
- v1 不实现邮件/Telegram 通知
- 不实现 Remark42 的数据导入（旧数据已丢失）
- 不做多站点支持（只服务 bokushi）

## Decisions

### 1. 存储：Cloudflare D1

**决定：** 使用 D1（SQLite）存储评论数据

**原因：**

- 评论是关系型数据（嵌套回复需要 parent_id），D1 比 KV 更适合
- 博客已有 D1 使用经验（漫画表情包库）
- D1 支持事务和复杂查询（按文章聚合计数、嵌套查询）
- 免费额度足够个人博客

**数据模型：**

```sql
CREATE TABLE comments (
  id         TEXT PRIMARY KEY,      -- crypto.randomUUID()
  slug       TEXT NOT NULL,         -- 文章标识（对应 Astro content slug）
  parent_id  TEXT,                  -- 嵌套回复（NULL = 顶层评论）
  author     TEXT NOT NULL,         -- 昵称
  email      TEXT,                  -- 可选，用于 Gravatar
  website    TEXT,                  -- 可选
  content    TEXT NOT NULL,         -- Markdown 原文
  ip_hash    TEXT,                  -- IP 的 SHA-256 哈希（复用 like.ts 的模式）
  status     TEXT DEFAULT 'visible', -- visible / hidden / deleted
  created_at TEXT NOT NULL,
  updated_at TEXT,
  FOREIGN KEY (parent_id) REFERENCES comments(id)
);

CREATE INDEX idx_comments_slug ON comments(slug, status, created_at);
CREATE INDEX idx_comments_parent ON comments(parent_id);
```

### 2. 嵌套策略：两层展示，扁平存储

**决定：** 数据库支持任意深度的 `parent_id` 引用，但前端展示限制为两层（评论 → 回复）

**原因：**

- Remark42 支持多层嵌套，但实际使用中深层嵌套很少
- 两层展示在移动端体验好，不会过度缩进
- 回复某条回复时，`parent_id` 指向顶层评论，内容中自动添加 `@昵称` 前缀
- 数据层面不做限制，未来改变展示策略时不需要迁移

```
评论 A                    ← parent_id = NULL
├── 回复 A-1              ← parent_id = A
├── 回复 A-2              ← parent_id = A
└── 回复 A-3 (@A-1)       ← parent_id = A, 内容含 @A-1 的作者名
```

### 3. 身份识别：匿名 + IP 哈希

**决定：** v1 采用纯匿名模式，通过 IP 哈希识别同一用户

**原因：**

- 最低门槛，与 Remark42 的匿名模式对齐
- IP 哈希复用 `like.ts` 已验证的 `hashIP()` 函数和 `getClientIP()` 函数
- IP 哈希用于：防刷检测、管理员屏蔽用户
- 不存储明文 IP，保护隐私

### 4. 反垃圾：Cloudflare Turnstile

**决定：** 使用 Cloudflare Turnstile 验证评论提交

**原因：**

- Cloudflare 自家产品，与 Pages 集成自然
- 免费，无请求限制
- 对用户无感知（invisible mode）或低干扰（managed mode）
- 替代 Remark42 内建的反垃圾机制

**流程：**

```
用户填写评论 → 前端获取 Turnstile token → POST /api/comments (含 token)
                                            → Worker 验证 token (siteverify API)
                                            → 验证通过 → 写入 D1
```

### 5. 管理员鉴权：Secret Token

**决定：** 管理操作（删除/隐藏评论）通过环境变量中的 secret token 鉴权

**原因：**

- 单人博客，不需要复杂的角色系统
- `wrangler.toml` 中配置 secret，API 请求头携带 `Authorization: Bearer <token>`
- 简单可靠，与现有项目复杂度匹配
- 未来可升级为 Cloudflare Access 或 OAuth

### 6. API 设计

**决定：** RESTful 端点，挂载在 `/api/comments`

| 方法 | 路径 | 功能 | 鉴权 |
|------|------|------|------|
| GET | `/api/comments?slug=xxx` | 获取文章评论列表（含嵌套） | 无 |
| GET | `/api/comments/count?slug=xxx` | 获取评论计数（支持批量 `slug=a&slug=b`） | 无 |
| POST | `/api/comments` | 发表评论 | Turnstile |
| DELETE | `/api/comments/[id]` | 删除评论（软删除） | Admin token |
| PATCH | `/api/comments/[id]` | 隐藏/显示评论 | Admin token |

**GET 响应结构（树形）：**

```json
{
  "comments": [
    {
      "id": "abc123",
      "author": "读者",
      "content": "好文章！",
      "created_at": "2026-02-05T10:00:00Z",
      "replies": [
        {
          "id": "def456",
          "author": "另一个读者",
          "content": "@读者 同意",
          "created_at": "2026-02-05T10:05:00Z",
          "replies": []
        }
      ]
    }
  ],
  "total": 2
}
```

### 7. API 文件路由

**决定：** RESTful 路由，按 Astro 文件路由拆分为三个文件

**原因：**

- Astro 文件路由中，`comments.ts` 只能响应 `/api/comments`，无法捕获 `/api/comments/[id]`
- DELETE/PATCH 需要路径参数 `[id]`，必须用动态路由文件

**文件映射：**

| 文件 | 路由 | 方法 |
|------|------|------|
| `src/pages/api/comments.ts` | `/api/comments` | GET（列表）、POST（发表） |
| `src/pages/api/comments/[id].ts` | `/api/comments/:id` | DELETE（删除）、PATCH（隐藏/显示） |
| `src/pages/api/comments/count.ts` | `/api/comments/count` | GET（计数） |

### 8. ID 生成：crypto.randomUUID()

**决定：** 使用 `crypto.randomUUID()` 生成评论 ID

**原因：**

- Cloudflare Workers 运行时原生支持，零依赖
- UUID v4 的碰撞概率对个人博客而言可忽略
- 无需引入 nanoid 等额外包

### 9. 输入长度限制

**决定：** API 层校验所有用户输入的长度

| 字段 | 最大长度 | 说明 |
|------|----------|------|
| `author` | 50 字符 | 昵称 |
| `content` | 5000 字符 | Markdown 原文 |
| `website` | 200 字符 | URL |
| `email` | 200 字符 | 邮箱地址 |

**原因：** 系统边界输入校验，防止恶意超长内容。前端同步做长度限制提示，后端为最终防线。

### 10. Markdown 渲染范围

**决定：** 不允许标题（h1-h6），允许内联格式和块级元素子集

**允许的语法：** 粗体、斜体、行内代码、代码块、链接、列表（有序/无序）、引用、分割线、图片（仅链接，不支持上传）

**禁止的语法：** 标题（h1-h6）、HTML 标签

**原因：** 评论区不应出现大标题，避免视觉干扰和页面结构混乱。通过 `markdown-it` 的 `disable` 选项禁用 heading 规则，`sanitize-html` 的 allowedTags 中排除 h1-h6。

### 11. 删除评论的展示策略

**决定：** 已删除的父评论显示占位符，子评论照常展示

**展示规则：**

```
评论 A [已删除]          ← 显示"该评论已删除"占位文本
├── 回复 A-1             ← 正常展示
└── 回复 A-2             ← 正常展示
```

**API 行为：**

- GET 查询时，status 为 `deleted` 的评论仍然返回，但 `content`、`author`、`email`、`website` 字段置空
- 前端根据 status 渲染占位符
- 如果一条已删除的评论没有子评论，则不返回（无需占位）

**原因：** 保留有价值的讨论线程，不因删除一条父评论而连带消灭子评论。

### 12. 本地开发策略

**决定：** D1 不可用时返回 mock 数据（同 `like.ts` 模式），Turnstile 使用测试 key

**D1 Mock：**

- 检测 `locals.runtime?.env?.COMMENTS_DB` 是否存在
- 不存在时 GET 返回空评论列表，POST 返回模拟的新评论对象
- 与 `like.ts` 处理 KV 不可用的模式一致

**Turnstile 测试：**

- 本地开发使用 Cloudflare 官方测试 key（always pass）
- Site key: `1x00000000000000000000AA`，Secret key: `1x0000000000000000000000000000000AA`
- 通过环境变量区分，无需代码分支

### 13. 作者信息展示

**决定：** 昵称为可点击链接（如有 website），显示 Gravatar 头像（如有 email）

**展示规则：**

- 有 website：昵称渲染为 `<a href="website" target="_blank" rel="nofollow noopener">昵称</a>`
- 无 website：昵称渲染为纯文本
- 有 email：通过 email 的 MD5 哈希获取 Gravatar 头像 `https://www.gravatar.com/avatar/{md5}?d=mp&s=48`
- 无 email：显示默认占位头像（Gravatar 的 `mp` mystery-person 默认头像）

### 14. 提交成功后的 UX

**决定：** 清空表单 + 新评论即时插入列表

**流程：**

1. 用户点击提交 → 按钮显示 loading 状态（禁用重复提交）
2. API 返回成功 → 清空表单所有字段
3. 新评论直接插入到评论列表对应位置（无需刷新页面）
4. Turnstile widget 重置，准备下次提交
5. API 返回错误 → 表单内容保留，显示错误提示

### 15. 前端架构：原生 JS 组件

**决定：** 用原生 JavaScript（TypeScript）编写前端，不引入框架

**原因：**

- 与 Remark42 集成的现有模式一致（`remark42.ts` 是纯 TS）
- 博客是 Astro 静态站，不需要 React/Vue 运行时
- Markdown 渲染用 `markdown-it`（项目已有依赖）
- 暗色模式联动复用现有 `theme.ts` 的 `onThemeChange` 机制

**组件结构：**

```
src/
├── components/
│   └── CommentSection.astro        -- 替换 Remark42Comments.astro
├── pages/api/
│   ├── comments.ts                 -- GET（列表）+ POST（发表）
│   └── comments/
│       ├── [id].ts                 -- DELETE（删除）+ PATCH（隐藏/显示）
│       └── count.ts                -- GET（评论计数）
├── lib/
│   └── utils.ts                    -- hashIP、getClientIP（与 like.ts 共享）
└── scripts/
    └── comments.ts                 -- 替换 remark42.ts
        ├── renderComments()        -- 渲染评论列表（树形）
        ├── renderForm()            -- 渲染评论表单
        ├── submitComment()         -- 提交评论（含 Turnstile）
        └── initCommentSection()    -- 初始化 + view transition 处理
```

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| D1 是 beta 产品，可能有稳定性风险 | D1 已 GA（2024 年 4 月），个人博客流量下风险极低 |
| 纯匿名导致垃圾评论 | Turnstile + IP 频率限制（同一 IP 每分钟最多 N 条） |
| Markdown 渲染可能有 XSS 风险 | 使用 `sanitize-html`（项目已有依赖）过滤渲染结果 |
| 前端纯 JS 开发复杂度 | v1 功能集有限，纯 JS 可控；若后续功能膨胀再考虑引入轻量框架 |
| IP 哈希无法识别 VPN/代理后的同一用户 | 可接受，个人博客不需要精确身份识别 |
| D1 免费额度（读 5M/天，写 100K/天） | 个人博客远低于此限制 |

## Migration Plan

1. 在 Cloudflare Dashboard 创建 D1 数据库，添加 binding 到 `wrangler.toml`
2. 运行 schema migration 创建 `comments` 表
3. 开发 API 端点和前端组件
4. 替换 `Remark42Comments.astro` → `CommentSection.astro`
5. 删除 `remark42.ts` 和相关环境变量
6. 部署并验证

**Rollback:** Remark42 组件代码保留在 git 历史中，回退只需还原组件引用。但 Remark42 服务器已不可用，回退意味着暂时没有评论功能。

## Open Questions

- ~~Turnstile 使用 invisible mode 还是 managed mode？~~ → **Managed mode**。大多数情况无感知，可疑时弹验证，适合公开评论区。
- ~~评论提交后是否需要 rate limiting？~~ → **v1 不做**，仅依赖 Turnstile。个人博客流量小，观察情况再加。
