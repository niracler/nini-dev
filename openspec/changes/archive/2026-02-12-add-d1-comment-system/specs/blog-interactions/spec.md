## ADDED Requirements

### Requirement: 评论数显示

系统 SHALL 在文章列表或文章页面展示评论数，与现有点赞数并列。

#### Scenario: 文章页面显示评论数

- **WHEN** 用户访问一篇有评论的文章
- **THEN** 在交互区域显示评论数（如 💬 5）
- **AND** 与点赞数（♥ 42）并列展示

#### Scenario: 无评论时不显示数字

- **WHEN** 用户访问一篇没有评论的文章
- **THEN** 评论数显示为 0 或不显示数字
