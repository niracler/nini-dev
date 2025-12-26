# Design: Unify Style Consistency

## Context

bokushi 是一个通过 vibe-coding 构建的个人博客，使用 Astro + Tailwind CSS 4。由于开发过程中缺乏统一规范，样式实现存在以下技术债务：

- 设计 token 体系已建立（tokens.css），但未被一致使用
- 多个功能独立实现（灯箱、抽屉、滚动锁定）
- 样式定义分散在 CSS、Astro、JS 三处
- 部分组件使用 `!important` 强制覆盖样式

**约束条件**：

- 用户为前端初学者，方案需简单可维护
- 博客已上线，需保证改动不破坏现有功能
- 使用 Astro 框架，组件为 `.astro` 文件

## Goals / Non-Goals

### Goals

- 建立一致的样式使用规范
- 减少代码重复，提高可维护性
- 为后续开发提供清晰的模式参考
- 精简 `design-primitives.md` 中的"待重构"列表

### Non-Goals

- 不进行大规模重构（如迁移到其他 CSS 方案）
- 不改变现有视觉设计（颜色、间距、圆角值）
- 不引入新的构建工具或依赖

## Decisions

### Decision 1: 分三阶段实施

**选择**：Phase 1 → Phase 2 → Phase 3 渐进式改进

**理由**：

- Phase 1 是纯样式替换，风险最低，可快速验证
- Phase 2 涉及组件抽象，需要更多设计思考
- Phase 3 是优化项，可视实际需要决定是否执行

**替代方案**：

- 一次性全面重构 → 风险太高，容易引入回归
- 只做 Phase 1 → 无法解决根本的重复实现问题

### Decision 2: 新增 Token 而非修改现有 Token

**选择**：在 `tokens.css` 中新增灯箱/按钮相关 token

```css
/* 新增 token */
--color-backdrop: rgba(0, 0, 0, 0.65);
--color-backdrop-dark: rgba(0, 0, 0, 0.85);
--shadow-lightbox: 0 20px 60px rgba(0, 0, 0, 0.4);
--shadow-button-hover: 0 6px 20px rgba(251, 143, 104, 0.3);
```

**理由**：

- 不影响现有使用 token 的代码
- 为特定场景（灯箱、按钮悬停）提供语义化命名
- 便于后续统一调整

### Decision 3: 统一灯箱使用 `<dialog>` 元素

**选择**：三套灯箱统一基于原生 `<dialog>` 实现

**理由**：

- GlobalImageLightbox 和 Pandabox 已使用 `<dialog>`
- 原生语义，自带焦点管理和 ESC 关闭
- 无需额外依赖

**实现方式**：

```astro
<!-- 统一的 Lightbox 组件 API -->
<Lightbox
  images={images}
  variant="default" | "gallery" | "manga"
  showCounter={true}
  showCaption={true}
/>
```

### Decision 4: 抽屉组件使用 Tailwind 类而非 CSS 变量动画

**选择**：保持现有 Tailwind 类（`translate-x-full`、`opacity-0`）的动画方式

**理由**：

- Header.astro 已使用此模式，运行良好
- Tailwind 类易于理解和修改
- 避免引入新的动画系统

**统一接口**：

```astro
<!-- Drawer 组件 -->
<Drawer id="nav-drawer" position="right">
  <slot />
</Drawer>

<!-- 使用 -->
<script>
  import { openDrawer, closeDrawer } from '@/utils/drawer';
  openDrawer('nav-drawer');
</script>
```

### Decision 5: 滚动锁定使用 CSS 类而非直接操作 style

**选择**：统一使用 `document.body.classList.add('scroll-locked')`

**理由**：

- CSS 类更易于调试（DevTools 可见）
- 避免 `style.overflow` 与其他内联样式冲突
- 便于扩展（如同时锁定 html 元素）

**实现**：

```css
/* global.css */
body.scroll-locked {
  overflow: hidden;
}
```

```typescript
// utils/scrollLock.ts
export function lockScroll() {
  document.body.classList.add('scroll-locked');
}
export function unlockScroll() {
  document.body.classList.remove('scroll-locked');
}
```

### Decision 6: 消除 !important 通过调整选择器优先级

**选择**：重构 mangashots 的 `.filter-chip` 样式，避免与全局样式冲突

**分析**：mangashots 使用 27 个 `!important` 是因为 `.filter-chip` 样式被其他规则覆盖。

**解决方案**：

1. 检查冲突源：可能是 Tailwind 基础样式或 global.css 中的规则
2. 使用更具体的选择器（如 `.manga-page .filter-chip`）
3. 或将 filter-chip 改为独立类名（如 `.manga-filter-chip`）避免冲突

## Risks / Trade-offs

| 决策 | 风险 | 缓解 |
|------|------|------|
| 分阶段实施 | 中间状态代码混合新旧模式 | 每阶段完成后更新文档 |
| 统一灯箱组件 | 三套灯箱功能有差异，统一可能丢失特性 | 先列出各灯箱完整功能表，确保覆盖 |
| 移除 hover 动画 | 用户可能觉得交互反馈减弱 | 用颜色变化 + 细微边框变化补偿 |
| 消除 !important | 可能意外影响其他页面样式 | 使用 scoped 选择器，限制影响范围 |

## Migration Plan

### Phase 1 迁移步骤

1. **tokens.css 扩展**
   - 添加新 token
   - 不修改现有 token 值

2. **硬编码替换**（按文件逐个处理）
   - GlobalImageLightbox.astro
   - channel/[...cursor].astro
   - mangashots/index.astro

3. **Hover 效果修复**
   - 搜索所有 `:hover` 中的 `translateY`/`scale`
   - 替换为颜色/边框变化

4. **验证**
   - 本地预览各页面
   - 对比修改前后截图

### Phase 2 迁移步骤

1. **创建公共工具**
   - `src/utils/scrollLock.ts`
   - 在 global.css 添加 `.scroll-locked` 类

2. **创建 Drawer 组件**
   - 基于 Header.astro 中的抽屉实现
   - 迁移 Header 使用新组件
   - 迁移 blog-interactive.ts 中的 TOC 抽屉

3. **创建 Lightbox 组件**
   - 分析三套灯箱的功能差异
   - 设计统一 API
   - 逐个页面迁移

4. **消除 !important**
   - 分析 mangashots 样式冲突原因
   - 重构选择器

### Rollback Plan

每个 Phase 作为独立 PR：

- Phase 1 回滚：revert token 修改 + 硬编码替换
- Phase 2 回滚：删除新组件，恢复原实现
- Phase 3 回滚：恢复 JS 中的样式定义

## Open Questions

1. **Pandabox 的缩放动画是否保留？**
   - 目前 Pandabox 有 zoom-in/zoom-out 动画
   - GlobalImageLightbox 没有
   - 统一后是否都需要？

2. **mangashots 灯箱是否需要与其他灯箱统一？**
   - 它有独立的加载状态处理
   - 可能需要作为 Lightbox 的一个 variant

3. **postPreview 的 hover 卡片是否纳入这次改动？**
   - 它使用 JS 动态定位
   - 可能需要保留部分 JS 样式操作

## Appendix: 问题定位速查

### 硬编码位置

```
border-radius:
  - channel/[...cursor].astro: 400, 417, 554, 586 行
  - mangashots/index.astro: 470, 534, 604 行

box-shadow:
  - GlobalImageLightbox.astro: 194 行
  - channel/[...cursor].astro: 557, 652 行
  - mangashots/index.astro: 471, 548, 652, 671 行

translateY/scale hover:
  - GlobalImageLightbox.astro: 216, 238 行
  - mangashots/index.astro: 547, 571, 581 行
  - channel/[...cursor].astro: 644 行
```

### 重复实现位置

```
滚动锁定:
  - Header.astro: 162, 176 行 (classList)
  - blog-interactive.ts: 242, 249 行 (style.overflow)

抽屉逻辑:
  - Header.astro: 158-179 行
  - blog-interactive.ts: 236-266 行
```
