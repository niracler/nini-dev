## ADDED Requirements

### Requirement: Markdown 转微信 HTML

系统 SHALL 提供 CLI 命令将博客 Markdown 文件转换为微信公众号编辑器兼容的 HTML。

#### Scenario: 转换一篇文章

- **WHEN** 用户运行 `pnpm wechat-export <slug>`
- **THEN** 读取对应的 Markdown 源文件
- **AND** 输出微信兼容的 HTML 文件到 `dist/wechat/<slug>.html`

#### Scenario: 源文件不存在

- **WHEN** 用户运行 `pnpm wechat-export <slug>` 但源文件不存在
- **THEN** 输出错误信息并退出

#### Scenario: HTML 输出全部使用 inline CSS

- **WHEN** 转换生成 HTML
- **THEN** 所有样式 MUST 以 inline `style` 属性写入元素
- **AND** 不包含 `<style>` 标签或外部 CSS 引用

### Requirement: 外链转脚注

系统 SHALL 将 Markdown 中的外部链接转换为脚注格式，因为微信公众号不支持正文外链。

#### Scenario: 行内链接转脚注

- **WHEN** 文章包含 `[文本](https://example.com)` 格式的链接
- **THEN** 正文中渲染为 `文本[1]`
- **AND** 文末输出脚注列表：`[1] 文本: https://example.com`

#### Scenario: 多个链接编号递增

- **WHEN** 文章包含多个外部链接
- **THEN** 脚注编号按出现顺序递增
- **AND** 相同 URL 复用同一编号

#### Scenario: 建议阅读原文链接

- **WHEN** 转换完成
- **THEN** 终端输出建议设置的「阅读原文」链接（文章在博客上的 URL）

### Requirement: 图片处理

系统 SHALL 提取文章中所有图片的清单，提示用户手动上传到微信。

#### Scenario: 文章包含图片

- **WHEN** 文章包含本地或外部图片引用
- **THEN** 终端输出图片清单（序号、路径/URL、alt 文本）
- **AND** HTML 中图片位置替换为占位提示文字

#### Scenario: 文章无图片

- **WHEN** 文章不包含图片
- **THEN** 不输出图片相关信息

### Requirement: 代码块渲染

系统 SHALL 将代码块转换为带 inline CSS 语法高亮的 HTML。

#### Scenario: 有语言标注的代码块

- **WHEN** 文章包含带语言标注的围栏代码块（如 ` ```typescript `）
- **THEN** 使用 shiki 生成 inline style 语法高亮
- **AND** 使用浅色主题（适配微信阅读环境）

#### Scenario: 无语言标注的代码块

- **WHEN** 文章包含无语言标注的围栏代码块
- **THEN** 渲染为纯文本的 `<pre><code>` 块
- **AND** 应用代码块主题样式（背景色、字体等）

#### Scenario: 行内代码

- **WHEN** 文章包含行内代码（`` `code` ``）
- **THEN** 渲染为 `<code>` 标签
- **AND** 应用行内代码主题样式（背景色、padding 等）

### Requirement: Mermaid 图表处理

系统 SHALL 在微信导出时跳过 Mermaid 图表并输出占位提示。

#### Scenario: 文章包含 Mermaid 代码块

- **WHEN** 文章包含 ` ```mermaid ` 代码块
- **THEN** HTML 中输出占位提示（如 "[图表 - 请从博客页面截图后插入]"）
- **AND** 终端提示有 Mermaid 图表需手动截图

### Requirement: 排版主题

系统 SHALL 支持自定义排版主题控制输出 HTML 的视觉样式。

#### Scenario: 使用默认主题

- **WHEN** 用户运行 `pnpm wechat-export <slug>` 不指定主题
- **THEN** 使用默认主题（16px 正文、1.8 行距、#333 文字色）

#### Scenario: 指定自定义主题

- **WHEN** 用户运行 `pnpm wechat-export <slug> --theme <name>`
- **THEN** 从 `scripts/wechat-themes/<name>.json` 加载主题配置
- **AND** 应用到输出的 inline CSS 中

#### Scenario: 主题文件不存在

- **WHEN** 用户指定的主题名找不到对应的 JSON 文件
- **THEN** 输出错误信息并退出

### Requirement: 转换摘要

系统 SHALL 在转换完成后输出摘要信息，帮助用户了解需要手动处理的事项。

#### Scenario: 转换完成

- **WHEN** 转换成功
- **THEN** 终端输出摘要，包括：
- **AND** 输出文件路径
- **AND** 需手动上传的图片数量
- **AND** 外链转脚注的数量
- **AND** 跳过的元素（Mermaid 等）
- **AND** 建议的「阅读原文」链接
