# 页 21：从提案到 Skill：OpenSpec 工作流（🔴 重点 💻 演示）

## 页面内容摘要

```text
# 从提案到 Skill：OpenSpec 工作流
🔴 重点 💻 演示

Spec-Driven Development — 意图先行，代码随后

流程图（四阶段）：
1. 📋 Proposal — proposal.md (Why & What), design.md (技术决策), tasks.md (实施清单)
   触发：/openspec:proposal
2. ⟳ Review & Apply — refine specs & tasks, feedback loop, 直到达成一致
   触发：/openspec:apply
3. 📦 Archive — 合并到 specs/, 移入 archive/, 成为「正式文档」
   触发：/openspec:archive
4. 🎯 Skill 升华 — 提炼通用模式, 模型自动调用, 跨项目复用
   结构：SKILL.md + 脚本

三列说明：
- 为什么用 Spec-Driven？意图先行、可审计、可迭代、减少幻觉
- 目录结构：openspec/ → changes/, specs/, archive/
- 何时提炼成 Skill？信号：同样的 prompt 打了 3+ 次

脚注：
- Thoughtworks "Spec-Driven Development" — 2025 年 AI 辅助工程新实践
- Anthropic "Agent Skills" — 重复 prompt 就该提炼成 Skill
- OpenSpec — Spec-Driven Development 工作流工具
```

## 6 问分析

### 1. 如何讲

- **时长**：~4 分钟
- **节奏**：跟着 v-click 动画逐步展开四个阶段 → 停在「Skill 升华」强调「自动调用」
- **过渡语**：
  - 开场：「刚才讲了 AGENTS.md——那是项目记忆。现在看一个更系统的工作流——OpenSpec。它把『意图』变成可追溯的规范」
  - 结束：「OpenSpec 是 Part 1 的收尾——从工具介绍、能力边界、到工作流。Part 2 我们看知识路线图」
- **核心记忆点**：**Skill = SOP——把踩过的坑固化成规范，让 LLM 每次都能正确执行**

### 2. 为何要懂

- **重要程度**：🔴 必须懂
- **价值**：这是把「用 AI 编程」从随意对话升级为工程实践的关键方法论
- **与听众关联**：
  - 项目越大越需要可审计的决策记录
  - 「打了 3+ 次同样的 prompt」——每个人都有这个经历
  - **IoT 场景**：设备固件升级流程、测试规范，都可以用 Spec-Driven 管理

**观点逆转——SOP 在 Vibe Engineering 时代的必然性**：

顶级软件工程实践中的各种 SOP：「100% 测试覆盖率」「语义化类型名称」「代码风格统一」「MAX Linter」「静态类型检查」「PRD/设计文档/TDD」「持续集成/部署」。

> 以前总感觉这些对于小团队的需求有「大炮打小蚊子」的嫌疑。前司 BOSS 说这些不过是「自欺欺人的减慢速度的玩意」。但在**给 LLM 擦了一年的屁股后**，这个观点逆转了。

**以前人很难遵守 SOP 的原因**：

- Deadline 一紧，代码风格就先放一放
- Review 一忙，测试覆盖就睁一只眼闭一只眼
- 这个项目的实现方案很可能下个月就会弃用了，用半个月来探索「如何正确地搭建项目」不是浪费时间吗？
- 更别提各种 CICD 的 WorkFlow 校验和严格 TDD、PRD 了
- MAX Linter 更是让人痛苦得没脾气

**但现在再不定好这些 SOP，你可能会得到**：

- 每一轮提问都是全新的代码风格
- 充满 debug 遗留下来的 log 语句
- 每一轮都要不断强调的设计思路
- 一不小心写出来的 shit 被无限放大
- 实际上不能 work 的代码
- 以及完全没有必要的冗余流程

**核心转变**：

- 以前小团队靠「默契」「脑子里的规矩」就够了，但 LLM 不吃这套
- 如果你不把规范写下来，你就要无限重复
- SOP 变得必要——不是为了「流程正规化」，而是为了让 LLM 每次都能正确地工作
- 也为了在代码量暴增时减轻 review 负担（与 HA 的超繁琐 PR 流程达成和解）

**Skill 本质上就是 SOP**——把踩过的坑固化成规范，让下次不用再踩。只不过以前 SOP 是给人看的，现在是给 LLM 执行的。

Simon Willison 在 [Vibe Engineering](https://simonwillison.net/2025/Oct/7/vibe-engineering/) 中提到：

> 「**顶级工程实践在 LLM 时代会获得更大的回报** (LLMs actively reward existing top tier software engineering practices)」

**Meta 演示价值**：这份演讲本身就是用 OpenSpec 管理的——可以现场展示 `openspec/` 目录结构，说明「我说的我自己在用」

### 3. 演示策略

- **需要演示**：是（强烈推荐 Meta 演示）
- **演示方式**：展示当前项目的 `openspec/` 目录
- **演示指令**：

```bash
ls -la openspec/
ls -la openspec/changes/
```

- **演示要点**：
  - 展示 `changes/`、`specs/`、`archive/` 三个目录
  - 指出「这份演讲的 speaker notes 就是在 `changes/review-slide-delivery-notes/` 里管理的」
  - 强调「我说的我自己在用」的可信度
- **时长**：~30 秒
- **备用**：如果跳过演示，口述「这份演讲本身就是用 OpenSpec 管理的」

### 4. 可能问题

| 问题 | 准备的回答 |
| ------------------------------- | -------------------------------------------------------------------------------------------------------- |
| 这和 Git 分支有什么区别？ | Git 管代码，OpenSpec 管意图。Proposal 记录的是「为什么要改」「要达成什么效果」，比 commit message 更完整 |
| 为什么要这么复杂？ | 小项目可以简化。但当项目变大、团队变多，可追溯的决策记录就变得很有价值。而且 LLM 时代这些规范反而更必要 |
| Skill 和 AGENTS.md 有什么区别？ | AGENTS.md 是静态配置——项目的约定。Skill 是可执行的——检测到特定任务会自动触发 |
| Skill 怎么触发的？ | 模型根据任务描述匹配 Skill 的触发条件。比如你说「帮我提交」，它会匹配 git-workflow skill |
| 我可以直接用 OpenSpec 吗？ | 可以。它是开源的 CLI 工具。但核心理念——Spec-Driven——即使不用工具也能实践 |
| 以前觉得 SOP 太重怎么办？ | 观点要逆转。以前靠默契就够，现在 LLM 不吃这套。不写下来就要无限重复。顶级工程实践在 LLM 时代回报更大 |

### 5. 取舍逻辑

| 没讲的内容 | 取舍理由 |
| ---------------------- | ------------------- |
| proposal.md 的详细格式 | 📚 进阶话题，看文档 |
| Skill 的编写语法 | 📚 进阶话题，看文档 |
| 与其他工作流工具对比 | ⏱️ 离题 |
| Archive 的具体命令 | 📚 次要细节 |

### 6. 观点/事实区分

| 内容 | 类型 | 来源 |
| -------------------------------------- | -------- | --------------------------------- |
| Spec-Driven Development 是 2025 新实践 | 事实 | Thoughtworks 博客 |
| 「同样 prompt 打 3+ 次就提炼成 Skill」 | 最佳实践 | Anthropic 官方建议 |
| OpenSpec 四阶段流程 | 工具设计 | OpenSpec 项目 |
| Skill 自动匹配触发 | 事实 | Claude Code 行为 |
| 「顶级工程实践在 LLM 时代回报更大」 | 观点 | Simon Willison (Vibe Engineering) |
| Skill = SOP | 洞察 | 个人总结 |

## 演示备忘

**正式演示**：

```bash
ls -la openspec/
ls -la openspec/changes/
```

**演示时口述**：

> 「这份演讲本身就是用 OpenSpec 管理的。你们看——`changes/` 目录下有正在进行的变更，`specs/` 是正式规范，`archive/` 是已完成的变更。每个变更都有 proposal.md 记录为什么要改、tasks.md 记录要做什么。」

**Meta 亮点**：

> 「我讲 OpenSpec，用的就是 OpenSpec。这份 speaker notes 的分析，现在就在 `changes/review-slide-delivery-notes/` 里。『说到做到』——这是最好的说服力。」

**Skill = SOP 洞察**（核心观点）：

> 「Skill 是什么？本质上就是传统的 SOP——把踩过的坑固化成规范。只不过以前 SOP 是给人看的，现在是给 LLM 执行的。而且 LLM 比人更老实——你写什么它就照做，不会『差不多得了』。」

**观点逆转**（打破旧见）：

> 「以前小团队总觉得各种规范流程太重——『大炮打蚊子』。但给 LLM 擦了一年屁股后，我发现这个观点要逆转了。LLM 不吃『默契』那一套。你不写下来，就要无限重复。正如 Simon Willison 说的：『顶级工程实践在 LLM 时代会获得更大的回报』。」

**Skill 升华强调**：

> 「最后一步是 Skill 升华。当你发现同样的 prompt 打了三次以上，就该提炼成 Skill。比如我的 `git-workflow` Skill——现在每次提交代码，模型自动按 conventional commits 格式来，不用我每次提醒。」
