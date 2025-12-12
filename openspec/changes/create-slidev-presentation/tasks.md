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

## Phase 4.5: Context Engineering Deep Dive & Part 2 Roadmap (NEW)

> **核心目标**：让听众真正理解 "为什么 Context Engineering 是现代 AI 编程的核心技能"，而不只是知道有这个概念。

### 4.5.1 Context Engineering 重整（2 页，高信噪比）

**核心叙事线**：
1. **比喻切入**：AI = 只能来一天的行业顾问（对你公司一无所知）
2. **问题定义**：你需要在有限时间内给 TA 提供恰到好处的信息
3. **策略框架**：四大策略解决这个问题
4. **现实约束**：Context Rot — 信息太多反而出问题

**Slide 21 设计**：
- [ ] 4.5.1.1 **开场比喻**：行业顾问 vs Context Window 类比
  - 顾问只能待一天 → Context Window 有限容量
  - 不知道公司情况 → 每次对话都是无状态的
  - 你的任务：在有限时间内给 TA 最相关的资料
- [ ] 4.5.1.2 **四大策略**（解决方案）
  - Write: 给顾问一个可以做笔记的本子（持久化）
  - Select: 只拿最相关的文档给 TA 看（检索）
  - Compress: 把 100 页报告压缩成 3 页摘要（压缩）
  - Isolate: 让 TA 带助手分头调研（子任务隔离）
- [ ] 4.5.1.3 **Context Rot 警告**（现实约束）
  - "不是给的资料越多越好，给错了反而害 TA"
  - Anthropic: "大多数 Agent 失败是 Context 失败"

**Slide 22 保留**（已验证效果好）：
- [ ] 4.5.1.4 保留现有动态可视化，微调风格统一

### 4.5.2 Part 2 知识路线图（1 页 Mermaid mindmap）

- [ ] 4.5.2.1 实现 mindmap（结构见 `docs/02-4-概念总结.md`）
- [ ] 4.5.2.2 Playwright 截图验证布局
- [ ] 4.5.2.3 插入 Part 2 结尾作为总结过渡

---

## Phase 5: Part 3 - My Pitfall Stories (~5-7 slides)

- [ ] 5.1 Slide: Home Assistant project 3 phases
- [ ] 5.2 Slide: PR refactoring lessons (3 副作用)
- [ ] 5.3 Slide: **Vibe Coding 爆炸案例**（承接 4.2 的引子）
- [ ] 5.4 Slide: Key takeaways
- [ ] 5.5 Sync: Update `docs/03-踩坑故事.md` terminology

## Phase 6: Part 4 - Proper Usage (~8-10 slides)

- [ ] 6.1 Slide: Context Engineering core principles
- [ ] 6.2 Slide: Good vs Bad Context examples
- [ ] 6.3 Slide: Simulator mindset (Karpathy quote)
- [ ] 6.4 Slide: Course Correct techniques
- [ ] 6.5 Slide: CLAUDE.md structure
- [ ] 6.6 Slide: OpenSpec workflow
- [ ] 6.7 Slide: Live demo overview
- [ ] 6.8 Slide: When AI helps most (Pure vs Impure engineering)
- [ ] 6.9 Sync: Update `docs/04-正确使用.md` terminology

## Phase 7: Part 5 - Risks & Mental Models (~7-9 slides)

- [ ] 7.1 Slide: Vibe Coding 4 risks diagram
- [ ] 7.2 Slide: Lovable security incident case
- [ ] 7.3 Slide: Technical debt data
- [ ] 7.4 Slide: METR study (perception vs reality)
- [ ] 7.5 Slide: Skill atrophy 4 symptoms
- [ ] 7.6 Slide: 葵花宝典 mental model
- [ ] 7.7 Slide: When to use / not use AI spectrum
- [ ] 7.8 Slide: 7 practical recommendations
- [ ] 7.9 Sync: Update `docs/05-风险与心智.md` terminology

## Phase 8: Part 6 - Team Adoption (~3-5 slides)

- [ ] 8.1 Slide: OCaml 13K PR case study
- [ ] 8.2 Slide: 3-phase adoption strategy
- [ ] 8.3 Slide: Code review principles (Oxide values)
- [ ] 8.4 Slide: Resources & Q&A
- [ ] 8.5 Slide: Closing (一句话总结)
- [ ] 8.6 Sync: Update `docs/06-团队采用.md` terminology

## Phase 9: Link Validation

- [ ] 9.1 Extract all footnote links from docs
- [ ] 9.2 Check HTTP accessibility (script)
- [ ] 9.3 Manually verify key references content
- [ ] 9.4 Fix or annotate broken links

## Phase 10: Final Polish

- [ ] 10.1 Review full slide deck flow
- [ ] 10.2 Check terminology consistency across all slides
- [ ] 10.3 Ensure all Mermaid diagrams render correctly
- [ ] 10.4 Add speaker notes if needed
- [ ] 10.5 Test PDF export (if required)
- [ ] 10.6 Update `07-附录.md` TODO status

---

## Progress Tracking

| Phase | Status | Slides | Notes |
|-------|--------|--------|-------|
| 0: Setup | ✅ Done | - | package.json, slides.md, public/images/ |
| 1: Part 1 | ✅ Done | 4 | 标题、为什么、路线图、声明、术语同步完成 |
| 2: Part 2.1 | ✅ Done | 5 | GPT-3、核心概念、Token体感、Copilot、工作方式 |
| 3: Part 2.2 | ✅ Done | 6 | ChatGPT/RLHF、幻觉、GPT-4、Function Call、RAG、推理模型、术语同步完成 |
| 4: Part 2.3 | ✅ Done | 6 | Agent、工具对比、MCP、Subagent/Skill、Context Engineering (×2)、Vibe Coding 移至 Part 5 |
| **4.5: CE & Roadmap** | **NEW** | **+1** | Context Engineering 重整 + Part 2 知识路线图 |
| 5: Part 3 | Pending | ~5 | |
| 6: Part 4 | Pending | ~8 | |
| 7: Part 5 | Pending | ~8 | |
| 8: Part 6 | Pending | ~5 | |
| 9: Links | Pending | - | |
| 10: Polish | Pending | - | |

**Estimated Total Slides**: ~51
