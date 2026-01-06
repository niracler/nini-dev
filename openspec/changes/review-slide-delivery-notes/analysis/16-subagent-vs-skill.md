# 页 16：Subagent vs Skill — Context 管理的两种策略（🔴 重点 💻 演示）

## 页面内容摘要

```text
# Subagent vs Skill — Context 管理的两种策略
🔴 重点 💻 演示

左栏：Subagent = 分离出去，独立执行
- 主 Agent 200K context
- Explore / Plan 子进程：独立 context，Haiku 驱动
- 只返回摘要
- ✅ 优势：不污染主 context · 可并行 10 个 · 失败隔离
- 内置：Explore · Plan · Code Review · Test Runner

右栏：Skill = 注入进来，按需加载
- 同一 Context，渐进式加载
- 1️⃣ 元数据 ~100 tokens
- 2️⃣ 匹配后加载指令 <5K tokens
- 3️⃣ 需要时加载资源/模板
- ✅ 优势：继承上下文 · 无启动开销 · 可组合
- 内置：/commit · /review-pr · /init
```

## 6 问分析

### 1. 如何讲

- **时长**：~4 分钟
- **节奏**：先画对比图，再逐个讲解，最后现场演示两种策略
- **过渡语**：
  - 开场：「MCP 解决了工具连接问题。但 Agent 运行时间长了，Context 会满。怎么办？两种策略」
  - 结束：「这两种策略帮我们管理 Context。但它的生命周期是怎样的？下一页看完整流程」
- **核心记忆点**：**Subagent = 隔离执行（防污染）；Skill = 按需注入（省空间）**

### 2. 为何要懂

- **重要程度**：🔴 必须懂
- **价值**：理解 Claude Code 的核心架构设计，知道何时用 Subagent、何时用 Skill
- **与听众关联**：日常使用 Claude Code 时，Explore、Plan 都是 Subagent；/commit、git-workflow 是 Skill

### 3. 演示策略

- **需要演示**：是（强烈推荐，演示两种策略的对比）

**演示 1：Subagent（Explore）**

```
帮我探索这个项目的架构
```

- 让听众看到 Explore 子进程被触发
- 强调「它有自己的 Context，用完就释放」
- 结果返回时只是摘要，不会污染主 Context

**演示 2：Skill（git-workflow）**

```
帮我提交代码
```

或直接输入 `/git-workflow`

- 让听众看到指令被注入到当前 Context
- 强调「没有启动新进程，就在主 Context 里执行」
- 它能继承之前的对话上下文

- **时长**：各 30 秒，共 ~1 分钟
- **演示时口述**：
  > 「刚才 Explore 是 Subagent——分离出去执行，用完释放。现在看 Skill——我说『帮我提交代码』，它会注入 git-workflow 的指令到当前 Context，然后按步骤执行。注意它没有启动新进程，就在主 Context 里完成。」

### 4. 可能问题

| 问题 | 准备的回答 |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Subagent 和 Skill 怎么选？ | 看任务规模。探索整个代码库、做 Code Review → Subagent（需要独立空间）；创建 PR、生成 Commit → Skill（步骤明确，按需注入） |
| Subagent 用的是什么模型？ | 默认 Haiku（快且便宜），复杂任务可以指定 Sonnet。主 Agent 通常用 Opus/Sonnet |
| 为什么不都用 Subagent？ | Subagent 有启动开销，而且失去主 Context 的上下文。简单任务用 Skill 更高效 |
| Skill 会不会把 Context 撑爆？ | 渐进式加载设计——先加载元数据（~100 tokens），匹配后加载指令（<5K tokens），需要时才加载资源 |
| 我能自己写 Skill 吗？ | 能。Skill 本质是 Markdown 格式的 Prompt + 触发规则。放在 .claude/skills/ 目录即可 |
| git-workflow 做了什么？ | 遵循 conventional commits 规范，自动分析变更、生成 commit message、创建 PR。我自己日常用它来发布版本 |

### 5. 取舍逻辑

| 没讲的内容 | 取舍理由 |
| ----------------------- | --------------- |
| Skill 的 YAML 配置语法 | 📚 开发时查文档 |
| Subagent 的内部通信机制 | 📚 太底层 |
| 多 Subagent 协调 | ⏱️ 进阶话题 |

### 6. 观点/事实区分

| 内容 | 类型 | 来源 |
| --------------------------------------- | ---- | ---------------- |
| Subagent 用 Haiku 驱动 | 事实 | Claude Code 架构 |
| 可并行 10 个 Subagent | 事实 | Claude Code 文档 |
| Skill 渐进式加载 ~100 → <5K tokens | 事实 | Claude Code 设计 |
| 内置 Subagent：Explore/Plan/Code Review | 事实 | Claude Code 功能 |

## 演示备忘

**演示顺序**：

1. 先演示 Subagent：「帮我探索这个项目的架构」
   - 指出 Explore 进程启动
   - 等待返回摘要结果
2. 再演示 Skill：「帮我提交代码」或 `/git-workflow`
   - 指出指令注入到当前 Context
   - 展示它继承了之前的对话

**对比口述**：

> 「注意两者的区别——Subagent 是『派出去干活，带结果回来』；Skill 是『把专家请进来，在这里干活』。前者隔离但失去上下文，后者共享但占用空间。根据任务选择。」

**个人案例**：

> 「我自己用 git-workflow 来发布 Home Assistant 的代码。说『帮我提交代码』，它就按 conventional commits 规范生成 commit message，然后创建 PR。整个过程在一个 Context 里完成。」
