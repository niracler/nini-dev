# design-system Specification

## Purpose
TBD - created by archiving change unify-card-styles. Update Purpose after archive.
## Requirements
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

---

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

---

### Requirement: Border Radius Standardization

所有组件的圆角值 **MUST** 使用标准 token（`--radius-sm`、`--radius-md`、`--radius-lg`），**MUST NOT** 使用硬编码值。

#### Scenario: Channel 页面卡片圆角

- **GIVEN** `.channel-info-card` 和 `.telegram-post` 样式
- **WHEN** 审查圆角值
- **THEN** 使用 `var(--radius-lg)` (16px)
- **AND** 不使用硬编码的 12px

#### Scenario: MangaShots 页面输入框和芯片圆角

- **GIVEN** `.manga-search` 和 `.filter-chip` 样式
- **WHEN** 审查圆角值
- **THEN** 搜索框使用 `var(--radius-lg)` (16px)
- **AND** 筛选芯片使用 `var(--radius-md)` (10px)
- **AND** 不使用硬编码的 14px 或 8px

#### Scenario: 分页链接圆角

- **GIVEN** `.pagination-link` 样式
- **WHEN** 审查圆角值
- **THEN** 使用 `var(--radius-md)` (10px)
- **AND** 不使用硬编码的 8px

#### Scenario: 灯箱按钮圆角

- **GIVEN** 灯箱的控制按钮样式
- **WHEN** 审查圆角值
- **THEN** 圆形按钮使用 `border-radius: 50%`（允许）
- **AND** 非圆形按钮使用 `var(--radius-*)` token

---

### Requirement: Shadow Token Usage

所有卡片阴影 **MUST** 使用设计令牌（`--shadow-soft`、`--shadow-strong`、`--shadow-lightbox`），**MUST NOT** 使用内联 rgba 定义。

#### Scenario: Channel 页面卡片阴影

- **GIVEN** `.telegram-post` 和 `.channel-info-card` 样式
- **WHEN** 审查阴影值
- **THEN** 使用 `var(--shadow-soft)` 或 `var(--shadow-strong)`
- **AND** 不使用 `rgba(0, 0, 0, 0.05)` 等硬编码值

#### Scenario: MangaShots 页面阴影

- **GIVEN** `.manga-shot-item` 样式
- **WHEN** 审查阴影值
- **THEN** 使用简化的单层阴影令牌
- **AND** 不使用多层自定义 rgba 阴影

#### Scenario: 灯箱内容阴影

- **GIVEN** 灯箱中显示的图片容器
- **WHEN** 审查阴影值
- **THEN** 使用 `var(--shadow-lightbox)`
- **AND** 不使用硬编码 `0 20px 60px rgba(0, 0, 0, 0.4)`

#### Scenario: 内阴影 token 化

- **GIVEN** 使用 `inset` 阴影的元素
- **WHEN** 审查阴影值
- **THEN** 使用 `var(--shadow-inset)` 或移除内阴影
- **AND** 不使用硬编码 `inset 0 2px 4px rgba(0, 0, 0, 0.05)`

### Requirement: Hover Effect Constraints

所有卡片的 hover 效果 **MUST NOT** 使用 translateY 上浮或 scale 放大动画，**MUST** 仅使用背景色或边框变化。

#### Scenario: 检查 Channel 页面 hover

- **GIVEN** `.telegram-post` 和 `.pagination-link` 样式
- **WHEN** 鼠标悬停
- **THEN** 不发生 `translateY` 位移
- **AND** 不发生 `scale` 缩放
- **AND** 仅使用背景色或边框变化

#### Scenario: 检查 MangaShots 页面 hover

- **GIVEN** `.manga-shot-item` 样式
- **WHEN** 鼠标悬停
- **THEN** 不发生 `translateY(-12px)` 位移
- **AND** 不发生 `scale(1.02)` 放大
- **AND** 仅使用背景色变化

#### Scenario: 检查灯箱控制按钮 hover

- **GIVEN** 灯箱的关闭、上一张、下一张按钮
- **WHEN** 鼠标悬停
- **THEN** 不发生 `scale(1.05)` 或 `scale(1.15)` 放大
- **AND** 仅使用背景色或边框变化

#### Scenario: 检查全局导航按钮 hover

- **GIVEN** 任何可点击的按钮或链接
- **WHEN** 鼠标悬停
- **THEN** 过渡效果仅涉及 `color`、`background-color`、`border-color`、`opacity`
- **AND** 不使用 `transform` 属性

---

### Requirement: Design Token Completeness

设计系统 **MUST** 为高频 UI 场景（灯箱、卡片、按钮）提供语义化 token。低频场景（仅 1-2 处使用）**SHALL** 允许使用硬编码值。**MUST** 包含符合 Apple HIG 的排版和对比度 token。

#### Scenario: 灯箱背景 token

- **GIVEN** 需要创建灯箱遮罩层
- **WHEN** 设置背景色
- **THEN** 使用 `var(--color-backdrop)` 或 `var(--color-backdrop-dark)`
- **AND** 不使用硬编码 `rgba(0, 0, 0, 0.65)` 等值

#### Scenario: 灯箱阴影 token

- **GIVEN** 需要为灯箱内容添加阴影
- **WHEN** 设置 box-shadow
- **THEN** 使用 `var(--shadow-lightbox)`
- **AND** 不使用硬编码 `0 20px 60px rgba(0, 0, 0, 0.4)` 等值

#### Scenario: 低频场景允许硬编码

- **GIVEN** 某个样式值仅在 1-2 处使用
- **WHEN** 评估是否需要 token 化
- **THEN** 可选择保持硬编码
- **AND** 无需强制创建新 token

#### Scenario: 排版 token 完整性

- **GIVEN** 需要设置正文字号
- **WHEN** 选择 font-size 值
- **THEN** `--font-size-base` **MUST** 为 1.0625rem (17px)
- **AND** 提供完整的字号阶梯 (xs, sm, base, lg, xl, 2xl, 3xl)

#### Scenario: 对比度 token 合规

- **GIVEN** 需要设置 muted text 颜色
- **WHEN** 定义 `--color-text-muted`
- **THEN** 该颜色在主要背景上的对比度 **MUST** 达到 4.5:1

### Requirement: Scroll Lock Utility

系统 **MUST** 提供统一的滚动锁定工具，所有需要锁定滚动的场景都应使用此工具。

#### Scenario: 打开模态框时锁定滚动

- **GIVEN** 用户打开灯箱或抽屉
- **WHEN** 模态内容显示
- **THEN** 调用 `lockScroll()` 函数
- **AND** body 元素添加 `scroll-locked` 类
- **AND** 不直接操作 `document.body.style.overflow`

#### Scenario: 关闭模态框时解锁滚动

- **GIVEN** 用户关闭灯箱或抽屉
- **WHEN** 模态内容隐藏
- **THEN** 调用 `unlockScroll()` 函数
- **AND** body 元素移除 `scroll-locked` 类

---

### Requirement: Unified Lightbox Component

系统 **MUST** 提供统一的灯箱组件，所有图片预览功能都应使用此组件。

#### Scenario: 博客文章图片使用统一灯箱

- **GIVEN** `.prose` 区域内的图片
- **WHEN** 用户点击图片
- **THEN** 使用统一的 `<Lightbox>` 组件显示大图
- **AND** 支持左右导航和计数显示

#### Scenario: 图集使用统一灯箱

- **GIVEN** Pandabox 图集页面
- **WHEN** 用户点击缩略图
- **THEN** 使用 `<Lightbox variant="gallery">` 显示大图
- **AND** 保持缩放动画效果

#### Scenario: 漫画表情包使用统一灯箱

- **GIVEN** mangashots 页面图片
- **WHEN** 用户点击表情包
- **THEN** 使用 `<Lightbox variant="manga">` 显示大图
- **AND** 支持加载状态指示

---

### Requirement: No Important Override

组件样式 **MUST NOT** 使用 `!important` 覆盖其他样式，应通过合理的选择器设计避免冲突。

#### Scenario: 筛选器芯片样式

- **GIVEN** mangashots 页面的筛选器按钮
- **WHEN** 定义 `.filter-chip` 或类似样式
- **THEN** 不使用 `!important` 声明
- **AND** 使用足够具体的选择器（如 `.manga-page .filter-chip`）避免冲突

#### Scenario: 检查现有 !important 使用

- **GIVEN** 审查代码中的 `!important` 使用
- **WHEN** 发现非第三方库的 `!important`
- **THEN** 应分析冲突原因并重构
- **AND** 仅在覆盖第三方库样式时允许使用 `!important`

---

### Requirement: Token Usage Consistency

组件样式 **MUST** 使用统一的 token 引用方式，优先使用 Tailwind utility class。

#### Scenario: 文字颜色引用

- **GIVEN** 需要设置文字颜色
- **WHEN** 选择引用方式
- **THEN** 使用 `text-primary`、`text-secondary` 等 Tailwind utility
- **AND** 不使用 `text-[var(--color-text-primary)]` bracket notation

#### Scenario: 背景颜色引用

- **GIVEN** 需要设置背景颜色
- **WHEN** 选择引用方式
- **THEN** 使用 `bg-page`、`bg-surface` 等 Tailwind utility
- **AND** 不使用 `bg-[var(--color-bg-page)]` bracket notation

#### Scenario: 边框颜色引用

- **GIVEN** 需要设置边框颜色
- **WHEN** 选择引用方式
- **THEN** 使用 `border-soft`、`border-subtle` 等 Tailwind utility
- **AND** 不使用 `border-[var(--color-border-soft)]` bracket notation

#### Scenario: 例外情况

- **GIVEN** 需要使用 `color-mix()` 等动态计算
- **WHEN** Tailwind utility 无法满足需求
- **THEN** 可使用 bracket notation 或内联 style
- **AND** 应评估是否值得新增专用 token

---

### Requirement: Apple HIG Typography Compliance

设计系统 **MUST** 遵循 Apple Human Interface Guidelines 的排版原则，确保良好的可读性和清晰的层级。

#### Scenario: 基础字号为 17px

- **GIVEN** 任意正文内容
- **WHEN** 渲染文本
- **THEN** `--font-size-base` 应为 1.0625rem (17px)
- **AND** 与 Apple HIG 推荐的 17pt 默认字号一致

#### Scenario: 标题层级清晰

- **GIVEN** 文章内容包含 h1-h4 标题
- **WHEN** 检查标题字号
- **THEN** 相邻层级字号差异至少为 4px
- **AND** h1 至少为 2rem (32px+)
- **AND** 标题从 h1 到 h4 呈现明确的视觉权重递减

---

### Requirement: WCAG AA Color Contrast

设计系统 **MUST** 确保所有文字与背景的对比度符合 WCAG AA 标准。

#### Scenario: Muted text 对比度达标

- **GIVEN** 使用 `--color-text-muted` 的文本
- **WHEN** 显示在 `--color-bg-page` 或 `--color-bg-surface` 背景上
- **THEN** 对比度 **MUST** 达到 4.5:1 以上
- **AND** 适用于 light 和 dark 两种主题

#### Scenario: Secondary text 对比度达标

- **GIVEN** 使用 `--color-text-secondary` 的文本
- **WHEN** 显示在主要背景上
- **THEN** 对比度 **MUST** 达到 4.5:1 以上

---

### Requirement: Content Breathing Space

设计系统 **MUST** 为内容区域提供充分的留白，让内容成为视觉焦点。

#### Scenario: 文章页面内容区留白

- **GIVEN** BlogPost 布局的文章内容区
- **WHEN** 在桌面端渲染
- **THEN** 内容区应有足够的 padding (至少 1.5rem)
- **AND** 段落之间应有明确的间隔

#### Scenario: 移动端内容区适配

- **GIVEN** BlogPost 布局在移动端
- **WHEN** 屏幕宽度小于 640px
- **THEN** padding 应适当减少但不低于 1rem
- **AND** 保持内容可读性

---

### Requirement: Subtle Animation

设计系统 **MUST** 使用微妙、不干扰的动画效果。

#### Scenario: 首页动画微妙

- **GIVEN** 首页的装饰性动画
- **WHEN** 动画播放
- **THEN** opacity 变化范围 **SHOULD** 不超过 0.1 (如 0.95-1.0)
- **AND** 动画周期 **SHOULD** 足够长 (4s+) 以避免分散注意力

#### Scenario: 尊重用户动效偏好

- **GIVEN** 用户系统设置 `prefers-reduced-motion: reduce`
- **WHEN** 渲染任何动画
- **THEN** **MUST** 禁用或大幅简化动画效果

---

