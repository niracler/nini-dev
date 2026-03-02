## Context

bokushi 博客目前是纯中文站点，51 篇文章（blog 21 + til 17 + monthly 13），所有内容统一放在 `src/content/blog/`、`src/content/til/`、`src/content/monthly/` 下。HTML `lang` 属性硬编码为 `zh-CN`，无任何 i18n 基础设施。

现有基础设施：

- Astro 5.16.9，已内置 i18n 路由支持（`astro.config.mjs` 的 `i18n` 配置项）
- 内容集合使用 `defineCollection` + glob loader
- 动态路由 `src/pages/[...slug].astro` 聚合所有集合的文章
- 静态输出 + Cloudflare Pages 部署
- Pagefind 全文搜索、RSS feed、sitemap 已配置

约束：

- 现有 URL 结构不能变（`/elegant` 等路径保持不变）
- 中文是默认语言，英文是逐步添加的翻译语言
- 不是所有文章都有英文版，语言切换只在有翻译时出现
- monthly 和 til 暂不翻译，优先 blog 集合

## Goals / Non-Goals

**Goals:**

- 启用 Astro 原生 i18n 路由，中文无前缀、英文 `/en/` 前缀
- 内容目录重构为 `zh/`、`en/` 子目录
- 语言切换组件（仅有翻译时显示）
- AI 辅助翻译工作流（脚本或 Claude Code skill）
- 动态 `<html lang>` 属性
- hreflang 元标签支持 SEO

**Non-Goals:**

- v1 不翻译 til 和 monthly 集合
- ~~不做 UI 文案国际化~~ → 已在 v1 实现（`src/i18n/ui.ts` 包含导航、搜索、主题切换、页脚等完整翻译）
- 不做自动翻译同步（源文件更新后自动触发重翻）
- 不做多语言搜索（Pagefind 暂不按语言分索引）
- 不支持英文以外的其他语言

## Decisions

### 1. i18n 路由策略：Astro 原生 i18n + 默认语言无前缀

**决定：** 使用 Astro 内置 `i18n` 配置，`defaultLocale: "zh"`，`routing: { prefixDefaultLocale: false }`

**原因：**

- 中文文章保持 `/elegant`，英文文章为 `/en/elegant`
- 现有 URL 零影响，无需 301 重定向
- Astro 原生支持 locale 检测、`getRelativeLocaleUrl()` 等工具函数

**配置：**

```js
// astro.config.mjs
i18n: {
  defaultLocale: "zh",
  locales: ["zh", "en"],
  routing: {
    prefixDefaultLocale: false,
  },
}
```

### 2. 内容目录结构：子目录方案

**决定：** 在每个集合下建 `zh/`、`en/` 子目录

**方案对比：**

| 方案 | 优点 | 缺点 |
|------|------|------|
| A. 子目录 `blog/zh/`、`blog/en/` | 清晰分离，Astro i18n 天然支持 | 需要迁移现有文件 |
| B. 后缀 `elegant.en.md` | 文件放一起方便对照 | 路由需要自定义解析，Astro 不原生支持 |
| C. frontmatter `lang` 字段 | 灵活 | 路由逻辑复杂，无法利用 Astro i18n |

选择 **方案 A**，原因：与 Astro i18n 路由最自然匹配，长期维护清晰。

**迁移后结构：**

```
src/content/
├── blog/
│   ├── zh/
│   │   ├── elegant.md
│   │   ├── about.mdx
│   │   └── ...（现有 21 篇文章移入）
│   └── en/
│       ├── elegant.md      ← 翻译版
│       └── about.mdx
├── til/                    ← v1 不动
│   ├── ...
└── monthly/                ← v1 不动
    ├── ...
```

### 3. Slug 与路由映射

**决定：** slug 中去掉 `zh/` 前缀，保持与现有 URL 一致

**原因：**

- glob loader 会把 `zh/elegant.md` 的 slug 解析为 `zh/elegant`
- 需要在 `content.config.ts` 或路由层剥离 locale 前缀
- 中文 `/elegant`、英文 `/en/elegant` 共享同一个 base slug `elegant`

**实现方式：** 在 `getStaticPaths()` 中处理 slug 映射：

```
文件 blog/zh/elegant.md → slug: "elegant" → URL: /elegant
文件 blog/en/elegant.md → slug: "elegant" → URL: /en/elegant
```

### 4. 翻译对应关系：基于 slug 匹配

**决定：** 同 base slug 的中英文文件自动视为对应翻译

**原因：**

- 不需要在 frontmatter 中手动维护 `translations` 映射
- `blog/zh/elegant.md` 和 `blog/en/elegant.md` 自动配对
- 语言切换组件只需检查对应语言目录下是否存在同名文件

**替代方案：** frontmatter 中加 `translationOf: elegant`。更灵活但增加维护负担，slug 匹配对当前需求够用。

### 5. 语言切换组件：条件渲染

**决定：** 在 `BlogPost.astro` 布局中添加语言切换，仅当对应翻译存在时显示

**位置：** 文章标题下方，紧凑的 inline 链接样式

```
优雅的哲学
🌐 Read in English


正文...
```

### 6. AI 翻译工作流：CLI 脚本

**决定：** 创建 `scripts/translate.ts` 脚本，调用 Claude API 翻译

**流程：**

```
pnpm translate <slug>
  → 读取 src/content/blog/zh/<slug>.md
  → 提取 frontmatter + body
  → 调用 Claude API 翻译（保留 frontmatter 结构，翻译 title/description/body）
  → 写入 src/content/blog/en/<slug>.md
  → 输出 diff 供人工审校
```

**替代方案：** Claude Code skill。但脚本更通用，不依赖 Claude Code 环境，也可在 CI 中使用。v2 可以考虑做成 skill 以获得更好的交互体验。

### 7. SEO：hreflang 标签

**决定：** 在 `BaseHead.astro` 中动态生成 hreflang `<link>` 标签

```html
<!-- 中文页 /elegant -->
<link rel="alternate" hreflang="zh" href="https://niracler.com/elegant" />
<link rel="alternate" hreflang="en" href="https://niracler.com/en/elegant" />
<link rel="alternate" hreflang="x-default" href="https://niracler.com/elegant" />

<!-- 英文页 /en/elegant -->
（同上，双向声明）
```

仅在有翻译对时输出，避免孤立的 hreflang 声明。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 内容目录迁移可能破坏现有 slug | 迁移后运行 `pnpm build` 验证所有 URL 正常生成 |
| glob loader 的 slug 包含 `zh/` 前缀需要剥离 | 在 `getStaticPaths()` 中统一处理，写测试验证 |
| Pagefind 搜索结果可能混合中英文 | v1 可接受，v2 考虑按 `data-pagefind-meta="lang"` 分索引 |
| AI 翻译质量参差不齐 | 脚本输出后必须人工审校，不自动发布 |
| RSS feed 需要适配多语言 | v1 先只保留中文 feed，v2 添加 `/en/rss.xml` |
| sitemap 需要包含 hreflang 信息 | Astro sitemap 插件支持 i18n 配置，需要同步更新 |

## Open Questions

- Astro 5 的 content collection glob loader 在子目录结构下，slug 的具体解析行为需要验证（是否自动包含子目录路径）
- `[...slug].astro` 路由与 Astro i18n 路由的交互——是否需要改为 `src/pages/[lang]/[...slug].astro` 还是让 Astro i18n middleware 处理？
