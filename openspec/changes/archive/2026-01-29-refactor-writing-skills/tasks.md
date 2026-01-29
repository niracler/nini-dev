# Tasks: Writing Skills 拆分

> **核心约束**：遵循 TDD 流程（RED → GREEN → REFACTOR），每个 skill 完成后验证。

## 通用流程

```text
Step A: 研究准备 — 了解现有代码、确认迁移内容
Step B: 创建 skill — 目录结构、SKILL.md、references
Step C: 验证测试 — 触发词识别、完整流程测试
Step D: 清理收尾 — 删除旧 skill、确认无引用问题
```

---

## Phase 1: diary-assistant（优先）

### 1.1 研究准备 (Step A)

- [x] **A1**: 阅读现有 `writing-assistant/SKILL.md` 的日记相关部分
- [x] **A2**: 确认 `user-config.md` 和 `worklog-automation.md` 的内容
- [x] **A3**: 确认 `schedule-manager` skill 的调用方式（获取任务、创建 Reminders）
- [x] **A4**: 确认日记模板的结构（Journal / Work Log / TIL 部分）

### 1.2 创建 skill (Step B)

- [x] **B1**: 创建 `src/diary-assistant/` 目录结构
  ```
  diary-assistant/
  ├── SKILL.md
  └── references/
      ├── user-config.md
      └── worklog-automation.md
  ```

- [x] **B2**: 编写 SKILL.md frontmatter
  - name: diary-assistant
  - description: 以 "Use when..." 开头，包含触发词

- [x] **B3**: 编写 SKILL.md Overview + 核心原则
  - 45 分钟时间约束
  - GTD 集成理念

- [x] **B4**: 编写完整流程 flowchart（使用 ASCII）

- [x] **B5**: 编写 Pre-Diary Clarification 部分
  - 确认日期
  - 检测已存在文件（继续/追加/重新开始）

- [x] **B6**: 编写任务回顾部分（简化版）
  - 批量勾选完成的任务
  - 未完成默认延期到明天

- [x] **B7**: 编写 Work Log 自动化部分
  - 工作日自动执行
  - 周末跳过

- [x] **B8**: 编写启发提问部分（适应性）
  - 工作日问题列表（2 个）
  - 周末问题列表（3 个）
  - 最后一个问题固定为「之后有什么计划」

- [x] **B9**: 编写任务捕获部分
  - 解析计划中的日期
  - 调用 schedule-manager 创建 Reminders

- [x] **B10**: 编写智能收尾部分
  - TIL 检测 → Anki 推荐

- [x] **B11**: 迁移 references 文件
  - user-config.md
  - worklog-automation.md

### 1.3 验证测试 (Step C)

- [ ] **C1**: 测试触发词识别（新会话说「帮我写日记」）
- [ ] **C2**: 测试任务回顾流程（有任务 / 无任务）
- [ ] **C3**: 测试 Work Log 自动获取（工作日 vs 周末）
- [ ] **C4**: 测试启发提问流程（适应性问题）
- [ ] **C5**: 测试任务捕获解析（「下周」「周五」等日期）
- [ ] **C6**: 测试完整流程时间（目标 ≤45min）

---

## Phase 2: writing-inspiration

### 2.1 研究准备 (Step A)

- [x] **A1**: 阅读现有 `writing-assistant/SKILL.md` 的启发相关部分
- [x] **A2**: 确认 `inspiration.md` 中的游记/TIL/通用框架

### 2.2 创建 skill (Step B)

- [x] **B1**: 创建 `src/writing-inspiration/` 目录结构
  ```
  writing-inspiration/
  ├── SKILL.md
  └── references/
      └── frameworks.md
  ```

- [x] **B2**: 编写 SKILL.md frontmatter
  - name: writing-inspiration
  - description: 以 "Use when..." 开头，包含触发词

- [x] **B3**: 编写 SKILL.md 主体
  - 文章类型识别（游记/TIL/通用）
  - 启发提问流程

- [x] **B4**: 迁移 frameworks.md
  - 游记框架（出发→旅途→反思）
  - TIL 框架（背景→过程→方案→收获）
  - 通用框架（起因→观点→展开→收尾）

### 2.3 验证测试 (Step C)

- [ ] **C1**: 测试触发词识别（「不知道写什么」「帮我构思」）
- [ ] **C2**: 测试文章类型识别
- [ ] **C3**: 测试启发提问流程

---

## Phase 3: writing-proofreading

### 3.1 研究准备 (Step A)

- [x] **A1**: 阅读现有 `writing-assistant/SKILL.md` 的审校相关部分
- [x] **A2**: 确认现有 references 文件内容

### 3.2 创建 skill (Step B)

- [x] **B1**: 创建 `src/writing-proofreading/` 目录结构
  ```
  writing-proofreading/
  ├── SKILL.md
  └── references/
      ├── chinese-style.md
      ├── structure-review.md
      ├── source-verification.md
      └── personal-style.md
  ```

- [x] **B2**: 编写 SKILL.md frontmatter
  - name: writing-proofreading
  - description: 以 "Use when..." 开头，包含触发词

- [x] **B3**: 编写 SKILL.md 主体
  - 6 步审校流程
  - 按 heading 分段审校

- [x] **B4**: 迁移 references 文件
  - chinese-style.md
  - structure-review.md
  - source-verification.md
  - personal-style.md

### 3.3 验证测试 (Step C)

- [ ] **C1**: 测试触发词识别（「帮我改文章」「检查一下」「润色」）
- [ ] **C2**: 测试 6 步审校流程
- [ ] **C3**: 测试分段审校节奏

---

## Phase 4: 清理收尾 (Step D)

- [x] **D1**: 确认三个新 skill 都已创建并可用
- [x] **D2**: 确认无其他 skill 引用 `writing-assistant`
- [x] **D3**: 删除 `src/writing-assistant/` 目录
- [x] **D4**: 提交所有更改 — commit `0ddfda3`

---

## 依赖关系

```
Phase 1 (diary-assistant)
    ↓
Phase 2 (writing-inspiration)  ← 可与 Phase 3 并行
    ↓
Phase 3 (writing-proofreading) ← 可与 Phase 2 并行
    ↓
Phase 4 (清理)
```

**可并行**：Phase 2 和 Phase 3 相互独立，可以并行开发。
