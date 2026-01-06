# Design: Discover Skills from Claude Code Sessions

## Context

你有 3,700+ 个 Claude Code sessions，分布在 22 个项目中。这是一个「Compound Engineering」的实践：从历史对话中提取可复用的工作模式，转化为 Skill，实现能力复利。

**核心挑战**:

1. 数据量大（3,700+ sessions），需要批处理 + 并行
2. 非结构化数据，需要 LLM 理解和聚类
3. 从「重复模式」到「可复用 Skill」需要人类判断

**现有资产**:

- 5 个已创建的 Skill: git-workflow, ha-integration-reviewer, writing-assistant, anki-card-generator, zaregoto-miko
- `init_skill.py` 脚本
- `validate.sh` 验证工具

---

## 数据分析发现 (Phase 0-1 实际执行)

### nini-dev 项目分析

**Session 统计** (2025-12-10 ~ 2026-01-06):

| 类别 | 数量 | 说明 |
|------|------|------|
| 总文件数 | 1,391 | |
| Agent 文件 | 943 | `agent-*.jsonl` 子任务文件 |
| 主 Session | 448 | UUID 格式文件 |
| 空文件 | 266 | 无内容 |
| 小文件 (<5KB) | 900 | 快速问答或放弃的任务 |
| 中等文件 (5-50KB) | 59 | 中等复杂度任务 |
| **大文件 (>50KB)** | **166** | **高价值分析目标** |
| **实际分析目标** | **225** | >5KB 的有效 Sessions |

**修正后的批次策略**:

原计划分析 1,382 个 sessions → 实际分析 **225 个有效 sessions** (>5KB)

- 每批次 3 个 Subagent 并行，每个处理 ~55 sessions
- 优先分析大文件（>50KB），这些包含复杂工作流
- 总计 2 批次完成 nini-dev 分析

### azoulalite-dev 项目分析

| 类别 | 数量 |
|------|------|
| 总文件数 | 1,088 |
| **大文件 (>50KB)** | **134** |
| 中等文件 (5-50KB) | 55 |
| **实际分析目标** | **189** |

### ha-dev 项目分析

| 类别 | 数量 |
|------|------|
| 总文件数 | 546 |
| **大文件 (>50KB)** | **74** |
| 中等文件 (5-50KB) | 12 |
| **实际分析目标** | **86** |

### 三项目汇总

| 项目 | 大文件 | 中等文件 | 分析目标 |
|------|--------|----------|----------|
| nini-dev | 166 | 59 | 225 |
| azoulalite-dev | 134 | 55 | 189 |
| ha-dev | 74 | 12 | 86 |
| **总计** | **374** | **126** | **500** |

---

## Goals / Non-Goals

**Goals:**

- 系统性地分析所有 sessions，识别 Skill 候选
- 输出 10-20 个高价值 Skill 候选清单
- 为 Top 5 候选完成完整的 Skill 创建流程
- 验证「Skill Discovery → Skill Creation」的闭环

**Non-Goals:**

- 不追求 100% 覆盖所有 sessions（抽样足够）
- 不自动创建 Skill（需要人工 Review 每一步）
- 不改变现有 Skill 的结构

---

## 核心设计决策

### Decision 1: 分析粒度 — 抽样而非全量

**选择**: 每个项目抽样 50-100 个最近 sessions + 按时间分批

**理由**:

- 全量分析 3,700 个 session 会超出 context 限制
- 最近的 sessions 更能反映当前工作模式
- 分批可以发现模式的时间演变

**Trade-off**: 可能遗漏早期的独特模式，但可以通过 Phase 6 补充扫描弥补

### Decision 2: 聚类策略 — 主题标签 + LLM 语义聚类

**选择**: 两阶段聚类

1. **阶段 1**: 每个 session 提取 3-5 个主题标签（快速分类）
2. **阶段 2**: 用 LLM 对标签进行语义聚类（发现隐藏关联）

**理由**:

- 纯关键词聚类会错过语义相似（如「调试」和「fix bug」）
- 纯 embedding 聚类需要额外工具，增加复杂度
- LLM 聚类可以在 context 内完成，且能解释聚类理由

### Decision 3: Skill 候选识别信号

一个好的 Skill 候选应该满足：

| 信号 | 权重 | 说明 |
|------|------|------|
| **频率** | 30% | 在多少个 session 中出现类似模式 |
| **复杂度** | 25% | 工作流步骤数，越复杂越值得封装 |
| **可复用性** | 25% | 是否跨项目通用 |
| **组合性** | 20% | 与现有 Skill 的组合潜力 |

**评分公式**:

```
Score = 0.3×Freq + 0.25×Complexity + 0.25×Reusability + 0.2×Composability
```

### Decision 4: Subagent 并行策略

**选择**: 每批次启动 3 个 subagent 并行处理

**约束**:

- 每个 subagent 处理 100 个 sessions
- 输出标准化 JSON 格式便于合并
- 主 agent 负责聚类和决策

**Subagent Prompt 结构**:

```markdown
## 任务
分析以下 100 个 Claude Code session 文件

## 输入
Session 文件路径列表

## 输出要求
对每个 session 输出:
- session_id
- topics: [3-5 个主题标签]
- tool_sequence: [主要工具调用序列]
- complexity: 1-5
- success: true/false
- skill_signal: "可能的 Skill 模式描述" 或 null
```

### Decision 5: Skill 创建流程集成

发现候选后，触发标准 Skill 创建流程：

```
┌─────────────────────────────────────────────────────────────┐
│  Skill Discovery Loop (Compound Engineering)                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│  │ Discover │ → │ Evaluate │ → │  Select  │              │
│  │ (分析)   │    │ (评分)   │    │ (用户)   │              │
│  └──────────┘    └──────────┘    └──────────┘              │
│        ↑                               │                    │
│        │                               ↓                    │
│        │         ┌──────────────────────────────┐          │
│        │         │      Skill 创建流程          │          │
│        │         │  1. init_skill.py            │          │
│        │         │  2. 编写 SKILL.md            │          │
│        │         │  3. validate.sh              │          │
│        │         │  4. 更新 marketplace.json    │          │
│        │         │  5. 测试                      │          │
│        │         └──────────────────────────────┘          │
│        │                               │                    │
│        └───────────────────────────────┘                    │
│                    (循环)                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Session JSONL 数据结构

基于实际样本解析，session 文件结构（Phase 0.1 验证）：

**顶层消息类型**:

```jsonl
{"type": "queue-operation", "operation": "dequeue", "timestamp": "...", "sessionId": "..."}
{"type": "file-history-snapshot", "messageId": "...", "snapshot": {...}}
{"type": "user", "message": {"role": "user", "content": "..."}, "uuid": "...", "timestamp": "..."}
{"type": "assistant", "message": {"role": "assistant", "content": [...]}, "uuid": "...", "timestamp": "..."}
```

**嵌套内容类型** (在 `message.content` 数组中):

```json
{"type": "text", "text": "..."}
{"type": "tool_use", "id": "toolu_xxx", "name": "Read", "input": {...}}
{"type": "tool_result", "tool_use_id": "toolu_xxx", "content": "..."}
{"type": "thinking", "thinking": "...", "signature": "..."}
```

**关键字段**:

- 顶层 `type`: 消息类型 (queue-operation, file-history-snapshot, user, assistant)
- `message.content`: 数组形式，包含 text/tool_use/tool_result/thinking
- `tool_use.name`: 工具名称 (Read, Edit, Bash, Grep, Glob, etc.)
- `tool_use.input`: 工具参数
- `uuid`: 消息唯一标识
- `sessionId`: Session 标识
- `timestamp`: ISO 时间戳

---

## Session 摘要提取 Prompt

```markdown
## 任务
分析这个 Claude Code session，提取关键信息

## 输入
[Session JSONL 内容]

## 输出
1. **主题标签** (3-5 个):
   - 从内容推断任务类型（如：调试、重构、文档、测试...）
   - 识别技术栈（如：TypeScript、Python、React...）
   - 识别领域（如：前端、后端、DevOps...）

2. **工具序列**:
   - 列出主要 tool_use 的调用顺序
   - 识别是否有重复模式

3. **复杂度** (1-5):
   - 1: 单次问答
   - 2: 简单任务（<5 轮对话）
   - 3: 中等任务（5-15 轮）
   - 4: 复杂任务（15-30 轮）
   - 5: 超复杂（>30 轮或多文件修改）

4. **成功指标**:
   - true: 任务完成，无明显失败
   - false: 中途放弃或多次重试

5. **Skill 信号**:
   - 是否有可复用的工作流模式？
   - 如果有，用一句话描述
```

---

## Skill 候选输出模板

```markdown
## Skill 候选: [名称]

### 基本信息
- **频率**: 在 X 个 session 中出现
- **复杂度**: X/5
- **可复用性**: 高/中/低
- **组合性**: 可与 [现有 Skill] 组合
- **评分**: X.XX

### 触发场景
用户说: "[典型触发语句]"

### 核心工作流
1. [步骤 1]
2. [步骤 2]
3. ...

### 来源 Sessions
- session_id_1: [简要描述]
- session_id_2: [简要描述]

### 与现有 Skill 的关系
- 独立 / 补充 / 组合

### 用户决策
- [ ] 确认实现
- [ ] 修改后实现
- [ ] 不实现
```

---

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Session 数据量大，分析耗时 | 分批 + Subagent 并行 |
| 主题聚类可能不准确 | 用户 Review 每个阶段的输出 |
| Skill 粒度不当（太大或太小） | 参考现有 Skill 的粒度 |
| 评分公式可能需要调整 | 第一轮后根据用户反馈迭代 |

---

## Open Questions

1. **Session 时间范围**: 是否只分析最近 3 个月？还是全量？
   - 建议：先分析最近，发现价值后再扩展

2. **聚类数量**: 目标多少个主题簇？
   - 建议：每个项目 10-15 个，合并后 20-30 个

3. **Meta-skill**: 「Skill Discovery」本身要不要做成 Skill？
   - 待本次实践后决定

---

## 参考资源

- [Claude Skills Documentation](https://code.claude.com/docs/en/skills)
- [Compound Engineering (Every)](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- [DuckDB Claude Code Log Analysis](https://liambx.com/blog/claude-code-log-analysis-with-duckdb)
- [claude-code-analytics](https://github.com/sujankapadia/claude-code-analytics)
