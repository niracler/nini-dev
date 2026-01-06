# Skill Discovery

从 Claude Code session 历史中发现可复用的工作模式，并将其转化为 Skill 的工作流。

## ADDED Requirements

### Requirement: Session 分析能力

系统 SHALL 支持分析 Claude Code session JSONL 文件，提取以下信息：
- 主题标签（3-5 个关键词）
- 工具调用序列
- 复杂度评估（1-5）
- 成功/失败指标
- 潜在 Skill 信号

#### Scenario: 分析单个 Session

- **GIVEN** 一个有效的 session JSONL 文件
- **WHEN** 执行 session 分析
- **THEN** 输出包含主题标签、工具序列、复杂度、成功指标的结构化摘要

#### Scenario: 批量分析 Sessions

- **GIVEN** 一个项目目录下的多个 session 文件
- **WHEN** 执行批量分析
- **THEN** 可以通过 Subagent 并行处理
- **AND** 输出合并后的分析结果

### Requirement: 主题聚类能力

系统 SHALL 支持对 session 摘要进行主题聚类，识别重复出现的工作模式。

#### Scenario: 识别主题簇

- **GIVEN** 多个 session 的主题标签集合
- **WHEN** 执行 LLM 聚类
- **THEN** 输出 10-15 个主题簇
- **AND** 每个簇包含关联的 session 列表

#### Scenario: 跨项目聚类

- **GIVEN** 来自多个项目的 session 摘要
- **WHEN** 执行跨项目聚类
- **THEN** 识别跨项目通用的工作模式
- **AND** 标记项目特定 vs 通用模式

### Requirement: Skill 候选识别

系统 SHALL 支持从主题簇中识别 Skill 候选，并按优先级排序。

#### Scenario: 生成候选清单

- **GIVEN** 主题聚类结果
- **WHEN** 应用候选识别规则
- **THEN** 输出 Skill 候选清单
- **AND** 每个候选包含：名称、触发场景、核心工作流、来源 sessions

#### Scenario: 候选评分排序

- **GIVEN** Skill 候选清单
- **WHEN** 应用评分公式（频率 × 复杂度 × 可复用性 × 组合性）
- **THEN** 输出按分数排序的 Top N 候选

#### Scenario: 与现有 Skill 对比

- **GIVEN** Skill 候选清单和现有 Skill 列表
- **WHEN** 执行对比分析
- **THEN** 排除已被现有 Skill 覆盖的候选
- **AND** 标记可与现有 Skill 组合的候选

### Requirement: Skill 创建循环集成

系统 SHALL 支持对选中的 Skill 候选触发标准 Skill 创建流程。

#### Scenario: 触发 Skill 创建

- **GIVEN** 用户选中一个 Skill 候选
- **WHEN** 确认实现
- **THEN** 执行 `init_skill.py` 创建骨架
- **AND** 引导用户完成 SKILL.md 编写
- **AND** 运行 `validate.sh` 验证
- **AND** 更新 marketplace.json 注册

#### Scenario: 循环发现

- **GIVEN** 完成一轮 Skill 发现和创建
- **WHEN** 用户触发新一轮分析
- **THEN** 新创建的 Skill 被纳入「现有 Skill」列表
- **AND** 后续候选可以与新 Skill 组合
