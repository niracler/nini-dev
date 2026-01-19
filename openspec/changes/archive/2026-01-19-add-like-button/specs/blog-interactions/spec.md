# Blog Interactions

博客文章的用户互动功能。

## ADDED Requirements

### Requirement: 文章点赞

用户 SHALL 能够对博客文章进行点赞，表达对内容的喜爱。

#### Scenario: 首次点赞文章

- **WHEN** 用户点击未点赞文章的爱心按钮
- **THEN** 爱心图标变为实心红色
- **AND** 点赞数增加 1
- **AND** 点赞状态保存到 localStorage

#### Scenario: 取消点赞

- **WHEN** 用户点击已点赞文章的爱心按钮
- **THEN** 爱心图标变为空心
- **AND** 点赞数减少 1
- **AND** localStorage 中的点赞状态被移除

#### Scenario: 页面加载时恢复点赞状态

- **WHEN** 用户访问之前点赞过的文章
- **THEN** 爱心图标显示为实心红色
- **AND** 显示当前总点赞数

### Requirement: 点赞数显示

系统 SHALL 在点赞按钮旁边显示文章的总点赞数。

#### Scenario: 显示点赞数

- **WHEN** 文章页面加载完成
- **THEN** 爱心图标旁显示当前点赞总数

#### Scenario: 实时更新点赞数

- **WHEN** 用户点赞或取消点赞
- **THEN** 显示的点赞数立即更新

### Requirement: 点赞频率限制

系统 SHALL 限制同一用户对同一文章只能点赞一次，防止恶意刷赞。

#### Scenario: 同一 IP 重复点赞被阻止

- **WHEN** 同一 IP 地址尝试对同一文章多次点赞
- **THEN** 服务端拒绝重复点赞请求
- **AND** 返回当前点赞状态（已点赞）

#### Scenario: 不同文章独立计数

- **WHEN** 用户点赞文章 A 后访问文章 B
- **THEN** 文章 B 显示为未点赞状态
- **AND** 用户可以独立点赞文章 B
