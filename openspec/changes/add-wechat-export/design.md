## Context

博客文章以 Markdown/MDX 格式存储在 `src/content/blog/` 下，通过 Astro 构建为网页。现在希望将部分文章发布到微信公众号，但微信编辑器对格式有严格限制。

微信公众号的格式约束：

- 仅支持 inline CSS，不支持 `<style>` 标签或外部 CSS
- 外部链接被过滤（只能链接已发布的公众号文章或白名单域名）
- 图片必须上传到微信 CDN，外链图片会被替换为占位图
- 不支持 `<script>`、iframe、自定义 HTML 组件
- 代码块支持有限，无语法高亮
- 不支持 Mermaid 图表、数学公式等扩展语法

博客现有的 Markdown 处理链：

- remark 插件：remarkAlert、remarkModifiedTime
- rehype 插件：rehypeSlug、rehypeAutolinkHeadings、rehypeMermaid、rehypePicture、rehypeImgSize、rehypeFigure
- 部分文章使用 MDX 嵌入自定义组件（如 Spoiler）

用户需求：生成微信兼容 HTML → 手动复制粘贴到微信编辑器 → 发布。不需要 API 对接。

## Goals / Non-Goals

**Goals:**

- 将博客 Markdown 转换为微信公众号编辑器可直接粘贴的 HTML
- 处理微信不支持的元素（外链→脚注、Mermaid→图片、代码块→样式化）
- 支持自定义排版主题（字号、行距、配色）
- 输出需要手动处理的项目清单（如需上传的图片列表）

**Non-Goals:**

- 不对接微信公众号 API（不自动发布/创建草稿）
- 不上传图片到微信 CDN（输出图片清单供手动上传）
- 不处理 MDX 自定义组件（遇到时降级为纯文本或跳过）
- 不做实时预览（输出 HTML 文件，浏览器打开即可预览）
- 不支持微信小程序卡片等富媒体嵌入

## Decisions

### 1. 工具形态：pnpm script + TypeScript

**决定：** 在 `repos/bokushi` 中创建 `scripts/wechat-export.ts`，通过 `pnpm wechat-export <slug>` 调用

**原因：**

- 与博客项目同仓库，可直接读取内容文件
- 复用项目已有的 remark/rehype 生态和 TypeScript 工具链
- 通过 `tsx` 运行（项目 devDependencies 已有 ts 工具链）

**替代方案：** 独立 CLI 工具或在线转换器。但文章源文件在本地，独立工具需要额外的文件路径配置，不如集成在项目中方便。

### 2. 转换管线：remark → rehype → 微信 HTML

**决定：** 构建独立的 unified 管线，复用部分博客的 remark 插件，rehype 阶段替换为微信适配插件

```
Markdown 源文件
     │
     ▼
  remark parse
     │
     ├── remarkAlert（保留，微信兼容）
     │
     ▼
  remark-rehype
     │
     ├── rehypeWechatLinks     → 外链转脚注
     ├── rehypeWechatImages    → 图片提取清单 + 占位提示
     ├── rehypeWechatCode      → 代码块 inline CSS 着色
     ├── rehypeWechatStyle     → 全局 inline CSS 注入
     │
     ▼
  rehype-stringify（输出 HTML）
```

**原因：**

- 与博客的构建管线独立，不影响网站构建
- 可以针对微信的限制逐一编写 rehype 插件
- 管线可测试、可扩展

### 3. 外链处理：转为文末脚注

**决定：** 行内链接转为脚注样式，文末输出链接列表

**转换示例：**

```
输入：请参考 [Astro 文档](https://astro.build) 和 [MDN](https://developer.mozilla.org)

输出：请参考 Astro 文档[1] 和 MDN[2]


[1] Astro 文档: https://astro.build
[2] MDN: https://developer.mozilla.org
```

**原因：**

- 微信公众号正文中外链不可点击，只有「阅读原文」可以放一个链接
- 脚注方式保留了链接信息，读者可手动复制
- 自动提取最重要的链接建议放在「阅读原文」位置

### 4. 图片处理：提取清单 + 占位

**决定：** 不自动上传图片，而是输出图片清单供手动处理

**流程：**

```
转换时：
  1. 扫描所有 <img> 标签
  2. 生成图片清单（序号、原始路径/URL、alt 文本）
  3. HTML 中保留图片位置，加占位提示文字

输出的图片清单（终端打印）：
  📷 需要手动上传到微信的图片：
  [1] /images/elegant-cover.jpg (封面图)
  [2] https://example.com/diagram.png (架构图)

HTML 中：
  <p style="text-align:center;color:#999;">[图片 1: 封面图 - 请在微信编辑器中插入]</p>
```

**原因：**

- 微信图片 API 需要公众号 access_token，引入认证复杂度
- 手动上传最可靠，编辑器内拖拽即可
- 清单让用户明确知道需要处理哪些图片

### 5. 代码块处理：inline CSS 语法高亮

**决定：** 使用 shiki 生成 inline style 的语法高亮 HTML

**原因：**

- 博客已使用 shiki（Astro 内置），风格一致
- shiki 支持输出 inline style（不依赖 CSS class）
- 微信编辑器能保留 `<pre><code>` + inline style 的代码块
- 使用 `github-light` 主题，因为微信阅读通常是浅色背景

**降级策略：** 如果代码块在微信中渲染异常，提供一个 `--no-highlight` 选项输出纯文本代码块。

### 6. 排版主题：CSS 变量 → inline style 映射

**决定：** 预设一个默认主题，支持通过 JSON 配置文件自定义

**默认主题配置（`scripts/wechat-themes/default.json`）：**

```json
{
  "body": { "font-size": "16px", "line-height": "1.8", "color": "#333" },
  "h1": { "font-size": "22px", "font-weight": "bold", "margin": "24px 0 12px" },
  "h2": { "font-size": "20px", "font-weight": "bold", "margin": "20px 0 10px" },
  "h3": { "font-size": "18px", "font-weight": "bold", "margin": "16px 0 8px" },
  "p": { "margin": "12px 0" },
  "blockquote": { "border-left": "3px solid #ddd", "padding-left": "12px", "color": "#666" },
  "code-inline": { "background": "#f5f5f5", "padding": "2px 4px", "border-radius": "3px", "font-size": "14px" },
  "code-block": { "background": "#f8f8f8", "padding": "12px", "border-radius": "4px", "font-size": "13px", "overflow-x": "auto" },
  "footnote": { "font-size": "14px", "color": "#666" }
}
```

**原因：**

- 微信排版偏好因人而异（字号、行距、配色）
- JSON 配置易于修改，不需要改代码
- 后续可以添加更多主题（如暗色系、极简系）

### 7. Mermaid 图表处理

**决定：** 跳过 Mermaid 渲染，输出提示文字

**原因：**

- 博客中 Mermaid 图通过 `rehypeMermaid` 在构建时渲染为 inline SVG
- SVG 在微信编辑器中支持不可靠
- 将 Mermaid 转为 PNG 需要引入 puppeteer/playwright 等重量级依赖
- 实际使用频率低，手动截图更实际

**输出：**

```html
<p style="text-align:center;color:#999;background:#f5f5f5;padding:12px;">
  [图表 - 请从博客页面截图后插入]
</p>
```

### 8. 输出结构

**决定：** 输出 HTML 文件 + 终端摘要

```
pnpm wechat-export elegant

输出文件：dist/wechat/elegant.html
终端输出：
  ✅ 转换完成: dist/wechat/elegant.html
  📷 需处理的图片: 3 张（见文件内标注）
  🔗 外链转脚注: 5 个
  ⚠️  跳过的元素: 1 个 Mermaid 图表
  💡 建议「阅读原文」链接: https://niracler.com/elegant
```

HTML 文件可直接在浏览器中打开预览效果，确认后复制粘贴到微信编辑器。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 微信编辑器粘贴后样式丢失或变形 | 输出的 HTML 全部使用 inline style，减少被过滤的可能；需要实际测试验证 |
| MDX 文件中的自定义组件无法转换 | 遇到 JSX 组件时输出占位提示，不中断转换 |
| 代码块在微信中可能溢出 | 加 `overflow-x: auto` + `word-break: break-all` 降级 |
| 不同手机上微信排版可能有差异 | 使用保守的 inline style，避免依赖微信特定渲染行为 |
| 图片手动上传流程繁琐 | 清单明确标注每张图的位置和用途，降低遗漏风险 |

## Open Questions

- 微信编辑器的粘贴行为是否会过滤某些 inline style 属性？需要实际测试确认哪些 CSS 属性是安全的
- 是否需要支持「阅读原文」链接的自动生成（在 HTML 末尾提示用户在微信编辑器中设置）？
- 表格在微信中的渲染效果如何？是否需要转为图片？
