## Requirements

### Requirement: i18n 路由

系统 SHALL 支持多语言 URL 路由，默认语言（中文）无前缀，英文使用 `/en/` 前缀。

#### Scenario: 访问中文文章

- **WHEN** 用户访问 `/elegant`
- **THEN** 显示中文版文章
- **AND** `<html lang="zh-CN">`

#### Scenario: 访问英文文章

- **WHEN** 用户访问 `/en/elegant`
- **THEN** 显示英文版文章
- **AND** `<html lang="en">`

#### Scenario: 访问不存在的英文翻译

- **WHEN** 用户访问 `/en/<slug>` 但该文章没有英文版
- **THEN** 返回 404 页面

#### Scenario: 现有 URL 不变

- **WHEN** 用户访问任何现有的中文文章 URL
- **THEN** URL 路径与 i18n 改造前完全一致
- **AND** 无 301/302 重定向

### Requirement: 内容子目录结构

系统 SHALL 使用子目录结构组织多语言内容，`zh/` 和 `en/` 分别存放中文和英文文章。

#### Scenario: 中文内容存放

- **WHEN** 在 `src/content/blog/zh/` 下存放 Markdown 文件
- **THEN** Astro 构建时生成对应的中文页面
- **AND** URL 路径不包含 `zh/` 前缀

#### Scenario: 英文内容存放

- **WHEN** 在 `src/content/blog/en/` 下存放与中文同名的 Markdown 文件
- **THEN** Astro 构建时生成对应的英文页面
- **AND** URL 路径包含 `/en/` 前缀

#### Scenario: 部分翻译

- **WHEN** `en/` 目录下只有部分文章
- **THEN** 只有这些文章生成英文页面
- **AND** 未翻译的文章没有英文 URL

### Requirement: 翻译对应关系

系统 SHALL 通过文件名（slug）自动识别中英文章的对应关系。

#### Scenario: 同名文件自动配对

- **WHEN** `blog/zh/elegant.md` 和 `blog/en/elegant.md` 同时存在
- **THEN** 系统识别两者为同一篇文章的中英版本

#### Scenario: 无对应翻译

- **WHEN** `blog/zh/monthly-review.md` 存在但 `blog/en/monthly-review.md` 不存在
- **THEN** 系统识别该文章无英文翻译

### Requirement: 语言切换组件

系统 SHALL 在有对应翻译的文章页面上显示语言切换入口。

#### Scenario: 文章有翻译版本

- **WHEN** 用户浏览一篇有英文翻译的中文文章
- **THEN** 文章标题下方显示语言切换链接（如 "Read in English"）
- **AND** 点击后导航到 `/en/<slug>`

#### Scenario: 英文页面切换回中文

- **WHEN** 用户浏览一篇英文文章
- **THEN** 文章标题下方显示语言切换链接（如 "阅读中文版"）
- **AND** 点击后导航到 `/<slug>`

#### Scenario: 文章无翻译版本

- **WHEN** 用户浏览一篇没有英文翻译的中文文章
- **THEN** 不显示语言切换组件

### Requirement: hreflang SEO 标签

系统 SHALL 在有翻译对的页面输出 hreflang `<link>` 标签，支持搜索引擎识别多语言版本。

#### Scenario: 有翻译对的文章

- **WHEN** 渲染一篇有中英双版本的文章
- **THEN** `<head>` 中包含三条 hreflang 标签：`zh`、`en`、`x-default`
- **AND** 每条标签的 `href` 指向完整的绝对 URL

#### Scenario: 无翻译对的文章

- **WHEN** 渲染一篇只有中文版本的文章
- **THEN** 不输出 hreflang 标签

### Requirement: 文章列表按语言筛选

系统 SHALL 在文章列表页面按当前语言筛选显示的文章。

#### Scenario: 中文博客列表

- **WHEN** 用户访问 `/blog`
- **THEN** 只显示中文文章列表

#### Scenario: 英文博客列表

- **WHEN** 用户访问 `/en/blog`
- **THEN** 只显示有英文翻译的文章列表

### Requirement: AI 辅助翻译工作流

系统 SHALL 提供 CLI 脚本将中文文章翻译为英文 Markdown 文件。

#### Scenario: 翻译一篇文章

- **WHEN** 用户运行 `pnpm translate <slug>`
- **THEN** 读取 `src/content/blog/zh/<slug>.md`
- **AND** 调用 AI API 翻译标题、描述和正文
- **AND** 保留 frontmatter 结构（pubDate、tags 等不变）
- **AND** 输出到 `src/content/blog/en/<slug>.md`

#### Scenario: 已有翻译文件

- **WHEN** 用户运行 `pnpm translate <slug>` 但 `en/<slug>.md` 已存在
- **THEN** 提示用户确认是否覆盖
- **AND** 不自动覆盖

#### Scenario: 源文件不存在

- **WHEN** 用户运行 `pnpm translate <slug>` 但 `zh/<slug>.md` 不存在
- **THEN** 输出错误信息并退出

### Requirement: sitemap 多语言支持

系统 SHALL 在 sitemap 中包含多语言页面信息。

#### Scenario: 有翻译对的文章

- **WHEN** 生成 sitemap
- **THEN** 翻译对的文章包含 `xhtml:link` 元素指向各语言版本
