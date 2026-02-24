# blog-comments Delta Specification

## MODIFIED Requirements

### Requirement: 发表评论

用户 SHALL 能够在博客文章下方发表评论。登录用户自动使用账号信息，匿名用户手动填写昵称（必填）、邮箱（可选）、网站（可选）。评论内容必填，支持 Markdown。

#### Scenario: 登录用户发表评论

- **WHEN** 已登录用户填写评论内容并提交
- **THEN** 评论使用用户账号的昵称和头像
- **AND** 评论关联 user_id
- **AND** 表单不显示 author/email/website 字段（自动填充）
- **AND** 评论出现在文章评论列表中

#### Scenario: 匿名用户发表评论

- **WHEN** 未登录用户填写昵称和评论内容并通过 Turnstile 验证
- **THEN** 评论出现在文章评论列表中
- **AND** 评论内容以 Markdown 渲染显示
- **AND** 显示作者昵称和发表时间
- **AND** 表单清空，Turnstile widget 重置
- **AND** 新评论即时插入列表对应位置（无需刷新页面）
- **AND** 评论的 user_id 为空

#### Scenario: 必填字段缺失

- **WHEN** 匿名用户未填写昵称或评论内容就提交
- **THEN** 表单显示验证错误提示
- **AND** 评论不会被提交

#### Scenario: 输入超出长度限制

- **WHEN** 用户提交的昵称超过 50 字符、评论内容超过 5000 字符、网站超过 200 字符或邮箱超过 200 字符
- **THEN** API 返回 400 错误并提示具体哪个字段超限
- **AND** 前端保留已填写内容，显示错误提示

#### Scenario: Turnstile 验证失败

- **WHEN** 用户提交评论但 Turnstile 验证不通过
- **THEN** API 返回 403 错误
- **AND** 前端提示用户重试

#### Scenario: 提交中的 loading 状态

- **WHEN** 用户点击提交按钮
- **THEN** 按钮显示 loading 状态并禁用
- **AND** 防止重复提交
- **AND** API 返回错误时表单内容保留，按钮恢复可用

### Requirement: 作者信息展示

系统 SHALL 根据用户身份类型展示不同的作者信息。

#### Scenario: 登录用户的评论

- **WHEN** 评论关联了 user_id
- **THEN** 显示该用户的头像（来自 OAuth provider）和昵称
- **AND** 如果该用户 role 为 admin，显示管理员标识

#### Scenario: 匿名用户有网站

- **WHEN** 匿名评论作者填写了网站 URL
- **THEN** 昵称渲染为指向该网站的可点击链接
- **AND** 链接在新标签页打开，带有 `rel="nofollow noopener"` 属性

#### Scenario: 匿名用户无网站

- **WHEN** 匿名评论作者未填写网站
- **THEN** 昵称显示为纯文本

#### Scenario: 匿名用户有邮箱（Gravatar 头像）

- **WHEN** 匿名评论作者填写了邮箱
- **THEN** 通过邮箱的 MD5 哈希从 Gravatar 获取头像显示
- **AND** 邮箱地址不在前端暴露（仅用于头像获取）

#### Scenario: 匿名用户无邮箱

- **WHEN** 匿名评论作者未填写邮箱
- **THEN** 显示 Gravatar 默认占位头像（mystery-person）

### Requirement: 管理员删除评论

管理员 SHALL 能够删除或隐藏不当评论。管理员身份通过 session-based 角色检查或 ADMIN_TOKEN Bearer 鉴权确认。

#### Scenario: Session-based 管理员删除

- **WHEN** 已登录管理员（role='admin'）发送 DELETE 请求
- **THEN** 评论状态变为 deleted
- **AND** 不需要 Authorization header

#### Scenario: Token-based 管理员删除（过渡期）

- **WHEN** 请求携带有效的 `Authorization: Bearer <ADMIN_TOKEN>` header
- **THEN** 评论状态变为 deleted（与 session-based 行为一致）

#### Scenario: 删除评论（有回复）

- **WHEN** 管理员删除一条有回复的评论
- **THEN** 评论状态变为 deleted
- **AND** 前端显示"该评论已删除"占位符，回复照常展示

#### Scenario: 删除评论（无回复）

- **WHEN** 管理员删除一条无回复的评论
- **THEN** 评论状态变为 deleted
- **AND** 该评论不再在前端显示

#### Scenario: 隐藏评论

- **WHEN** 管理员发送 PATCH 请求将状态设为 hidden
- **THEN** 评论状态变为 hidden
- **AND** 该评论不再在前端显示

#### Scenario: 未授权操作

- **WHEN** 请求不含有效的 admin session 或 ADMIN_TOKEN
- **THEN** 返回 401 错误
- **AND** 评论状态不变

### Requirement: 评论列表展示

系统 SHALL 在文章页面展示该文章的所有可见评论，按时间正序排列，回复嵌套在父评论下方。评论区顶部 SHALL 显示登录/用户状态栏。

#### Scenario: 未登录状态的评论区

- **WHEN** 未登录用户访问文章评论区
- **THEN** 评论区顶部显示「GitHub 登录」和「Telegram 登录」按钮
- **AND** 下方显示完整评论表单（含 author/email/website 字段）

#### Scenario: 已登录状态的评论区

- **WHEN** 已登录用户访问文章评论区
- **THEN** 评论区顶部显示用户头像、昵称、「登出」按钮
- **AND** 如果用户未关联所有 provider，显示「关联 Telegram/GitHub」按钮
- **AND** 评论表单只显示内容输入框（无 author/email/website）

#### Scenario: 加载文章评论

- **WHEN** 用户访问一篇有评论的文章
- **THEN** 评论区显示所有可见评论
- **AND** 顶层评论按创建时间正序排列
- **AND** 每条评论的回复按创建时间正序排列在其下方
- **AND** 登录用户的评论显示 OAuth 头像，匿名评论显示 Gravatar 头像
