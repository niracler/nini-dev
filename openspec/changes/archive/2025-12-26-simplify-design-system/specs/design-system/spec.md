## REMOVED Requirements

### Requirement: Unified Drawer Component

**Reason**: 过早抽象。当前只有两个抽屉（导航抽屉、TOC 抽屉），它们的触发方式、内容结构、定位都不同。独立实现已工作良好，抽象的复用收益极低。如果未来新增更多抽屉场景，可重新评估。

**Migration**: 无需迁移，保持现有独立实现。

---

## MODIFIED Requirements

### Requirement: Design Token Completeness

设计系统 **MUST** 为高频 UI 场景（灯箱、卡片、按钮）提供语义化 token。低频场景（仅 1-2 处使用）**SHALL** 允许使用硬编码值。

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

---

## ADDED Requirements

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
