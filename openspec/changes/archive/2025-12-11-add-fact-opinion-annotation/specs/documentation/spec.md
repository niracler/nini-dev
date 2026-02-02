## ADDED Requirements

### Requirement: 观点标注规范

文档中的主观观点内容 SHALL 使用 GitHub-flavored Alerts 进行标注，区分事实与观点。

#### Scenario: 作者观点标注

- **WHEN** 内容是作者的个人看法、经验总结或主观判断
- **THEN** 使用 `> [!NOTE] 作者观点` 格式包裹该内容

#### Scenario: 专家观点标注

- **WHEN** 引用业内专家的观点或言论
- **THEN** 使用 `> [!TIP] 专家观点 — {姓名}` 格式
- **AND** 首次出现时提供专家背景信息（身份、立场、来源）
- **AND** 后续出现时可简化为姓名 + 脚注引用

#### Scenario: 行业分析标注

- **WHEN** 内容是行业预测、研究机构分析或趋势判断
- **THEN** 使用 `> [!IMPORTANT] 行业分析` 格式

#### Scenario: 事实内容不标注

- **WHEN** 内容是有高等级信源支持的可验证事实
- **THEN** 不添加观点标注
- **AND** 确保有脚注引用信源

### Requirement: 信源等级体系

所有引用信源 SHALL 在脚注中标注等级，帮助读者评估可信度。

#### Scenario: 信源等级标记

- **WHEN** 添加或修改脚注引用
- **THEN** 在脚注内容前添加等级标记
- **AND** 格式为 `{emoji} L{等级} | {来源信息}`

#### Scenario: 等级划分标准

- **WHEN** 信源是原始论文或官方公告（arXiv、官方博客）
- **THEN** 标记为 `🔬 L1`

- **WHEN** 信源是权威媒体或专业研究机构（Nature、Reuters、METR）
- **THEN** 标记为 `📰 L2`

- **WHEN** 信源是行业媒体或知名博主（The Verge、Simon Willison 博客）
- **THEN** 标记为 `📝 L3`

- **WHEN** 信源是一般博客或社交媒体（个人推文、Medium）
- **THEN** 标记为 `💬 L4`

### Requirement: 阅读指南

文档 SHALL 提供阅读指南，说明标注规则和信源等级体系。

#### Scenario: 阅读指南内容

- **WHEN** 读者首次阅读文档
- **THEN** 可在 `00-阅读指南.md` 中了解：
  - 观点标注类型及其含义
  - 信源等级体系及判定标准
  - 如何区分事实与观点

#### Scenario: 阅读指南入口

- **WHEN** 读者访问文档站点
- **THEN** sidebar 中显示阅读指南入口
