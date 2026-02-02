# Spec Delta: design-system

## ADDED Requirements

### Requirement: Surface Card Variants

系统 **MUST** 提供标准化的卡片变体类，支持不同的视觉层级和尺寸。

#### Scenario: 使用基础卡片样式

- Given 一个需要卡片样式的容器元素
- When 添加 `.surface-card` 类
- Then 元素应用 16px 圆角、柔和阴影、1px 边框

#### Scenario: 使用柔和变体

- Given 一个需要弱化视觉层级的卡片
- When 添加 `.surface-card--soft` 修饰类
- Then 卡片使用混合背景色、更淡的边框、无阴影

#### Scenario: 使用紧凑尺寸

- Given 一个芯片或小标签元素
- When 添加 `.surface-card--compact` 修饰类
- Then 元素使用 10px 圆角、更小的内边距

### Requirement: Hover Effect Simplification

所有卡片的 hover 效果 **MUST** 简化，不使用 translateY 上浮动画。

#### Scenario: 默认 hover 反馈

- Given 一个带有 `.surface-card` 类的可交互元素
- When 鼠标悬停
- Then 背景色发生微妙变化（混入少量强调色）
- And 不发生位移或缩放

#### Scenario: 边框 hover 反馈

- Given 一个带有 `.surface-card--hover-border` 修饰类的元素
- When 鼠标悬停
- Then 边框颜色变为强调色
- And 不发生位移或缩放

### Requirement: Border Radius Standardization

所有组件的圆角值 **MUST** 使用标准 token（`--radius-sm`、`--radius-md`、`--radius-lg`），**MUST NOT** 使用硬编码值。

#### Scenario: Channel 页面卡片圆角

- Given `.channel-info-card` 和 `.telegram-post` 样式
- When 审查圆角值
- Then 使用 `var(--radius-lg)` (16px)
- And 不使用硬编码的 12px

#### Scenario: MangaShots 页面输入框和芯片圆角

- Given `.manga-search` 和 `.filter-chip` 样式
- When 审查圆角值
- Then 搜索框使用 `var(--radius-lg)` (16px)
- And 筛选芯片使用 `var(--radius-md)` (10px)
- And 不使用硬编码的 14px 或 8px

#### Scenario: 分页链接圆角

- Given `.pagination-link` 样式
- When 审查圆角值
- Then 使用 `var(--radius-md)` (10px)
- And 不使用硬编码的 8px

### Requirement: Shadow Token Usage

所有卡片阴影 **MUST** 使用设计令牌（`--shadow-soft`、`--shadow-strong`），**MUST NOT** 使用内联 rgba 定义。

#### Scenario: Channel 页面卡片阴影

- Given `.telegram-post` 和 `.channel-info-card` 样式
- When 审查阴影值
- Then 使用 `var(--shadow-soft)` 或 `var(--shadow-strong)`
- And 不使用 `rgba(0, 0, 0, 0.05)` 等硬编码值

#### Scenario: MangaShots 页面阴影

- Given `.manga-shot-item` 样式
- When 审查阴影值
- Then 使用简化的单层阴影令牌
- And 不使用多层自定义 rgba 阴影

### Requirement: Hover Effect Constraints

所有卡片的 hover 效果 **MUST NOT** 使用 translateY 上浮或 scale 放大动画，**MUST** 仅使用背景色或边框变化。

#### Scenario: 检查 Channel 页面 hover

- Given `.telegram-post` 和 `.pagination-link` 样式
- When 鼠标悬停
- Then 不发生 `translateY` 位移
- And 仅使用背景色或边框变化

#### Scenario: 检查 MangaShots 页面 hover

- Given `.manga-shot-item` 样式
- When 鼠标悬停
- Then 不发生 `translateY(-12px)` 位移
- And 不发生 `scale(1.02)` 放大
- And 仅使用背景色变化
