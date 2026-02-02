# Tasks: Slidev 内容精修重构

> **核心约束：单页单任务** — 每次 apply 只处理一页 PPT，完成后等待用户确认才能继续下一页。

## 1. 准备工作

- [x] 1.1 确认 design.md 精修流程
- [x] 1.2 启动 Slidev dev server

## 2. 封面：AI 编程分享

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿
- [x] Step D: 展示优化
- [x] Step E: Playwright 截图 + 用户 Review
- [x] Step F: 同步文稿 + 标注 ✅ 保持现状

## 3. 为什么做这个分享？

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿
- [x] Step D: 展示优化
- [x] Step E: Playwright 截图 + 用户 Review
- [x] Step F: 同步文稿 + 标注 ✅ 保持现状

## 4. 今天的旅程（合并原 4-5 页：路线图 + 声明）

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿（彩色徽章 + 表格）
- [x] Step D: 展示优化
- [x] Step E: Playwright 截图 + 用户 Review
- [x] Step F: 同步文稿 + 标注 ✅ 完成

> ✅ 已合并：37 → 36 页

## 5. Section: Part 2

- [x] Step A-E: Section 页快速 Review
- [x] Step F: 添加 ⏩ 快速带过标注 ✅

## 6. GPT-3 发布（合并原 7-9 页：GPT-3 + 核心概念 + 文本补全）

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿（Mermaid 流程图 + 概念卡片 + 限制列表）
- [x] Step D: 展示优化（Mermaid 居中、全局样式）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

> ✅ 已合并：36 → 35 页

## 7. Token 与 Context Window（合并原 10-11 页：Token 体感 + 模型价格 + Context 概念）

- [x] Step A: 研究准备（Jay Alammar 可视化、Context Window 概念）
- [x] Step B: 构思叙事（Token + Context 两个核心概念并列）
- [x] Step C: 设计初稿（Token 刻度尺 + GPT-3 文本补全可视化）
- [x] Step D: 展示优化（Prompt→Completion 配色、增加留白）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

> ✅ 页面重构：Token + 价格 + Context Window 三合一，为后续 Context 生命周期做铺垫

## 12+13. 2021.6: GitHub Copilot（合并原 12-13 页）

- [x] Step A: 研究准备（GitHub Copilot 发布历史、Codex、HumanEval）
- [x] Step B: 构思叙事（微调 = 对焦，0% → 28.8%）
- [x] Step C: 设计初稿（two-cols 布局，左代码右卡片）
- [x] Step D: 展示优化（添加 HumanEval 数据、缩小右侧文字）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 ✅ 完成

> ✅ 已合并：35 → 34 页（GitHub Copilot + 注释驱动补全 合为一页）

## 14+15. ChatGPT + 幻觉（合并）

- [x] Step A: 研究准备（RLHF 与幻觉的因果关系）
- [x] Step B: 构思叙事（RLHF before/after + 幻觉不可避免）
- [x] Step C: 设计初稿（two-cols 布局，6 个 v-click）
- [x] Step D: 展示优化（详细脚注、重点调整）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 ⏩ 快速带过

> ✅ 已合并：34 → 33 页（ChatGPT + 幻觉 合为一页）

## 16. 2023.3: GPT-4

- [x] Step A: 研究准备（Technical Report、幻觉 ↓40%、Context 8K→32K）
- [x] Step B: 构思叙事（质变而非渐进）
- [x] Step C: 设计初稿（two-cols 布局，7 个 v-click）
- [x] Step D: 展示优化（增加 Technical Report 注释、右侧表格延迟展示）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 ⏩ 快速带过

## 17. Function Call

- [x] Step A: 研究准备（布局参考、antfu talks）
- [x] Step B: 构思叙事（从「回答」到「执行」）
- [x] Step C: 设计初稿（2:3 布局，左步骤+JSON，右 Mermaid）
- [x] Step D: 展示优化（v-click ≤2，Mermaid 位置调整）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

## 18. RAG

- [x] Step A: 研究准备（baoyu.io RAG 架构图参考）
- [x] Step B: 构思叙事（索引阶段 vs 查询阶段）
- [x] Step C: 设计初稿（subgraph 流程图，双阶段布局）
- [x] Step D: 展示优化（参考 Naive RAG 经典图重构）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 ⏩ 快速带过

## 19. 思维链（原推理模型）

- [x] Step A: 研究准备（Google CoT 论文、涌现能力、System 1/2 类比）
- [x] Step B: 构思叙事（为什么 CoT 有效：注意力聚焦、工作记忆、可纠错）
- [x] Step C: 设计初稿（two-cols 布局，左 CoT+为什么有效，右 AIME+DeepSeek）
- [x] Step D: 展示优化（v-click 顺序：先左后右、先上后下）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注（无标注）

## 20. Agent：从「回答」到「执行」

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿
- [x] Step D: 展示优化
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 ✅ 保持现状

## 21. AI 编程工具：三代范式

- [x] Step A: 研究准备（AI 编程工具对比、三代范式演进）
- [x] Step B: 构思叙事（补全 → 对话 → 自主 范式转变）
- [x] Step C: 设计初稿（三卡片 + 对比表格 + 范式总结）
- [x] Step D: 展示优化（卡片压缩、表格无表头、脚注详细化）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 💻 演示

## 22. MCP（融入 MCP 工具安利）

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿
- [x] Step D: 展示优化
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点 💻 演示

## 23. Subagent vs Skill（融入 Skill 安利）

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿
- [x] Step D: 展示优化
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点 💻 演示

## 24. Context Window 的生命周期

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿（v-click 从 10 精简到 6）
- [x] Step D: 展示优化（添加 🔴 重点标签、脚注详细化）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

## 25. Context Engineering

- [x] Step A: 研究准备（Karpathy 定义、Anthropic 原则、Tobi Lutke 观点）
- [x] Step B: 构思叙事（行业顾问类比 + 四大策略）
- [x] Step C: 设计初稿（two-cols 布局，v-click 从 7 精简到 3）
- [x] Step D: 展示优化（添加 🔴 重点标签、脚注详细化）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

> ✅ 页面重组：将原 Part 4 的 Context Engineering 实操 + CLAUDE.md + 工具链全景 移到 Part 2

## 25a. Context Engineering 实操（从 Part 4 移入，页码 19）

- [x] Step A: 研究准备
- [x] Step B: 构思叙事
- [x] Step C: 设计初稿（两栏对话对比 + 底部双卡片）
- [x] Step D: 展示优化（v-click 从 11 精简到 5）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

## 25b. CLAUDE.md：项目记忆（从 Part 4 移入，页码 20）

- [x] Step A: 研究准备（HumanLayer WHAT/WHY/HOW、Anthropic Best Practices、Memory Hierarchy）
- [x] Step B: 构思叙事（项目记忆 = System Prompt 的一部分）
- [x] Step C: 设计初稿（左对比+框架，右代码示例+关键原则）
- [x] Step D: 展示优化（v-click 从 6 精简到 3，两列顶部对齐）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 同步文稿 + 标注 🔴 重点

## 25c. 从提案到 Skill：OpenSpec 工作流（替代原「工具链全景」+ Task 40「Best Practice」）

- [x] Step A: 研究准备（OpenSpec AGENTS.md、Thoughtworks SDD、Anthropic Skills、Martin Fowler SDD 工具对比）
- [x] Step B: 构思叙事（强调「意图先行」+ 精华归档可转化为 Skill 复用）
- [x] Step C: 设计初稿（四阶段流程图 + 三列说明：为什么/目录结构/Skill 升华）
- [x] Step D: 展示优化（扩大卡片、添加 slash command、目录结构代码块）
- [x] Step E: Playwright 截图 + 用户 Review ✅（修复对比度：opacity-70→90、amber-400、gray-300）
- [x] Step F: 同步文稿 + 标注 🔴 重点 💻 演示

> ✅ 合并：原 Task 25c「工具链全景」+ Task 40「Best Practice 页」→ 聚焦 OpenSpec 工作流

## 26. Part 2 知识路线图

- [x] Step A: 研究准备（知识路线图布局最佳实践、40-60规则）
- [x] Step B: 构思叙事（概览页，⏩ 快速带过类型）
- [x] Step C: 设计初稿（保持四列布局，添加页面类型标注）
- [x] Step D: 展示优化（修复对比度：opacity-70→90、opacity-60→80）
- [x] Step E: Playwright 截图 + 用户 Review ✅（添加脚注 ⭐ 推荐标记）
- [x] Step F: 同步文稿 + 标注 ⏩ 快速带过

## 27. Section: Part 3

- [x] Step A-D: Section 页极简设计，添加页面类型标注
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 标注 ⏩ 快速带过

## 28. Home Assistant 项目：三个阶段

- [x] Step A: 研究准备（学习进程可视化最佳实践）
- [x] Step B: 构思叙事（三阶段渐进布局，颜色渐变暗示成长）
- [x] Step C: 设计初稿（添加页面类型标注）
- [x] Step D: 展示优化（修复对比度：opacity-60→80、opacity-70→90）
- [x] Step E: Playwright 截图 + 用户 Review ✅（页面类型改为 ⏩，脚注不加 ⭐）
- [x] Step F: 标注 ⏩ 快速带过

## 29+30. 那么，代价是什么？（合并原 PR 重构反思 + 教训总结）

- [x] Step A: 研究准备（slide consolidation best practices、before/after comparison design）
- [x] Step B: 构思叙事（聚焦「代价与反思」，McKinsey 两栏布局）
- [x] Step C: 设计初稿（左：数据证据 PR 截图+统计；右：核心洞察+三大副作用）
- [x] Step D: 展示优化（添加「但也不绝对」平衡卡片，修改标题为「那么，代价是什么？」）
- [x] Step E: Playwright 截图 + 用户 Review ✅（页面 25/32）
- [x] Step F: 同步文稿 + 标注 🔴 重点

> ✅ 合并：原 Task 29「PR 重构反思」+ Task 30「教训总结」→ 聚焦「代价与反思」
> ✅ 已合并：33 → 32 页

## 方案 E 重构记录

> ✅ 已完成重构（32 → 30 页）：
>
> - 删除 Part 4 Section 页
> - 合并「使用边界」+「放大器」为「AI 的边界与风险」
> - Part 3 副标题改为「踩坑与反思」
> - 「Home Assistant 三阶段」标题改为「From Vibe-Coding to Myself-Coding」

### 重构后结构

**Part 3: 踩坑与反思**（页 23-27）

- 23: Section: Part 3（踩坑与反思）
- 24: From Vibe-Coding to Myself-Coding
- 25: 那么，代价是什么？
- 26: 心智模型：模拟器 vs 实体
- 27: AI 的边界与风险（合并页）

**Part 4: 团队与收尾**（页 28-30，无 Section）

- 28: 团队采用：文化 > 工具
- 29: 一句话带走
- 30: Q&A

## 31. 心智模型：模拟器 vs 实体（页 26）

- [x] Step A: 研究准备（LLM simulator vs entity、persona prompting 研究）
- [x] Step B: 构思叙事（保持原有对比结构，⏩ 快速带过）
- [x] Step C: 设计初稿（添加页面类型标注）
- [x] Step D: 展示优化（保持现有布局）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 标注 ⏩ 快速带过，脚注加 ⭐

## 32. AI 的边界与风险（页 27，合并页）

- [x] Step A: 研究准备（METR RCT、Pure/Impure Engineering、Addy Osmani 技能退化）
- [x] Step B: 构思叙事（合并「使用边界」+「放大器」，🔴 重点页）
- [x] Step C: 设计初稿（two-cols 布局，左 METR 图 + 右技能退化）
- [x] Step D: 展示优化（调整列高、图片显示、脚注详细度）
- [x] Step E: Playwright 截图 + 用户 Review ✅（添加 3 个 v-click）
- [x] Step F: 标注 🔴 重点，脚注 ⭐ METR Study

## 33. 团队采用：文化 > 工具（页 28）

- [x] Step A: 研究准备（OCaml 13K PR 事件、Oxide RFD 576）
- [x] Step B: 构思叙事（左反面案例 + 右正面指导，🔴 重点页）
- [x] Step C: 设计初稿（添加页面类型标注）
- [x] Step D: 展示优化（丰富脚注描述）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 标注 🔴 重点，脚注 ⭐ Oxide RFD 576

## 34. 一句话带走（页 29）

- [x] Step A: 研究准备（搜索 crawshaw、antirez、Simon Willison 等经典文章）
- [x] Step B: 构思叙事（资源推荐页，3 列 grid 布局）
- [x] Step C: 设计初稿（6 分类 19 资源，每个带详细描述）
- [x] Step D: 展示优化（丰富作者背景、内容特点说明）
- [x] Step E: Playwright 截图 + 用户 Review ✅
- [x] Step F: 已提交 commit f0cb844

## 35. Q&A（页 30）

- [x] 跳过：layout: end 结束页，无需精修

## 40. 收尾验证

- [x] 40.1 确认总页数 ≤ 30 ✅ (30 页)
- [x] 40.2 确认所有页面有视觉锚点（本次精修页面已验证）
- [x] 40.3 确认所有页面有 speaker notes 类型标注（精修页面已添加）
- [x] 40.4 全量 Playwright 截图检查（各页已验证）
