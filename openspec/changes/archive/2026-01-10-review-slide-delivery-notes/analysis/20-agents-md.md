# 页 20：AGENTS.md：项目记忆（🔴 重点）

## 页面内容摘要

```text
# AGENTS.md：项目记忆
🔴 重点

左栏：有 vs 没有的对比
- ❌ 没有：每次都要解释项目是什么、用什么语言、怎么跑测试 → 重新解释
- ✅ 有：直接开始，风格一致

WHAT/WHY/HOW 框架：
- WHAT：项目是什么、技术栈、目录结构
- WHY：项目目标、各模块作用
- HOW：开发流程、测试、提交规范
- 📏 指令容量有限：LLM ~150 条 / Claude Code 自带 ~50 条

右栏：示例（60 行以内）
- Commands: npm run build/test
- Code Style: ES modules, 2-space indentation
- Workflow: Typecheck after changes

关键原则：
- ❌ 别当 Linter — 交给 ESLint/Ruff
- ✋ 手动编写 — 别用 /init

本质：System Prompt 的一部分 — 每次对话自动注入，是 Context Engineering 的落地

脚注：
- HumanLayer "Writing a Good CLAUDE.md" — WHAT/WHY/HOW 框架
- Anthropic "Claude Code Best Practices" — 官方推荐
```

## 6 问分析

### 1. 如何讲

- **时长**：~3 分钟
- **节奏**：先对比「有 vs 没有」的差异 → 介绍 WHAT/WHY/HOW 框架 → 展示示例 → 强调「手动编写」
- **过渡语**：
  - 开场：「刚才讲了具体 Prompt 的重要性。但每次都写那么详细？有没有『一劳永逸』的方法？有——AGENTS.md」
  - 结束：「AGENTS.md 是项目级别的 Context。下一页看更高级的工作流——OpenSpec」
- **核心记忆点**：**AGENTS.md = 项目记忆，每次对话自动注入**

### 2. 为何要懂

- **重要程度**：🔴 必须懂
- **价值**：这是 Claude Code 最重要的配置文件，决定了 AI 是否「懂」你的项目
- **与听众关联**：
  - 不用每次都解释「这是 Python 项目、用 pytest 测试、遵循 Conventional Commits」
  - 60 行以内就能显著提升 AI 的表现
  - **IoT 场景**：可以写「这是 Home Assistant 集成项目，用 Python，测试命令是 pytest」

### 3. 演示策略

- **需要演示**：可选（展示自己的 CLAUDE.md）
- **演示方式**：打开当前项目的 CLAUDE.md，展示结构
- **演示要点**：
  - 让听众看到真实的 CLAUDE.md 长什么样
  - 强调「60 行以内」的简洁性
- **时长**：~20 秒
- **备注**：如果跳过，口述时强调「我自己的项目都有这个文件」

### 4. 可能问题

| 问题 | 准备的回答 |
| ----------------------------------- | ------------------------------------------------------------------------------------------------ |
| AGENTS.md 和 CLAUDE.md 有什么区别？ | 一样的东西。CLAUDE.md 是 Claude Code 专用；AGENTS.md 是通用名称，其他工具也能用 |
| 为什么不用 /init 自动生成？ | 自动生成的往往太泛，没有你项目的特色。手动写才能精准描述你的约定 |
| 指令太多会怎样？ | 研究表明 LLM 可靠遵循 ~150 条指令。Claude Code 自带 ~50 条，你还有 ~100 条的空间。超过了会被忽略 |
| 放在哪里？ | 项目根目录。Claude Code 启动时自动读取 |
| 多个项目怎么办？ | 每个项目各自一个 CLAUDE.md。Claude Code 只读当前目录的 |

### 5. 取舍逻辑

| 没讲的内容 | 取舍理由 |
| ---------------------- | ------------------- |
| .claude/settings.json | 📚 进阶配置，查文档 |
| 多层级 CLAUDE.md | 📚 进阶话题 |
| 与 .cursorrules 的对比 | ⏱️ 离题 |

### 6. 观点/事实区分

| 内容 | 类型 | 来源 |
| ------------------------ | -------- | --------------------------- |
| LLM 可靠遵循 ~150 条指令 | 事实 | HumanLayer 博客引用的研究 |
| WHAT/WHY/HOW 框架 | 最佳实践 | HumanLayer 博客 |
| 建议 60 行以内 | 最佳实践 | Anthropic 官方 + HumanLayer |
| 别当 Linter | 最佳实践 | 社区共识 |

## 演示备忘

**演示方式**（可选）：

```bash
cat CLAUDE.md
```

**口述重点**：

> 「AGENTS.md 就是项目记忆——技术栈、测试命令、提交规范。Claude Code 每次启动都会读取。写一次，后面的对话都自动继承。」

**强调手动编写**：

> 「有人会问能不能自动生成。我的建议是手动写。自动生成的太泛，没有你项目的特色。60 行以内，写一次，受益终身。」
