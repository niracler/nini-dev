# Change: Bokushi Design System Documentation

## Why

博客的设计系统目前仅以单篇 markdown 博客文章（`design-primitives.md`）的形式存在，只有文字描述和表格，**没有视觉展示**。同时，AI agent 在修改博客代码时缺乏机器友好的设计参考——只能从原始 CSS 文件推断 token。

参考 [awesome-design-md](https://github.com/VoltAgent/awesome-design-md) 的做法，我们需要：

1. **给人看的 living style guide**——博客文章中嵌入实际渲染的色板、字体阶梯、组件展示
2. **给 agent 看的 DESIGN.md**——项目根目录的标准化 9-section 设计规范

**涉及仓库**：`repos/bokushi`

## What Changes

### Phase 1: Agent 设计参考（DESIGN.md）

- **ADDED** `repos/bokushi/DESIGN.md` — 标准 9-section 格式（Visual Theme, Color Palette, Typography, Components, Layout, Elevation, Do's/Don'ts, Responsive, Agent Prompt Guide），从 `tokens.css` 和 `global.css` 提炼

### Phase 2: MDX 展示组件

- **ADDED** `repos/bokushi/src/components/design/ColorPalette.astro` — 色板色块渲染
- **ADDED** `repos/bokushi/src/components/design/TypographyScale.astro` — 字体阶梯展示
- **ADDED** `repos/bokushi/src/components/design/ComponentShowcase.astro` — 卡片变体、标签、代码块等组件展示

### Phase 3: 设计预览页 + README 截图

- **ADDED** `repos/bokushi/src/pages/design-preview.astro` — 公开部署的设计预览页，复用 Phase 2 展示组件，不加导航入口
- **ADDED** `repos/bokushi/docs/design-preview-light.png` — 浅色主题截图
- **ADDED** `repos/bokushi/docs/design-preview-dark.png` — 深色主题截图
- **MODIFIED** `repos/bokushi/README.md` — 嵌入设计预览截图

### Phase 4: 博客文章升级

- **MODIFIED** `repos/bokushi/src/content/blog/zh/design-primitives.md` → `.mdx`，嵌入展示组件
- **ADDED** 缺失内容：按钮系统、阴影层级、响应式断点、Do's/Don'ts 汇总
- 现有结构（HIG 三层：Foundations → Patterns → Components）保持不变

## Capabilities

### New Capabilities

- `agent-design-reference`: DESIGN.md — agent 可消费的标准化设计规范
- `design-showcase-components`: Astro 展示组件，用于 MDX 博文和预览页中嵌入实时 token 渲染
- `design-preview`: 公开部署的设计预览页（`/design-preview`），复用展示组件
- `blog-design-primitives-upgrade`: 博文升级为 MDX + 视觉展示 + 内容补全

- `token-consistency-check`: Pre-commit hook 自动校验 token 硬编码值与 `tokens.css` 的一致性

### Modified Capabilities

（无现有 specs）

## Impact

- **Affected code**:
  - `repos/bokushi/DESIGN.md`（新建）
  - `repos/bokushi/src/pages/design-preview.astro`（新建）
  - `repos/bokushi/docs/design-preview-light.png`, `design-preview-dark.png`（新建）
  - `repos/bokushi/README.md`（更新，嵌入截图）
  - `repos/bokushi/src/components/design/*.astro`（新建 3 个组件）
  - `repos/bokushi/src/content/blog/zh/design-primitives.md` → `.mdx`（重命名 + 扩展）
  - `repos/bokushi/CLAUDE.md`（更新 Design Reference 部分指向 DESIGN.md）
- **Affected code** (continued):
  - `repos/bokushi/scripts/check-token-consistency.mjs`（新建）
  - Pre-commit hook 配置（新建/更新）
- **Dependencies**: 需确认 Astro MDX integration 已配置
- **Breaking changes**: 无——展示组件为纯静态，预览页公开但无导航入口
- **Rollback plan**: 删除新建文件，将 `.mdx` 改回 `.md` 即可完全回退
