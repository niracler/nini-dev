# Tasks: add-blog-i18n

> **流程**: Phase 1 → 2 → 3 → 4 → 5，每个 Phase 有 Gate 条件。
> **交付策略**: 单 PR 交付（变更集中在 `repos/bokushi`）。

## Phase 1: Astro i18n 配置与内容迁移

- [x] 1.1 在 `astro.config.mjs` 中添加 i18n 配置：`defaultLocale: "zh"`, `locales: ["zh", "en"]`, `routing: { prefixDefaultLocale: false }`
- [x] 1.2 创建 `src/content/blog/zh/` 和 `src/content/blog/en/` 目录
- [x] 1.3 将 `src/content/blog/` 下所有现有 .md/.mdx 文件移动到 `src/content/blog/zh/`
- [x] 1.4 更新 `src/content.config.ts`：调整 glob loader 路径适配新的子目录结构
- [x] 1.5 验证 `pnpm build` 构建成功，所有现有 URL 正常生成（无 404）

**Gate**: ✅ 所有中文文章 URL 不变，构建无报错

## Phase 2: 路由适配

- [x] 2.1 更新 `src/pages/[...slug].astro` 的 `getStaticPaths()`：从 slug 中剥离 `zh/` 前缀，中文文章路由到 `/<slug>`
- [x] 2.2 添加英文路由支持：`en/` 目录下的文章路由到 `/en/<slug>`
- [x] 2.3 更新 `src/pages/blog/index.astro`：按语言筛选文章列表（默认只显示中文）
- [x] 2.4 创建 `src/pages/en/blog/index.astro`（或动态路由）：英文文章列表页
- [x] 2.5 更新 `src/layouts/BlogPost.astro`：`<html lang>` 从硬编码 `zh-CN` 改为动态值

**Gate**: ✅ 中文路由 `/<slug>` 正常，英文路由 `/en/<slug>` 正常（可用空的测试文章验证）

## Phase 3: 语言切换组件与 SEO

- [x] 3.1 创建 `src/components/LanguageSwitcher.astro`：接收当前 slug 和 locale，检查是否有对应翻译，有则显示切换链接
- [x] 3.2 在 `src/layouts/BlogPost.astro` 中集成 LanguageSwitcher，放在标题下方
- [x] 3.3 更新 `src/components/BaseHead.astro`：有翻译对时输出 hreflang `<link>` 标签（zh、en、x-default）
- [x] 3.4 更新 sitemap 配置：在 `astro.config.mjs` 的 sitemap 插件中添加 i18n 配置

**Gate**: ✅ 语言切换链接正确显示/隐藏，hreflang 标签在 HTML 源码中正确输出

## Phase 4: 翻译工作流与首批翻译

- [x] 4.1 创建 `scripts/translate.ts`：读取中文 Markdown、调用 OpenRouter API 翻译、输出英文 Markdown
- [x] 4.2 在 `package.json` 中添加 `translate` script 命令
- [x] 4.3 实现覆盖保护：目标文件已存在时提示确认
- [x] 4.4 翻译首批 3-5 篇精选文章，人工审校后提交（elegant, feed-reading-posture, about, split）

**Gate**: `pnpm translate <slug>` 可正常执行，输出的英文文章在 `/en/<slug>` 正确渲染

## Phase 5: 验证与部署

- [x] 5.1 完整构建验证：`pnpm build` 成功，无类型错误
- [x] 5.2 验证所有现有中文 URL 无变化（抽查 5 篇文章）
- [x] 5.3 验证英文文章页面：路由、lang 属性、语言切换、内容渲染
- [x] 5.4 验证无翻译的文章不显示语言切换组件
- [x] 5.5 验证 hreflang 标签正确输出
- [x] 5.6 `pnpm lint` 通过 Biome 检查
- [ ] 5.7 部署到 Cloudflare Pages 并线上验证
