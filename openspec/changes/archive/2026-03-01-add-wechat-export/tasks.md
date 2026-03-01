# Tasks: add-wechat-export

> **流程**: Phase 1 → 2 → 3 → 4，每个 Phase 有 Gate 条件。
> **交付策略**: 单 PR 交付（变更集中在 `repos/bokushi`）。

## Phase 1: 项目搭建与基础转换管线

- [x] 1.1 创建 `scripts/wechat-export.ts`，搭建 CLI 入口：解析参数（slug、--theme）、读取 Markdown 源文件
- [x] 1.2 在 `package.json` 中添加 `wechat-export` script 命令
- [x] 1.3 搭建 unified 管线骨架：remark parse → remark-rehype → rehype-stringify，验证基础 Markdown 转 HTML 正常
- [x] 1.4 创建 `scripts/wechat-themes/default.json`：默认排版主题（字号、行距、配色等）
- [x] 1.5 实现 `rehypeWechatStyle`：将主题 JSON 映射为 inline CSS 注入到各 HTML 元素

**Gate**: `pnpm wechat-export <slug>` 可输出基础 HTML 到 `dist/wechat/<slug>.html`，使用 inline CSS

## Phase 2: 微信适配插件

- [x] 2.1 实现 `rehypeWechatLinks`：行内链接转脚注格式，文末输出脚注列表，相同 URL 复用编号
- [x] 2.2 实现 `rehypeWechatImages`：提取图片清单，HTML 中替换为占位提示文字
- [x] 2.3 实现 `rehypeWechatCode`：使用 shiki 生成 inline style 语法高亮（github-light 主题），行内代码应用主题样式
- [x] 2.4 实现 Mermaid 代码块处理：检测 `language-mermaid`，替换为占位提示
- [x] 2.5 集成 remarkAlert 插件（复用博客的 GitHub-style blockquote alerts）

**Gate**: 包含链接、图片、代码块、Mermaid 的文章能正确转换，各元素按预期处理

## Phase 3: 输出与主题

- [x] 3.1 实现转换摘要终端输出：文件路径、图片数量、脚注数量、跳过元素、建议阅读原文链接
- [x] 3.2 实现 `--theme` 参数支持：从 `scripts/wechat-themes/<name>.json` 加载自定义主题
- [x] 3.3 处理源文件不存在、主题文件不存在等错误场景
- [x] 3.4 确保输出 HTML 不含 `<style>` 标签和外部 CSS 引用

**Gate**: 终端摘要信息完整，自定义主题可切换，错误提示友好

## Phase 4: 验证与实战测试

- [x] 4.1 选取 2-3 篇代表性文章（含代码块、图片、链接较多的文章）进行转换测试
- [x] 4.2 在浏览器中打开输出的 HTML 文件，验证排版效果
- [x] 4.3 将 HTML 粘贴到微信公众号编辑器，验证样式保留情况
- [x] 4.4 根据实际粘贴效果调整 inline CSS（如有被过滤的属性）
- [x] 4.5 `pnpm lint` 通过 Biome 检查
- [x] 4.6 提交 PR
