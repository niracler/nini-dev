## ADDED Requirements

### Requirement: Design Token Completeness

设计系统 **MUST** 为所有常见 UI 场景提供语义化 token，避免硬编码值。

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

#### Scenario: 按钮悬停阴影 token

- **GIVEN** 按钮需要悬停效果
- **WHEN** 设置 hover 状态阴影
- **THEN** 使用 `var(--shadow-button-hover)` 或纯颜色变化
- **AND** 不使用硬编码 rgba 阴影值

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

### Requirement: Unified Drawer Component

系统 **MUST** 提供统一的抽屉组件，所有侧边滑入的面板都应使用此组件。

#### Scenario: 导航抽屉使用统一组件

- **GIVEN** 移动端导航菜单
- **WHEN** 点击汉堡按钮
- **THEN** 使用 `<Drawer>` 组件显示导航内容
- **AND** 使用标准的打开/关闭动画
- **AND** 使用统一的滚动锁定

#### Scenario: TOC 抽屉使用统一组件

- **GIVEN** 移动端目录面板
- **WHEN** 点击目录按钮
- **THEN** 使用 `<Drawer>` 组件显示目录内容
- **AND** 使用与导航抽屉相同的动画效果

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

## MODIFIED Requirements

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
