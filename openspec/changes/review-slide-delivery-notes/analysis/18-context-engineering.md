# 页 18：Context Engineering — 现代 AI 编程的核心技能（🔴 重点）

## 页面内容摘要

```text
# Context Engineering — 现代 AI 编程的核心技能
🔴 重点

左栏：比喻引入
- 想象你请了一位行业顾问，TA 能力很强，但只能待一天，而且对你公司一无所知
- 映射：
  - 只能待一天 → Context Window 有限
  - 不知道你公司 → 每次对话都是无状态
  - 你的任务 → 给 TA 最相关的资料
- ⚠️ Context Rot：给错资料反而害 TA — 有效 context < 256K
  - 「大多数 Agent 失败是 Context 失败」— Anthropic

右栏：四大解决策略
1. 📝 Write — 给顾问一个笔记本（Scratchpads、长期记忆、Todo 列表）
2. 🔍 Select — 只拿最相关的文档（CLAUDE.md、RAG、@codebase）
3. 🗜️ Compress — 100 页压成 3 页摘要（Auto-compact、/compact）
4. 🔀 Isolate — 让 TA 带助手分头调研（Subagent、并行执行）

脚注：
- Anthropic "Effective context engineering" — 「找到最小的高信号 Token 集合」
- Karpathy on X — 「Context Engineering 是填充 context window 的精妙艺术与科学」
- ESR "How To Ask Questions The Smart Way" — 前 AI 时代的经典：向社区提问要给足 context
```

## 6 问分析

### 1. 如何讲

- **时长**：~4 分钟
- **节奏**：先用「行业顾问」比喻建立共鸣 → 逐步展开四大策略 → 强调「不是塞越多越好」
- **过渡语**：
  - 开场：「理解了 Context 生命周期，现在看如何主动管理它——这叫 Context Engineering」
  - 结束：「这四大策略是理论框架。下一页看具体怎么写 Prompt」
- **核心记忆点**：**Context Engineering = 给 AI 塞对的东西，而不是塞越多越好**

### 2. 为何要懂

- **重要程度**：🔴 必须懂
- **价值**：这是 2025 年 AI 编程最热门的概念之一。Karpathy 和 Anthropic 都在强调
- **与听众关联**：
  - 理解为什么「说清楚需求」比「多说几遍」更有效
  - 四大策略是日常使用 Claude Code 的指导框架
  - **IoT 场景**：如果要让 AI 控制设备，Select 策略决定给它哪些设备状态、哪些操作权限

### 3. 演示策略

- **需要演示**：否（概念框架页）
- **替代策略**：口述时回顾之前的演示
  - 「刚才演示的 Explore、/compact，就是 Isolate 和 Compress 策略」
  - 「后面 CLAUDE.md 那页会展示 Select 策略」

### 4. 可能问题

| 问题 | 准备的回答 |
| ---------------------------- | --------------------------------------------------------------------------------------- |
| Context Rot 是什么？ | Context 太多反而降低质量。研究表明有效 context < 256K，塞太多让 AI 迷失方向 |
| 「顾问」比喻太抽象？ | 想想你自己——如果有人给你一大堆不相关的文档，你也会懵。AI 也一样 |
| 四个策略有优先级吗？ | Select（选对的）最重要。然后是 Write（让它记录）和 Compress（压缩）。Isolate 是进阶技巧 |
| CLAUDE.md 是什么？ | 项目级别的配置文件，告诉 AI「这个项目用什么技术栈、有什么约定」。后面那页会讲 |
| 为什么说「不是塞越多越好」？ | Anthropic 的研究：context 越多，准确率反而可能下降。要找「最小的高信号 Token 集合」 |

### 5. 取舍逻辑

| 没讲的内容 | 取舍理由 |
| ------------------ | -------------------------- |
| 每个策略的详细实现 | 下一页「实操」会讲具体例子 |
| RAG 的技术细节 | 📚 前面 RAG 那页已讲过原理 |
| Subagent 详细机制 | 📚 前面那页已讲过 |

### 6. 观点/事实区分

| 内容 | 类型 | 来源 |
| ------------------------------------ | -------- | ------------------------------ |
| Context Engineering 是核心技能 | 共识观点 | Anthropic、Karpathy 等多方强调 |
| 有效 context < 256K | 事实 | Anthropic 工程博客 |
| 「大多数 Agent 失败是 Context 失败」 | 事实 | Anthropic 官方声明 |
| 四大策略框架 | 整理归纳 | 根据最佳实践整理 |

## 演示备忘

**本页不需要单独演示**，但口述时串联之前的演示：

> 「刚才演示的 Explore 是 Isolate 策略——分离出去执行。/compact 是 Compress 策略——压缩历史。后面 CLAUDE.md 会展示 Select 策略——告诉 AI 项目的关键信息。」

**口述重点**：

> 「记住这个比喻——AI 就像一个能力很强但对你公司一无所知的顾问。你的任务不是给它所有文档，而是给它最相关的资料。这就是 Context Engineering 的核心。」

**Karpathy 金句**（可选引用）：

> 「Context Engineering 是填充 context window 的精妙艺术与科学」

**ESR「提问的智慧」类比**（可选引用）：

> 「前 AI 时代有一个经典——ESR 的『How To Ask Questions The Smart Way』。那时候在社区提问如果没给足 context，会被 AT 回这条置顶链接羞耻一下。向 LLM 协作其实同理——没给足精准的 context，就是在犯一样的问题。」

**Meta 用法**（可选延伸）：

> 「不过这个年代有个好处——你可以让 LLM 按照『提问的智慧』里的原则，帮你检查自己的提问是否及格、是否需要补充更多信息。用 AI 来帮你更好地和 AI 协作。」
