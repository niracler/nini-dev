# Change: 为博客添加 i18n 多语言支持

## Why

博客目前是纯中文站点，希望精选文章能提供英文版本，触达更广的读者群体。计划以 AI 辅助翻译为主、人工审校为辅，逐步扩大翻译覆盖范围。Astro 5 已内置 i18n 路由支持，现在是引入多语言架构的好时机。

## What Changes

- 启用 Astro 原生 i18n 路由，默认语言（zh）无前缀，英文版使用 `/en/` 前缀
- 内容目录重构为子目录结构：`src/content/blog/zh/`、`src/content/blog/en/`（til、monthly 同理）
- 新增语言切换组件，仅在有对应翻译版本时显示
- Content schema 新增 `lang` 字段，支持按语言筛选
- 新增 AI 辅助翻译工作流（脚本或 Claude Code skill），输入中文源文件，输出英文 Markdown
- 更新 `<html lang>` 为动态值，根据当前页面语言设置
- 更新 sitemap 和 RSS 适配多语言（`hreflang` 标签、per-language feed）
- 现有 URL 结构不变（`/elegant` 等中文文章路径保持不动）

### 分阶段交付

| 阶段 | 范围 |
|------|------|
| v1 | i18n 路由 + 内容目录重构 + 语言切换组件 + 首批 3-5 篇文章翻译 |
| v2 | AI 翻译工作流自动化（脚本/skill）、翻译同步机制（源文件更新时提示） |
| v3 | UI 文案国际化（导航、页脚、日期格式等）、per-language RSS、SEO hreflang |

## Capabilities

### New Capabilities

- `blog-i18n`: 博客多语言支持——i18n 路由、内容子目录结构、语言切换、翻译工作流、多语言 SEO

### Modified Capabilities

_无现有 capability 的需求变更。_

## Impact

- Affected repo: `repos/bokushi`
- Affected code:
  - `astro.config.mjs` → 新增 i18n 配置
  - `src/content/` → 目录重构（blog/zh/、blog/en/ 等）
  - `src/content.config.ts` → schema 新增 lang 字段
  - `src/pages/[...slug].astro` → 适配多语言路由
  - `src/pages/blog/index.astro` → 按语言筛选文章列表
  - `src/layouts/BlogPost.astro` → 动态 lang 属性、语言切换入口
  - `src/components/` → 新增 LanguageSwitcher 组件
  - `src/components/BaseHead.astro` → hreflang 元标签
- Dependencies: 无新增外部依赖（Astro 原生支持）
- Rollback plan: i18n 配置和路由改动集中在 astro.config 和 pages 目录，回退只需还原配置并将内容从子目录移回原位
