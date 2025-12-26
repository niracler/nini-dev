# Design: unify-card-styles

## 架构决策

### 为什么用 CSS 类而非 Astro 组件？

**选项 A：创建 `<Surface>` Astro 组件**
- 优点：类型安全、props 约束、IDE 提示
- 缺点：需要重构所有使用卡片样式的地方、增加组件层级、对简单样式来说过度设计

**选项 B：扩展 `.surface-card` CSS 类系统（选定）**
- 优点：渐进式迁移、无需改变 HTML 结构、与 Tailwind 协作良好
- 缺点：无编译时类型检查

**决策理由**：博客是静态站点，样式一致性比运行时类型安全更重要。CSS 类方案可以逐步迁移，风险更低。

---

## Surface 变体系统

### 基础定义

```css
/* 基础卡片 */
.surface-card {
    background: var(--color-bg-surface);
    border: 1px solid var(--color-border-soft);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-soft);
}

/* 柔和变体：更弱的视觉层级 */
.surface-card--soft {
    background: color-mix(in srgb, var(--color-bg-surface) 80%, var(--color-bg-muted));
    border-color: var(--color-border-subtle);
    box-shadow: none;
}

/* 扁平变体：无阴影无边框 */
.surface-card--flat {
    border: none;
    box-shadow: none;
}

/* 紧凑尺寸：用于芯片、小标签 */
.surface-card--compact {
    padding: var(--space-2) var(--space-3);
    border-radius: var(--radius-md);
}
```

### Hover 策略

移除所有 `translateY` 上浮效果，采用克制的交互反馈：

```css
/* 默认 hover：微妙背景变化 */
.surface-card:hover {
    background: color-mix(in srgb, var(--color-bg-surface) 95%, var(--color-accent));
}

/* 边框 hover：用于需要明确反馈的交互元素 */
.surface-card--hover-border:hover {
    border-color: var(--color-accent);
}

/* 无 hover：静态展示卡片 */
.surface-card--hover-none:hover {
    /* 保持原样 */
}
```

**不再使用的效果**：
- ~~`translateY(-2px)`~~ 上浮
- ~~`scale(1.02)`~~ 放大
- ~~多层阴影增强~~

---

## 圆角规范

| Token | 值 | 使用场景 |
|-------|-----|---------|
| `--radius-sm` | 6px | 小芯片、标签、内联元素 |
| `--radius-md` | 10px | 输入框、紧凑卡片、代码块 |
| `--radius-lg` | 16px | 主要卡片、图片、对话框 |

**废弃的值**：8px、12px、14px、20px 全部归并到最近的标准值。

---

## 迁移映射

| 当前样式 | 迁移到 | 变化 |
|---------|--------|-----|
| `.channel-info-card` (12px) | `.surface-card` | 圆角 → 16px |
| `.telegram-post` (12px, translateY) | `.surface-card.surface-card--hover-border` | 圆角 → 16px，移除上浮 |
| `.manga-search` (14px, 2px border) | `.surface-card--soft` | 圆角 → 16px，边框 → 1px |
| `.filter-chip` (8px) | `.surface-card--compact` | 圆角 → 10px |
| `.manga-shot-item` (12px 20px, translateY 12px) | 自定义（保留不对称圆角） | 移除上浮，简化阴影 |
| `.post-link` (rounded-md) | `.surface-card--flat.surface-card--compact` | 使用语义类 |
| `.pagination-link` (8px, translateY) | `.surface-card--compact.surface-card--hover-border` | 圆角 → 10px，移除上浮 |

---

## design-primitives.md 简化

本次变更同时简化 design-primitives.md 中卡片相关的内容：

### 删除内容

1. **"统一卡片样式" 待重构条目**（第 673-691 行）：完成后删除
2. **冗余的 CSS 示例**：`.surface-card` 定义只保留一处
3. **过度详细的 hover 效果描述**：删除 translateY 相关说明

### 简化内容

1. **布局系统章节**：精简 `.surface-card` 介绍，指向 global.css 作为权威来源
2. **卡片变体**：用一个简洁表格替代冗长的代码示例

### 保留内容

- 设计哲学和原则
- 圆角、间距的规范定义
- 关键尺寸参考表
