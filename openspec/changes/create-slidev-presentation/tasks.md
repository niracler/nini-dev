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

- [ ] 6.3.1 Sync: 术语检查 `docs/04-1-实操指南.md`
- [ ] 6.3.2 Sync: 术语检查 `docs/04-2-边界与采用.md`

## Phase 7: Link Validation

> 每个子任务 = 一次 apply，完成后等待用户确认

### 7.1 链接提取与分类

- [ ] 7.1.a 提取所有脚注链接：从 docs/*.md 提取完整链接列表
- [ ] 7.1.b 链接分类：按来源类型分类（论文、博客、官方文档、视频等）
- [ ] 7.1.c 用户确认：确认分类结果，标记重点验证链接

### 7.2 自动化检查

- [ ] 7.2.a HTTP 可访问性检查：批量检测链接状态码
- [ ] 7.2.b 输出问题链接清单：列出 404、超时、重定向等问题
- [ ] 7.2.c 用户确认：确认问题清单，决定修复优先级

### 7.3 内容验证（逐链接）

- [ ] 7.3.a 验证论文/研究类链接：确认引用内容与描述匹配
- [ ] 7.3.b 验证工具/文档类链接：确认版本、API 是否过时
- [ ] 7.3.c 验证博客/文章类链接：确认核心观点引用准确
- [ ] 7.3.d 用户确认：确认验证结果

### 7.4 修复与标注

- [ ] 7.4.a 修复可修复链接：更新失效链接为新地址
- [ ] 7.4.b 标注无法修复链接：添加「链接已失效」注释或替代来源
- [ ] 7.4.c 用户确认：确认所有修复完成

## Phase 8: Expert Review (专家模拟回顾)

> **核心方法论**：用「模拟器而非实体」心智模型回顾已完成页面
> 参考 `design.md` 中的专家模拟矩阵
>
> 每个子任务 = 一次 apply，完成后等待用户确认

### 8.1 叙事结构审查 (Nancy Duarte 视角)

- [ ] 8.1.a 审查整体叙事弧线：Part 1-4 是否形成「现状→更好未来」的转变？
- [ ] 8.1.b 用户确认：确认叙事弧线分析结果
- [ ] 8.1.c 检查每页的「张力」：逐页分析对比或转折点
- [ ] 8.1.d 用户确认：确认张力分析结果
- [ ] 8.1.e 识别并优化「平淡页」：列出缺乏叙事动力的页面
- [ ] 8.1.f 用户确认 + 修复：逐页修复平淡页（每页一次 apply）

### 8.2 信噪比审查 (Edward Tufte 视角)

- [ ] 8.2.a 逐页检查视觉元素：列出每页的装饰 vs 信息元素
- [ ] 8.2.b 用户确认：确认检查结果
- [ ] 8.2.c 删除冗余元素：逐页清理装饰性元素（每页一次 apply）
- [ ] 8.2.d 优化 Mermaid 图：检查并简化复杂图表
- [ ] 8.2.e 用户确认：确认所有优化完成

### 8.3 概念解释审查 (Andrej Karpathy 视角)

- [ ] 8.3.a 检查 Part 2 概念页：列出缺乏类比的页面
- [ ] 8.3.b 用户确认：确认检查结果
- [ ] 8.3.c 优化概念解释：逐页添加类比（每页一次 apply）
- [ ] 8.3.d 检查「心智模型」页：验证解释是否足够深入浅出
- [ ] 8.3.e 用户确认：确认所有优化完成

### 8.4 教学节奏审查 (Patrick Winston 视角)

- [ ] 8.4.a 检查每页开场：列出开场不够吸引的页面
- [ ] 8.4.b 用户确认：确认检查结果
- [ ] 8.4.c 确认「一页一想法」：识别概念过载的页面
- [ ] 8.4.d 用户确认 + 拆分：拆分过载页面（每页一次 apply）
- [ ] 8.4.e 识别并强化「啊哈时刻」：确保关键洞察突出
- [ ] 8.4.f 用户确认：确认所有优化完成

## Phase 9: Final Polish

> 每个子任务 = 一次 apply，完成后等待用户确认

### 9.1 整体流程检查

- [ ] 9.1.a 通读全部 slides：检查整体流程是否流畅
- [ ] 9.1.b 输出问题清单：列出需要调整的过渡、顺序问题
- [ ] 9.1.c 用户确认：确认问题清单

### 9.2 术语一致性检查

- [ ] 9.2.a 提取所有术语使用：对照术语表检查一致性
- [ ] 9.2.b 输出不一致清单：列出术语使用不一致的位置
- [ ] 9.2.c 逐个修复：修复术语不一致（每批一次 apply）
- [ ] 9.2.d 用户确认：确认所有修复完成

### 9.3 技术验证

- [ ] 9.3.a Mermaid 图渲染检查：确认所有图表正确渲染
- [ ] 9.3.b 修复渲染问题：修复有问题的图表
- [ ] 9.3.c 用户确认：确认图表正确

### 9.4 演讲者备注

- [ ] 9.4.a 评估是否需要备注：确认哪些页面需要 speaker notes
- [ ] 9.4.b 用户确认：确认需要添加备注的页面
- [ ] 9.4.c 逐页添加备注：每页一次 apply
- [ ] 9.4.d 用户确认：确认所有备注完成

### 9.5 导出测试

- [ ] 9.5.a PDF 导出测试：生成 PDF 并检查格式
- [ ] 9.5.b 修复导出问题：修复布局、字体等问题
- [ ] 9.5.c 用户确认：确认导出质量

### 9.6 收尾

- [ ] 9.6.a 更新 `05-附录.md` TODO 状态
- [ ] 9.6.b 用户最终确认：项目完成

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
| 6: Part 4 | 🚧 In Progress | 20/22 | 6.1 ✅, 6.2.1-6.2.4 ✅, 剩余 6.3 术语检查 |
| 7: Links | Pending | 0/13 | 链接提取、检查、验证、修复 |
| 8: Expert Review | Pending | 0/22 | Duarte/Tufte/Karpathy/Winston 四视角审查 |
| 9: Polish | Pending | 0/16 | 流程、术语、技术验证、备注、导出 |

**工作模式**：单页单步 — 每次 apply 只处理一个子任务，完成后等待用户确认

**Target**: 38 页上限
**Current**: 37 页 (Part 1-4 全部完成 + End 页)
**Remaining**: Phase 6.3 术语检查 → Phase 7-9
