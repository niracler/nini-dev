# Change: 博客文章导出为微信公众号格式

## Why

计划逐步将部分博客文章发布到微信公众号，扩大内容分发渠道。微信公众号编辑器对格式有严格限制（不支持外链、图片必须传微信 CDN、样式只能用 inline CSS），手动从 Markdown 转换排版耗时且容易出错。需要一个半自动化工具，将博客 Markdown 源文件转换为微信兼容的富文本 HTML，复制粘贴即可发布。

## What Changes

- 新增 Markdown → 微信公众号 HTML 的转换脚本/工具
- 处理微信特殊限制：
  - 外部链接 → 转为脚注（「阅读原文」或文末链接列表）
  - 图片 → 提示手动上传或输出本地路径列表供批量上传
  - 代码块 → 微信兼容样式（inline CSS 着色或截图方案）
  - Mermaid 图表 → 导出为 PNG/SVG 内嵌
- 支持自定义排版主题（字号、行距、配色等），对齐公众号阅读体验
- 输出为可直接粘贴到微信编辑器的 HTML 文件

### 使用流程

```
pnpm wechat-export <slug>
  → 读取 src/content/blog/zh/<slug>.md
  → 转换为微信兼容 HTML
  → 输出到 dist/wechat/<slug>.html
  → 同时输出需手动处理的项目清单（图片上传列表等）
```

## Capabilities

### New Capabilities

- `blog-social-sharing`: 博客内容导出与社交平台分发——Markdown 转微信公众号格式、链接脚注化、图片清单、排版主题

### Modified Capabilities

_无现有 capability 的需求变更。_

## Impact

- Affected repo: `repos/bokushi`
- New files:
  - `scripts/wechat-export.ts`（或 `scripts/wechat-export/`）— 转换脚本
  - `scripts/wechat-themes/` — 微信排版主题模板
- Modified files:
  - `package.json` → 新增 `wechat-export` script 命令
- Dependencies: 可能新增 `unified`/`rehype` 相关插件（复用现有 remark/rehype 生态）
- Rollback plan: 纯新增文件，删除脚本和相关配置即可
