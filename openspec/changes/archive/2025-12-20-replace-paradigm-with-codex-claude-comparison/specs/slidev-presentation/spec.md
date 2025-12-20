## ADDED Requirements

### Requirement: Codex vs Claude 对比页面

演示文稿 SHALL 包含一个基于社区调研和基准测试数据对比 Codex CLI 和 Claude Code 的页面。

#### Scenario: 显示性能指标

- **WHEN** 用户查看 Codex vs Claude 页面
- **THEN** 对比表显示：代码质量（SWE-bench）、上下文窗口、执行速度、交互风格

#### Scenario: 包含社区情绪数据

- **WHEN** 用户查看 Codex vs Claude 页面
- **THEN** 显示社区偏好数据（Reddit 500+ 评论分析），含百分比分布

#### Scenario: 对比行为特征

- **WHEN** 用户查看 Codex vs Claude 页面
- **THEN** 表格对比指令遵循风格、执行反馈行为、典型问题

#### Scenario: 提供场景适配建议

- **WHEN** 用户查看 Codex vs Claude 页面
- **THEN** 指导说明哪种工具适合哪类任务（如：需求明确 → Codex，快速迭代 → Claude）

#### Scenario: 包含记忆点引用

- **WHEN** 用户查看 Codex vs Claude 页面
- **THEN** 显示 HN「精灵」引用，说明 Codex 字面化指令遵循的行为特点

#### Scenario: 提供详细脚注

- **WHEN** 用户查看 Codex vs Claude 页面
- **THEN** 至少 6 个脚注引用来源，包括：SWE-bench、Reddit 情绪分析、HN 讨论、官方文档
