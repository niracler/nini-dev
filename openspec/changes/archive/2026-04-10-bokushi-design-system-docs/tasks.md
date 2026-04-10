# Tasks: Bokushi Design System Documentation

## Phase 1: DESIGN.md（Agent 设计参考）

- [x] 1.1 创建 `repos/bokushi/DESIGN.md`，填写 9 个标准 section
- [x] 1.2 Section 1-2: Visual Theme & Atmosphere + Color Palette & Roles（从 tokens.css 提取所有色彩 token，标注 light/dark 值和语义角色）
- [x] 1.3 Section 3: Typography Rules（字号阶梯、行高、字体选择、粗体特殊处理）
- [x] 1.4 Section 4: Component Stylings（surface-card 变体、pill、icon-btn、underline-link，含状态描述）
- [x] 1.5 Section 5-6: Layout Principles + Depth & Elevation（spacing scale、page-shell、measure、shadow 层级）
- [x] 1.6 Section 7: Do's and Don'ts（汇总散落在各处的设计约束）
- [x] 1.7 Section 8: Responsive Behavior（断点定义、table-to-card 模式）
- [x] 1.8 Section 9: Agent Prompt Guide（色彩速查表 + 示例 prompt）
- [x] 1.9 更新 `repos/bokushi/CLAUDE.md` Design Reference 部分，添加 DESIGN.md 引用

**Gate**: 本地审阅 DESIGN.md 内容完整性

## Phase 2: MDX 展示组件

- [x] 2.1 创建 `repos/bokushi/src/components/design/ColorPalette.astro`（色板色块，使用 CSS 变量作为背景，hardcode hex 标注文字）
- [x] 2.2 创建 `repos/bokushi/src/components/design/TypographyScale.astro`（各级字号实际渲染样例）
- [x] 2.3 创建 `repos/bokushi/src/components/design/ComponentShowcase.astro`（卡片变体、pill、阴影层级展示）
- [x] 2.4 验证组件为纯 Astro（无 client: 指令、零 JS 开销）

**Gate**: `pnpm build` 成功

## Phase 3: 设计预览页 + README 截图

- [x] 3.1 创建 `repos/bokushi/src/pages/design-preview.astro`，组合 Phase 2 展示组件，公开部署但不加导航入口
- [x] 3.2 `pnpm dev` 启动后访问 `/design-preview`，验证页面渲染正常
- [x] 3.3 浅色主题截图，保存为 `docs/design-preview-light.png`
- [x] 3.4 深色主题截图，保存为 `docs/design-preview-dark.png`
- [x] 3.5 更新 `README.md`，嵌入设计预览截图

**Gate**: 截图清晰、README 展示正常

## Phase 4: 博客文章升级

- [x] 4.1 `git mv` 将 `design-primitives.md` 重命名为 `design-primitives.mdx`
- [x] 4.2 在 MDX 文件顶部添加 import 语句引入展示组件
- [x] 4.3 在 Color section 嵌入 `<ColorPalette />`
- [x] 4.4 在 Typography section 嵌入 `<TypographyScale />`
- [x] 4.5 在 Components section 嵌入 `<ComponentShowcase />`
- [x] 4.6 补充缺失内容：按钮系统（`.icon-btn` 体系，从 global.css 提炼）
- [x] 4.7 补充缺失内容：阴影层级（shadow-soft / shadow-strong / shadow-lightbox / shadow-button-hover）
- [x] 4.8 补充缺失内容：响应式断点（640px sm、768px table-to-card）
- [x] 4.9 补充缺失内容：Do's and Don'ts 汇总 section
- [x] 4.10 验证 frontmatter 保持不变，文章结构（HIG 三层）保持完整

**Gate**: `pnpm build` + `pnpm astro check` + `pnpm lint` 全部通过

## Phase 5: Pre-commit Token 一致性检查

- [x] 5.1 创建 `scripts/check-token-consistency.mjs`，解析 `tokens.css` 中所有 CSS 变量及值
- [x] 5.2 脚本扫描 `DESIGN.md` 表格行中的 token 值，对比 `tokens.css`
- [x] 5.3 脚本扫描 `src/components/design/*.astro` 中 `const tokens = [...]` 数组的 value 字段，对比 `tokens.css`
- [x] 5.4 脚本扫描 `src/content/blog/zh/design-primitives.mdx` 中引用的具体 hex/值，对比 `tokens.css`
- [x] 5.5 不一致时输出差异列表（token 名、期望值、实际值），exit 1 阻止 commit
- [x] 5.6 附提示信息：「截图（docs/design-preview-*.png）可能也需要更新」
- [x] 5.7 配置 pre-commit hook：仅在 `tokens.css` 出现在 staged files 时触发脚本
- [x] 5.8 在 `CLAUDE.md` 中记录此 hook 的存在和用途

**Gate**: 修改 `tokens.css` 中一个值后 commit，验证 hook 正确拦截并报告差异

## Validation

- [x] 6.1 运行 `pnpm build` 确认构建成功
- [x] 6.2 运行 `pnpm astro check` 确认类型检查通过
- [x] 6.3 运行 `pnpm lint` 确认代码质量检查通过
- [x] 6.4 `pnpm preview` 打开博文页面，验证展示组件正确渲染（light + dark）
- [x] 6.5 访问 `/design-preview`，验证预览页渲染正常（light + dark）
- [x] 6.6 修改一个 token 值 → commit → 验证 pre-commit hook 拦截并列出差异
- [x] 6.7 修复差异 → 重新 commit → 验证 hook 通过
