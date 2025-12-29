## ADDED Requirements

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

## MODIFIED Requirements

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
