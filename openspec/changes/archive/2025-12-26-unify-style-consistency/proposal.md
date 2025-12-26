# Change: Unify Style Consistency

## Why

bokushi 博客的样式架构存在系统性问题，导致维护困难、代码重复、视觉不一致：

### 问题 1：硬编码值泛滥（约 24% 样式定义违规）

- `border-radius`: 10% 使用硬编码值（6px, 8px, 12px）而非 token
- `box-shadow`: 40% 使用内联 rgba 而非 token
- `hover` 效果: 47% 使用 translateY/scale 上浮动画，违反设计规范

### 问题 2：功能重复实现（3 套相同逻辑）

- **滚动锁定**: Header.astro、blog-interactive.ts、灯箱组件各自实现
- **抽屉组件**: 导航抽屉、TOC 抽屉使用不同实现方式
- **灯箱组件**: GlobalImageLightbox、Pandabox、mangashots 三套独立实现

### 问题 3：样式层级混乱

- `mangashots/index.astro` 使用 27 处 `!important` 强制覆盖样式
- JS 文件中硬编码样式值（postPreview.ts、blog-interactive.ts）
- 样式定义分散在 CSS、Astro `<style>`、JS `style.*` 多处

### 问题 4：缺少必要的 Token

- 灯箱背景色（backdrop）
- 灯箱阴影（shadow-lightbox）
- 按钮悬停状态

## What Changes

### Phase 1: 样式规范化（低风险，快速见效）

**1.1 Token 完善**

- 新增 `--color-backdrop`, `--shadow-lightbox` 等灯箱相关 token
- 新增 `--color-button-hover-bg` 按钮悬停 token

**1.2 硬编码消除**

- 替换所有硬编码 `border-radius` 为 `--radius-*` token
- 替换所有硬编码 `box-shadow` 为 `--shadow-*` token

**1.3 Hover 效果规范化**

- 移除所有 `translateY`/`scale` hover 动画
- 统一使用颜色/边框变化

### Phase 2: 组件抽象（中等复杂度，长期收益）

**2.1 抽取公共工具**

- `scrollLock.ts`: 统一滚动锁定逻辑
- `useDrawer.ts`: 抽屉状态管理 hook

**2.2 抽取公共组件**

- `Drawer.astro`: 统一抽屉组件（导航/TOC 复用）
- `Lightbox.astro`: 统一灯箱组件（替代 3 套实现）

**2.3 消除 !important**

- 重构 mangashots 筛选器样式层级
- 确保组件样式不需要强制覆盖

### Phase 3: JS 样式剥离（可选，视情况）

**3.1 样式外移**

- 将 postPreview.ts 中的硬编码样式移至 CSS
- 将 blog-interactive.ts 中的动态样式移至 CSS 变量

## Impact

### Affected specs

- `design-system` (扩展)

### Affected code

**Phase 1（7 个文件）**:

- `src/styles/tokens.css` - 新增 token
- `src/styles/global.css` - 可能微调
- `src/components/GlobalImageLightbox.astro` - 8 处修改
- `src/pages/channel/[...cursor].astro` - 7 处修改
- `src/pages/mangashots/index.astro` - 12 处修改

**Phase 2（新增 + 重构）**:

- `src/utils/scrollLock.ts` - 新增
- `src/components/Drawer.astro` - 新增
- `src/components/Lightbox.astro` - 新增
- `src/components/Header.astro` - 重构使用 Drawer
- `src/scripts/blog-interactive.ts` - 重构使用 scrollLock

**Phase 3（2 个文件）**:

- `src/scripts/postPreview.ts`
- `src/scripts/blog-interactive.ts`

## Success Criteria

### Phase 1

- 所有 `border-radius` 使用 `--radius-*` token
- 所有 `box-shadow` 使用 `--shadow-*` token
- 所有 hover 效果仅使用颜色/边框变化
- `openspec validate --strict` 通过

### Phase 2

- 滚动锁定逻辑只有一处实现
- 抽屉逻辑统一使用 Drawer 组件
- 灯箱逻辑统一使用 Lightbox 组件
- mangashots 页面 `!important` 数量降至 0

### Phase 3

- JS 文件中无硬编码样式值
- 所有动画/过渡使用 CSS 定义

## Out of Scope

- 响应式断点管理统一（单独 change）
- CSS 类命名规范制定（单独 change）
- Tailwind utility vs 语义类选择（单独 change）
- 性能优化（单独 change）

## Risks

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Phase 2 组件抽象可能引入回归 | 中 | 分文件逐步迁移，每步验证 |
| 移除 hover 动画影响用户体验 | 低 | 用更精致的颜色变化补偿 |
| !important 移除可能破坏布局 | 中 | 先理解为什么需要 !important |
