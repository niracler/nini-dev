# Design: Bokushi Design System Documentation

## Context

bokushi 博客通过 vibe-coding 搭建，设计系统已经相当成熟：

- `tokens.css` 定义了完整的 CSS 变量（色彩、字体、间距、圆角、阴影、过渡）
- `global.css` 包含所有组件样式（`.surface-card`、`.pill`、`.prose`、`.icon-btn` 等）
- `design-primitives.md` 是一篇以 Apple HIG 为框架的设计文档博客文章

当前问题：

1. 博客文章只有文字和表格，没有**视觉展示**（色块、字体样例、组件实物）
2. AI agent 没有结构化的设计参考，需要从 CSS 源码逆向推断 token
3. 文章缺少部分内容（按钮系统、阴影层级、响应式断点、Do's/Don'ts 汇总）

Astro MDX 集成已配置（`@astrojs/mdx`），可直接在博文中嵌入 Astro 组件。

## Goals / Non-Goals

**Goals:**

- 创建 agent 可直接消费的 DESIGN.md（awesome-design-md 9-section 标准格式）
- 创建独立 HTML 预览文件用于本地视觉验证
- 将博客文章升级为 MDX，嵌入实时渲染的设计展示组件
- 补全文章中缺失的设计内容（从现有代码提炼，不新增设计）

**Non-Goals:**

- 不改变现有视觉设计或 token 值
- 不引入新的 CSS 组件或设计模式
- 不部署 preview.html 为公开页面
- 不重构现有样式代码

## Decisions

### Decision 1: 展示组件使用纯 Astro 组件（无框架依赖）

**选择**：用 `.astro` 组件渲染展示内容，通过 CSS 变量直接引用博客自身的 token

**理由**：

- 展示组件是纯静态的，不需要客户端交互
- 直接使用博客的 CSS 变量，确保展示效果和实际效果**永远同步**
- 无额外 JS bundle 开销

**替代方案**：使用 React/Vue 组件

- 缺点：增加客户端 JS、需要 hydration、复杂度更高
- 对于纯展示来说过度工程

### Decision 2: 展示组件的数据来源

**选择**：在组件中硬编码 token 名称和值的映射表

**理由**：

- Token 变化频率极低（上次大改是 2025-12）
- 从 CSS 文件动态解析增加不必要的构建复杂度
- 硬编码让组件自包含，容易理解和修改

**风险**：token 值变更时需要同步更新组件

**缓解**：组件数量少（3-4 个），变更时全局搜索即可

### Decision 3: 设计预览页架构

**选择**：`src/pages/design-preview.astro`，复用 Phase 2 的展示组件，公开部署但不加导航入口

**理由**：

- 复用展示组件，避免手动内联 token 的维护负担
- 公开部署让任何人通过 URL 直接查看设计系统
- 截图嵌入 README.md，作为项目的视觉名片
- 页面不加导航入口，访问者需要知道 URL 才能到达

**页面包含的 section**（通过组合展示组件实现）：

1. 页面标题 + 简介
2. `<ColorPalette />` — 色板色块
3. `<TypographyScale />` — 字体阶梯
4. `<ComponentShowcase />` — 卡片变体、pill、按钮、阴影层级

**截图方案**：

- 手动截图（`pnpm dev` → 浏览器访问 → 截图），分 light/dark 两张
- 存放于 `docs/design-preview-light.png` + `docs/design-preview-dark.png`
- README.md 中嵌入截图展示

### Decision 4: DESIGN.md 与 design-primitives.mdx 的职责划分

**选择**：两份文件，不同受众，允许内容重叠

| 维度 | DESIGN.md | design-primitives.mdx |
|------|-----------|----------------------|
| 受众 | AI agent | 人类读者（博客访客） |
| 语言 | English | 中文 |
| 格式 | 标准 9-section | Apple HIG 三层结构 |
| 视觉 | 无（纯文本） | MDX 组件实时渲染 |
| 位置 | 项目根目录 | 博客内容目录 |

**理由**：

- Agent 需要结构化、可预测的格式（9 固定 section）
- 人类读者需要叙事性、有视觉的文档
- 维护成本可接受：token 值变化时两处都需更新，但变化频率低

### Decision 5: .md → .mdx 迁移策略

**选择**：直接 git mv 重命名，保留 git 历史

**注意事项**：

- Astro 的 content collection 会自动识别 `.mdx` 文件
- 现有 frontmatter 完全兼容
- MDX 中的 markdown 语法保持不变
- 需要在文件顶部添加 `import` 语句引入展示组件

### Decision 6: Pre-commit Token 一致性检查

**选择**：pre-commit hook 在 `tokens.css` 变更时自动校验所有引用处的硬编码值

**标注格式**：展示组件中使用结构化数组存储 token 映射

```astro
const tokens = [
  { name: "--color-bg-page", value: "#faf9f6" },
  { name: "--color-text-body", value: "#2c2c2c" },
  // ...
]
```

DESIGN.md 中也使用可解析的格式（如 `| --color-bg-page | #faf9f6 |` 表格行）。

**检查范围**（宽松模式）：只校验文件中已引用的 token 值是否与 `tokens.css` 一致，不强制覆盖所有 token。

**检查目标**：

- `DESIGN.md` 中的 token 值表格
- `src/components/design/*.astro` 中的 token 数组
- `src/content/blog/zh/design-primitives.mdx` 中引用的具体值

**触发条件**：`tokens.css` 在 staged files 中时执行

**失败行为**：列出不一致的 token 及期望值 vs 实际值，阻止 commit。附提示截图可能也需要更新。

**脚本语言**：Node（与 bokushi 项目栈一致）

**理由**：

- 结构化数组既服务于组件渲染（数据驱动），又便于脚本解析，一举两得
- 宽松模式避免强制展示每个内部 token，维护成本可控
- pre-commit 是最轻量的自动化入口，无需 CI 配置

## Risks / Trade-offs

### Risk 1: Token 硬编码导致展示与实际不同步

组件中硬编码的色值可能与 `tokens.css` 不一致。

**缓解**：展示组件的色块**使用 CSS 变量作为 background**（`var(--color-bg-page)`），只有标注的 hex 文本是硬编码的。这样色块颜色永远正确，只有文字标注可能过期。

### Risk 2: 预览页截图与实际页面不同步

截图是静态产物，token 变更后截图不会自动更新。

**缓解**：截图仅用于 README 展示，给人一个直观印象。实际预览页 `/design-preview` 始终是最新的。重大设计变更时重新截图即可。

### Risk 3: MDX 构建兼容性

.mdx 文件的 remark/rehype 插件链路可能与 .md 不同。

**缓解**：Astro MDX 集成已配置并在项目中使用。实施前用一个简单的测试 .mdx 验证插件链路。

## Open Questions

1. ~~**SpacingScale 组件是否必要？**~~ **已决定**：跳过，间距 token 名称已自解释
2. ~~**preview.html 是否需要添加到 .gitignore？**~~ **已决定**：改为 Astro 页面，公开部署
