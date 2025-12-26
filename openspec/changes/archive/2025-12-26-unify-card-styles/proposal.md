# Change: unify-card-styles

## Why

博客通过 "vibe-coding" 方式构建，缺乏正式的设计系统，导致圆角（7 种值）、阴影（60% 硬编码 rgba）、hover 效果（浮夸的 translateY）等视觉不一致问题。

## What Changes

- 建立 `.surface-card` 组件系统及其变体（`--soft`、`--compact`、`--hover-border`）
- 将圆角统一为仅使用 `--radius-sm`、`--radius-md`、`--radius-lg`
- 将阴影统一为使用 `--shadow-soft`/`--shadow-strong` 令牌
- **移除所有 translateY hover 效果**，改用背景色或边框变化
- 更新 design-primitives.md 反映新规范

## Impact

- Affected specs: design-system (create)
- Affected code: `src/styles/global.css`, `src/pages/channel/`, `src/pages/mangashots/`, `src/components/PostList.astro`

---

## 范围

### 包含

- 建立 `.surface-card` 组件系统及其变体
- 将圆角统一为仅使用 `--radius-sm`、`--radius-md`、`--radius-lg`
- 将内边距统一为使用 `--space-*` 令牌
- **简化 hover 效果**：仅使用背景色或边框变化，移除 translateY
- 将现有卡片类元素迁移到新系统
- 更新 design-primitives.md 反映新规范

### 不包含

- 按钮组件统一（单独提案）
- 灯箱合并（单独提案）
- 抽屉组件抽象（单独提案）

## 关键决策

1. **纯 CSS 方案**：无需新建 Astro 组件；通过修饰类扩展 `.surface-card`
2. **克制的 hover 策略**：
   - `--subtle`：仅背景色微调（默认）
   - `--border`：边框颜色变化
   - 不再使用 translateY 上浮效果
3. **向后兼容**：迁移期间现有类保持功能

## 成功标准

- 所有卡片类元素使用定义好的 surface 变体之一
- 圆角值从 7 种减少到 3 种
- 组件样式中零硬编码 rgba 阴影
- **零 translateY hover 效果**
- design-primitives.md 更新为简化后的规范

## 影响范围

| 文件 | 变更 |
|------|------|
| `src/styles/global.css` | 添加 surface-card 变体，移除上浮效果 |
| `src/pages/channel/[...cursor].astro` | 迁移 4 个卡片样式 |
| `src/pages/mangashots/index.astro` | 迁移 3 个卡片样式 |
| `src/components/PostList.astro` | 迁移 post-link 样式 |
| `src/content/blog/design-primitives.md` | 更新设计规范文档 |
| `AGENTS.md` (CLAUDE.md) | 同步更新 Design Reference 章节 |

## 参考资料

- [design-primitives.md](../../../repos/bokushi/src/content/blog/design-primitives.md) - "统一卡片样式" 章节
- [tokens.css](../../../repos/bokushi/src/styles/tokens.css) - 设计令牌定义
