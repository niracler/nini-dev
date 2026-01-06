# Change: Discover Skills from Claude Code Sessions

## Why

> *"Context Engineering 没死，它只是被解决了。下一个问题是 Compound Engineering —— 每个任务都有可学习的结构，把它捕获成 Skill，下次就不用人做了。"*

你有 **3,700+ 个 Claude Code sessions** 分布在 22 个项目中，这些对话记录是未被挖掘的金矿：

1. **重复工作流隐藏在历史中** — 相似的任务反复出现，但没有被识别和封装
2. **成功模式未被复用** — 好的解决方案完成后就消失在历史里
3. **Compound Engineering 的入口** — 要实现 Skill 复利，首先需要系统性地发现 Skill 候选

### 数据规模

| 项目 | Sessions | 优先级 |
|------|----------|--------|
| nini-dev | 1,382 | 🔴 Phase 1 |
| azoulalite-dev | 1,088 | 🔴 Phase 1 |
| ha-dev | 546 | 🔴 Phase 1 |
| Obsidian notes | 178 | 🟡 Phase 6 |
| 其他 18 个项目 | ~500 | 🟡 Phase 6 |
| **总计** | **~3,700** | |

## What Changes

### 新增 Spec: skill-discovery

新增 `skill-discovery` 能力规范，包含 4 个核心 Requirements：

1. **Session 分析能力** — 解析 JSONL，提取主题/工具序列/复杂度/成功指标
2. **主题聚类能力** — LLM 语义聚类，识别重复工作模式
3. **Skill 候选识别** — 评分排序，与现有 Skill 对比
4. **Skill 创建循环集成** — 触发 `init_skill.py` 完成闭环

### 工作模式

采用 **「分批 + Subagent 并行 + 用户 Review」** 的渐进式流程：

```
Phase 1-4: 深度分析 Top 3 项目 (3,000+ sessions)
           ├── 每批次 3 个 Subagent 并行
           ├── 每项目输出 10-15 个主题簇
           └── 用户 Review 确认候选

Phase 5:   Skill 创建循环 (Top 5 候选)
           ├── init_skill.py 创建骨架
           ├── 编写 SKILL.md
           ├── validate.sh 验证
           └── 更新 marketplace.json

Phase 6:   补充项目快速扫描 (可选)

Phase 7:   元反思 — skill-discovery 本身能否成为 Skill？
```

### 预期产出

- **Skill 候选清单**: 10-20 个高价值候选，按评分排序
- **Top 5 Skill**: 完整实现并注册到 marketplace
- **组合机会**: 识别与现有 5 个 Skill 的组合点
- **（可能）Meta-skill**: `skill-discovery` 工作流本身

### 评分公式

```
Score = 0.3×Frequency + 0.25×Complexity + 0.25×Reusability + 0.2×Composability
```

## Impact

- **Affected specs**: 新增 `skill-discovery` capability
- **Affected code**: `repos/skill/src/` 新增 5+ Skill
- **工作量**: Apply 阶段需要多轮对话，预计 7 个 Phase

## 参考

- [Compound Engineering (Every)](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- [Boris Cherny - 代码审查变知识捕获](https://x.com/bcherny/status/2007179842928947333)
- [Nikunj Kothari - Claude 发现 12 个重复任务](https://x.com/nikunj/status/2007543585630200220)
- [Software Ate the World, Skills Will Eat Work](https://x.com/JefferyTatsuya/status/2005081909177844037)
