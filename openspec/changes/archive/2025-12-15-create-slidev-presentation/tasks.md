# Tasks: Create Slidev Presentation

## Phase 0: Project Setup

- [x] 0.1 Update `package.json` with Slidev dependencies
- [x] 0.2 Create `slides.md` with basic structure
- [x] 0.3 Configure Slidev theme and settings
- [x] 0.4 Create `public/images/` directory for assets
- [x] 0.5 Test Slidev dev server runs correctly

## Phase 1: Part 1 - Opening (~4 slides)

- [x] 1.1 Slide: Title page (分享主题、目标时长)
- [x] 1.2 Slide: Why this sharing (Agentic Coding 引入)
- [x] 1.3 Slide: Roadmap (3 卡片 + 预言)
- [x] 1.4 Slide: Disclaimer (信源等级 + 内容标注)
- [x] 1.5 Sync: Update `docs/01-开场.md` terminology

## Phase 2: Part 2.1 - Early Development (~5-6 slides)

- [x] 2.1 Slide: GPT-3 timeline & architecture diagram
- [x] 2.2 Slide: Key concepts table (Token, Context, Stateless, etc.)
- [x] 2.3 Slide: Token visualization & cost comparison
- [x] 2.4 Slide: Copilot introduction & workflow
- [x] 2.5 Slide: Copilot productivity data & risks
- [x] 2.6 Sync: Update `docs/02-1-早期发展.md` terminology

## Phase 3: Part 2.2 - Capability Leap (~6-7 slides)

- [x] 3.1 Slide: ChatGPT explosion & RLHF
- [x] 3.2 Slide: Hallucination examples & causes
- [x] 3.3 Slide: GPT-4 capabilities & multimodal
- [x] 3.4 Slide: Function Call explanation (Mermaid diagram)
- [x] 3.5 Slide: RAG architecture (Mermaid diagram)
- [x] 3.6 Slide: Reasoning models (o1, DeepSeek R1)
- [x] 3.7 Sync: Update `docs/02-2-能力跃升.md` terminology

## Phase 4: Part 2.3 - Agent Era (~5 slides)

- [x] 4.1 Slide: Agent vs Traditional LLM + ReAct loop
- [x] 4.2 Slide: Cursor / Claude Code comparison (Vibe Coding 移至 Part 5)
- [x] 4.3 Slide: MCP architecture (Mermaid diagram)
- [x] 4.4 Slide: Subagent & Skill (合并)
- [x] 4.5 Slide: Context Engineering (重点)
- [x] 4.6 Sync: Update `docs/02-3-Agent时代.md` (术语已统一)

## Phase 4.5: Context Engineering Deep Dive & Roadmap ✅

- [x] 4.5.1 Context Engineering 重整（比喻 + 四大策略 + Context Rot）
- [x] 4.5.2 Part 2 知识路线图（Mermaid mindmap）

---

## Phase 5: Part 3 - My Pitfall Stories (~3 slides)

- [x] 5.1 Slide: Home Assistant project 3 phases（三阶段卡片 + 85% 法则引用）
- [x] 5.2 Slide: PR refactoring lessons (3 副作用 + 实际 PR 链接)
- [x] 5.3 Slide: Key takeaways（认知兴奋剂比喻 + 辩证思考）
- [x] ~~5.3 Slide: Vibe Coding 爆炸案例~~ (已合并到 5.1-5.2)
- [x] 5.4 Footnotes: 完善三页脚注（Nature 论文、实际 PR、Programmer Identity Crisis）

## Phase 6: Part 4 - 正确使用 AI 编程 (~8-10 slides)

> **目标页数**: 38 页上限，当前 Part 1-3 约 28 页，Part 4 可用 ~10 页
> **对应文稿**: `docs/04-1-实操指南.md` + `docs/04-2-边界与采用.md`
> **核心取舍**: 演示概要可简化为脚注，重点放在可复用的心智模型和实操建议

### 6.1 实操指南部分 (~4 slides)

- [x] 6.1.1 Slide: 心智模型 — 模拟器而非实体 (Karpathy quote + 实操表格)
- [x] 6.1.2 Slide: Context Engineering 实操 — Anthropic 三原则 + 好/坏 Context 对话模拟
- [x] ~~6.1.3 Slide: Course Correct~~ — 已删除（与 6.1.2 内容重复）
- [x] 6.1.4 Slide: CLAUDE.md — WHAT/WHY/HOW 结构 + 精简原则
- [x] 6.1.5 Slide: 工具链全景 — Skills / MCP / Slash Commands (OpenSpec 合并在此)

### 6.2 边界与采用部分 (~4 slides)

- [x] 6.2.1 Slide: 使用边界 — METR 研究图表 + Pure/Impure 框架 (含截图记忆点)

#### 6.2.2 Slide: 风险意识 — 技能退化三征兆 + X-Y Problem

- [x] 6.2.2.a 研究准备：搜索技能退化、AI 成本相关资料
- [x] 6.2.2.b 构思叙事：确定核心想法、记忆点、视觉锚点方案
- [x] 6.2.2.c 设计初稿 + 自审：编写 slide 代码 + Tufte/antfu 审查
- [x] 6.2.2.d Playwright 截图验证：确认布局正确
- [x] 6.2.2.e 用户确认 + 同步文稿：更新 VitePress 文稿

#### 6.2.3 Slide: 团队采用 — OCaml 案例 + Oxide 原则

- [x] 6.2.3.a 研究准备：搜索 OCaml 案例、Oxide 原则相关资料
- [x] 6.2.3.b 构思叙事：确定核心想法、记忆点、视觉锚点方案
- [x] 6.2.3.c 设计初稿 + 自审：编写 slide 代码 + Tufte/antfu 审查
- [x] 6.2.3.d Playwright 截图验证：确认布局正确
- [x] 6.2.3.e 用户确认 + 同步文稿：更新 VitePress 文稿

#### 6.2.4 Slide: 收尾 — 一句话总结 + Q&A 引导 + 资源链接

- [x] 6.2.4.a 研究准备：整理全文要点、收集资源链接
- [x] 6.2.4.b 构思叙事：确定核心想法、记忆点、视觉锚点方案
- [x] 6.2.4.c 设计初稿 + 自审：编写 slide 代码 + Tufte/antfu 审查
- [x] 6.2.4.d Playwright 截图验证：确认布局正确
- [x] 6.2.4.e 用户确认 + 同步文稿：更新 VitePress 文稿

### 6.3 同步与验证

- [x] 6.3.1 Sync: 术语检查 `docs/04-1-实操指南.md`
- [x] 6.3.2 Sync: 术语检查 `docs/04-2-边界与采用.md`

---

## Progress Tracking

| Phase | Status | Tasks | Notes |
|-------|--------|-------|-------|
| 0: Setup | ✅ Done | 5/5 | package.json, slides.md, public/images/ |
| 1: Part 1 | ✅ Done | 5/5 | 标题、为什么、路线图、声明 |
| 2: Part 2.1 | ✅ Done | 6/6 | GPT-3、核心概念、Token体感、Copilot、工作方式 |
| 3: Part 2.2 | ✅ Done | 7/7 | ChatGPT/RLHF、幻觉、GPT-4、Function Call、RAG、推理模型 |
| 4: Part 2.3 | ✅ Done | 6/6 | Agent、工具对比、MCP、Subagent/Skill、Context Engineering |
| 4.5: CE & Roadmap | ✅ Done | 2/2 | Context Engineering 重整 + Part 2 知识路线图 |
| 5: Part 3 | ✅ Done | 4/4 | Home Assistant 三阶段、PR 重构、教训总结 |
| 6: Part 4 | ✅ Done | 22/22 | 6.1 ✅, 6.2 ✅, 6.3 术语检查 ✅ |

**工作模式**：单页单任务 — 每次 apply 只处理一页 PPT，A-B-C-D 自动执行，E 处用户 Review

**Target**: 38 页上限
**Current**: 37 页 (Part 1-4 全部完成 + End 页)
**Status**: ✅ 全部完成 — 后续精修工作将在新 proposal 中进行
