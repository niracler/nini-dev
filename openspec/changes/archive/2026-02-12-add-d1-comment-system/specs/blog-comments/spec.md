## ADDED Requirements

### Requirement: 发表评论

用户 SHALL 能够在博客文章下方发表评论，填写昵称（必填）、邮箱（可选）、网站（可选）和评论内容（必填，支持 Markdown）。

#### Scenario: 成功发表评论

- **WHEN** 用户填写昵称和评论内容并通过 Turnstile 验证
- **THEN** 评论出现在文章评论列表中
- **AND** 评论内容以 Markdown 渲染显示
- **AND** 显示作者昵称和发表时间
- **AND** 表单清空，Turnstile widget 重置
- **AND** 新评论即时插入列表对应位置（无需刷新页面）

#### Scenario: 必填字段缺失

- **WHEN** 用户未填写昵称或评论内容就提交
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

### Requirement: 嵌套回复

用户 SHALL 能够回复已有的评论，形成两层嵌套结构（评论 → 回复）。

#### Scenario: 回复顶层评论

- **WHEN** 用户点击某条评论的"回复"按钮
- **THEN** 在该评论下方展开回复表单
- **AND** 提交后回复显示在该评论的回复列表中

#### Scenario: 回复某条回复

- **WHEN** 用户点击某条回复的"回复"按钮
- **THEN** 回复表单出现在该回复所属的顶层评论下方
- **AND** 评论内容自动添加 `@被回复者昵称` 前缀
- **AND** 提交后回复归属于顶层评论（保持两层结构）

#### Scenario: 收起回复表单

- **WHEN** 用户点击"取消"或点击另一条评论的"回复"
- **THEN** 当前回复表单收起

### Requirement: 评论列表展示

系统 SHALL 在文章页面展示该文章的所有可见评论，按时间正序排列，回复嵌套在父评论下方。

#### Scenario: 加载文章评论

- **WHEN** 用户访问一篇有评论的文章
- **THEN** 评论区显示所有可见评论
- **AND** 顶层评论按创建时间正序排列
- **AND** 每条评论的回复按创建时间正序排列在其下方

#### Scenario: 文章无评论

- **WHEN** 用户访问一篇没有评论的文章
- **THEN** 评论区显示评论表单
- **AND** 显示"暂无评论"或类似提示

#### Scenario: Markdown 渲染

- **WHEN** 评论内容包含 Markdown 语法
- **THEN** 渲染为对应的 HTML（粗体、斜体、行内代码、代码块、链接、列表、引用、分割线）
- **AND** 不渲染标题语法（h1-h6），保留为原文
- **AND** HTML 经过 sanitize 处理，防止 XSS 攻击

#### Scenario: 已删除评论的展示

- **WHEN** 一条有回复的评论被管理员删除
- **THEN** 该评论位置显示"该评论已删除"占位文本
- **AND** 其下方的回复照常展示

#### Scenario: 无回复的已删除评论

- **WHEN** 一条没有回复的评论被管理员删除
- **THEN** 该评论不在列表中展示

### Requirement: 作者信息展示

系统 SHALL 根据用户提供的可选信息（网站、邮箱）丰富评论的作者展示。

#### Scenario: 作者有网站

- **WHEN** 评论作者填写了网站 URL
- **THEN** 昵称渲染为指向该网站的可点击链接
- **AND** 链接在新标签页打开，带有 `rel="nofollow noopener"` 属性

#### Scenario: 作者无网站

- **WHEN** 评论作者未填写网站
- **THEN** 昵称显示为纯文本

#### Scenario: 作者有邮箱（Gravatar 头像）

- **WHEN** 评论作者填写了邮箱
- **THEN** 通过邮箱的 MD5 哈希从 Gravatar 获取头像显示
- **AND** 邮箱地址不在前端暴露（仅用于头像获取）

#### Scenario: 作者无邮箱

- **WHEN** 评论作者未填写邮箱
- **THEN** 显示 Gravatar 默认占位头像（mystery-person）

### Requirement: 暗色模式

评论区 SHALL 跟随博客主题自动切换明暗模式。

#### Scenario: 主题切换

- **WHEN** 用户切换博客主题（明 ↔ 暗）
- **THEN** 评论区样式即时切换，无需刷新页面

#### Scenario: 初始加载

- **WHEN** 页面加载时博客处于暗色模式
- **THEN** 评论区直接以暗色样式渲染

### Requirement: Astro 页面切换兼容

评论区 SHALL 在 Astro view transition 导航后正确重新初始化。

#### Scenario: View transition 导航

- **WHEN** 用户通过 Astro view transition 从一篇文章导航到另一篇
- **THEN** 评论区重新加载新文章的评论
- **AND** 评论表单重置为初始状态

### Requirement: 反垃圾保护

系统 SHALL 使用 Cloudflare Turnstile (managed mode) 验证评论提交，阻止机器人垃圾评论。

#### Scenario: 正常用户提交

- **WHEN** 正常用户提交评论
- **THEN** Turnstile 在大多数情况下无感知通过
- **AND** 评论成功发表

#### Scenario: 可疑请求

- **WHEN** Turnstile 判定请求可疑
- **THEN** 向用户展示验证挑战
- **AND** 通过挑战后允许提交

#### Scenario: 缺少 Turnstile token

- **WHEN** API 收到不含 Turnstile token 的评论请求
- **THEN** 返回 400 错误，拒绝写入

### Requirement: 管理员删除评论

管理员 SHALL 能够删除或隐藏不当评论。

#### Scenario: 删除评论（有回复）

- **WHEN** 管理员发送带有 admin token 的 DELETE 请求，且该评论有回复
- **THEN** 评论状态变为 deleted
- **AND** 前端显示"该评论已删除"占位符，回复照常展示

#### Scenario: 删除评论（无回复）

- **WHEN** 管理员发送带有 admin token 的 DELETE 请求，且该评论无回复
- **THEN** 评论状态变为 deleted
- **AND** 该评论不再在前端显示

#### Scenario: 隐藏评论

- **WHEN** 管理员发送带有 admin token 的 PATCH 请求将状态设为 hidden
- **THEN** 评论状态变为 hidden
- **AND** 该评论不再在前端显示（与 deleted 行为一致）

#### Scenario: 未授权操作

- **WHEN** 请求不含有效的 admin token
- **THEN** 返回 401 错误
- **AND** 评论状态不变

### Requirement: 评论计数

系统 SHALL 提供 API 查询文章的评论总数。

#### Scenario: 查询单篇文章评论数

- **WHEN** 前端请求 `/api/comments/count?slug=xxx`
- **THEN** 返回该文章的可见评论总数（含回复）

#### Scenario: 批量查询评论数

- **WHEN** 前端请求 `/api/comments/count?slug=a&slug=b&slug=c`
- **THEN** 返回每篇文章对应的评论数

### Requirement: 按页面启用评论

评论功能 SHALL 支持按页面控制启用或禁用，与现有 Remark42 的 frontmatter 控制方式一致。

#### Scenario: Blog 文章默认启用

- **WHEN** 渲染 BlogPost 布局的页面
- **THEN** 评论区自动显示

#### Scenario: Page 布局按 frontmatter 控制

- **WHEN** 渲染 Page 布局的页面且 frontmatter 中 `commentsEnabled: true`
- **THEN** 评论区显示

#### Scenario: Page 布局默认不显示

- **WHEN** 渲染 Page 布局的页面且 frontmatter 中无 `commentsEnabled` 或为 false
- **THEN** 评论区不显示
