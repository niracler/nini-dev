## Context

`~/code` 下有 10 个顶层目录，其中 8 个是 git 仓库，部分目录下有嵌套仓库（如 `nini-dev/repos/`），总计约 28 个 git 仓库。远程混合 GitHub (HTTPS) 和 Codeup (SSH)，默认分支有 `main` 和 `master` 两种。

现有 `repos/skill/` 使用 `skills/<name>/SKILL.md` + 可选 `scripts/` 的结构。

## Goals / Non-Goals

**Goals:**

- 一条命令完成全局代码同步（push 或 pull）
- 确定性操作（扫描、批量 push/pull）由 shell 脚本保证可靠性
- 模糊决策（dirty repo、冲突）由 Claude Code 在当前会话中智能处理
- 触发词与 git-workflow 完全隔离
- Skill 通过 `skill-reviewer` 审查，确保结构、质量、兼容性达标

**Non-Goals:**

- 不做定时自动同步（cron），用户手动触发
- 不管理仓库的创建/删除/clone
- 不处理 submodule（当前没有仓库使用 submodule）

## Decisions

### D1: 扫描范围——固定两层扫描

**选择**: 扫描 `~/code/*/` 和 `~/code/*/repos/*/`

**替代方案**:

- 只扫描顶层 `~/code/*/` → 漏掉 nini-dev/repos/ 等嵌套仓库
- 递归 `find` 所有 `.git` → 不可控，可能深入 node_modules 等

**理由**: 匹配现有 workspace 约定（多仓库工作区都用 `repos/` 子目录），覆盖全部 28 个仓库，扫描深度可控

### D2: 脚本职责——只扫描，不修改

**选择**: `scan.sh` 只输出 JSON 状态报告，不执行任何 git 写操作

**替代方案**:

- 脚本同时负责 push/pull → 脚本变复杂，错误处理困难
- 脚本提供 `push-clean` 批量命令 → 可行但不必要，Claude Code 用一条 bash 就能批量 push

**理由**: 单一职责——扫描是确定性操作，适合脚本；push/pull 需要根据上下文决策，适合 Claude Code

### D3: scan.sh 支持 `--fetch`

**选择**: `scan.sh` 接受 `--fetch` 参数，扫描前先 `git fetch` 每个仓库

**理由**: Pull 模式需要 fetch 后才能获取 ahead/behind 信息，将 fetch 集成到扫描中避免 Claude Code 需要额外循环

### D4: JSON 输出结构

```json
[
  {
    "path": "/Users/.../nini-dev",
    "name": "nini-dev",
    "branch": "main",
    "remote": "origin",
    "remote_url": "https://github.com/niracler/nini-dev.git",
    "dirty_count": 0,
    "has_upstream": true,
    "ahead": 2,
    "behind": 0
  }
]
```

字段说明：

- `dirty_count`: 未提交的文件数（包括 untracked）
- `has_upstream`: 当前分支是否有 upstream tracking
- `ahead`/`behind`: 相对 upstream 的提交差异（未 fetch 时 behind 可能不准确，需配合 `--fetch`）

不包含 dirty 文件列表——Claude Code 需要详情时自行 `git diff` 检查，避免 JSON 过大

### D5: Claude Code 异常处理策略

Push 模式遇到 dirty repo 时，Claude Code:

1. `cd` 到该仓库
2. 运行 `git diff --stat` 和 `git status` 了解改动
3. 向用户描述改动内容并建议处理方式（commit / stash / skip）
4. 用户确认后执行

Pull 模式遇到 ff-only 失败时，同理分析并建议 rebase / merge / skip

### D6: 触发词隔离

| Skill | 触发词 | 作用域 |
|-------|--------|--------|
| git-workflow | 帮我提交、commit、推代码、创建 PR | 单仓库 |
| code-sync | 同步代码、code-sync、下班同步、上班更新 | 全局 ~/code |

完全不重叠，避免误触发

## Skill 创建与审查流程

> 本 change 在 explore 阶段参考了 `writing-skills`（skill 结构规范、CSO）和 `skill-reviewer`（审查维度），据此定义以下实施流程。

### 流程总览

```
Phase 1        Phase 2         Phase 3          Phase 4          Phase 5
Scripts  ──▶  SKILL.md  ──▶  Skill Review ──▶ Issue Resolution ──▶ Final
                              (skill-reviewer)  (🔍 用户协商)     Verification
```

### Phase 1: scan.sh 脚本

每个子步骤为一个 task 单元：

| Step | 内容 | Gate |
|------|------|------|
| 1.1 | 创建目录结构 `skills/code-sync/scripts/` | 目录存在 |
| 1.2 | 实现核心扫描逻辑：遍历两层目录，识别 git 仓库 | 能发现所有 28 个仓库 |
| 1.3 | 实现 JSON 输出：所有 D4 定义的字段 | JSON 格式正确 |
| 1.4 | 实现 `--fetch` 参数：fetch + 超时 10 秒 + 失败标记 | fetch_error 标记生效 |
| 1.5 | 终端验证：运行 `scan.sh` 和 `scan.sh --fetch` | 输出有效 JSON |

**Phase Gate**: `scan.sh` 输出有效 JSON，覆盖全部仓库

### Phase 2: SKILL.md 编写

| Step | 内容 | Gate |
|------|------|------|
| 2.1 | 研究现有 skill 模式：阅读 `git-workflow` 和 `schedule-manager` 的 SKILL.md 结构 | 了解触发词写法、工作流组织方式 |
| 2.2 | 编写 frontmatter：name + description（符合 CSO 规范，"Use when..." 开头） | frontmatter 合规 |
| 2.3 | 编写 Push 模式工作流（扫描 → 分类 → 批量 push → 异常处理 → 汇总） | 流程完整 |
| 2.4 | 编写 Pull 模式工作流（fetch+扫描 → 分类 → 批量 pull → 异常处理 → 汇总） | 流程完整 |
| 2.5 | 编写异常处理指引（dirty repo、ff-only 失败、无 upstream） | 覆盖所有异常场景 |
| 2.6 | 编写汇总报告格式 | 格式清晰 |
| 2.7 | 自审：对照 specs 检查所有 requirement 是否覆盖 | 无遗漏 |

**Phase Gate**: SKILL.md 完整覆盖 specs 中所有 requirement

### Phase 3: Skill Review（skill-reviewer）

调用 `skill-reviewer` skill 对完成的 skill 进行审查，按其 4 步流程执行：

| Step | 内容 | 输出 |
|------|------|------|
| 3.1 | 结构校验：运行 `validate.sh` | PASS / FAIL |
| 3.2 | 内容质量：调用 `writing-skills` 深度审查（token 效率、渐进式披露、反模式） | 建议列表 |
| 3.3 | 兼容性审计：跨平台 (3a)、跨 Agent (3b)、npx skills 生态 (3c)、工具引用规范 (3d) | 问题列表 |
| 3.4 | 输出审查报告：按 Critical / High / Medium / Low 分级 | 完整报告 |

**Phase Gate**: 审查报告已生成

### Phase 4: Issue Resolution（🔍 用户协商）

> 此阶段的具体 tasks **在 Phase 3 完成后动态生成**，无法预先定义。

**流程**:

```
审查报告
  │
  ├── Critical / High issues
  │     每个 issue 作为独立 task:
  │     ┌─────────────────────────────────────────┐
  │     │ 1. 描述问题（是什么、影响范围）          │
  │     │ 2. 提出修复方案（可能多个选项）          │
  │     │ 3. 🔍 用户决策（选方案 / 跳过 / 其他）  │
  │     │ 4. 执行修复                             │
  │     └─────────────────────────────────────────┘
  │
  └── Medium / Low issues
        列出清单，🔍 用户决定哪些需要处理
```

**Phase Gate**: 所有 Critical/High 已解决或用户明确跳过

### Phase 5: Final Verification

| Step | 内容 | Gate |
|------|------|------|
| 5.1 | 重跑 `validate.sh` 确认 skill 格式合规 | PASS |
| 5.2 | 新会话测试触发词：说「同步代码」确认触发 code-sync 而非 git-workflow | 正确触发 |
| 5.3 | 新会话测试 Push 模式：完整执行一次 push 流程 | 流程正确 |
| 5.4 | 新会话测试 Pull 模式：完整执行一次 pull 流程 | 流程正确 |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| 28 个仓库扫描耗时 | scan.sh 串行执行 git 命令，预计 2-5 秒（无 fetch）或 10-20 秒（有 fetch） |
| `--fetch` 时网络问题导致某个仓库卡住 | fetch 设置超时（`git fetch --timeout=10`），失败的仓库标记为 error 继续扫描 |
| 非顶层仓库可能不需要同步 | 用户表示不需要的仓库会直接删除，不做配置化跳过 |
| Claude Code context 长度 | 大部分仓库在 scan 阶段就分流了，Claude Code 只深入处理 2-3 个异常仓库 |
| skill-reviewer 发现大量问题 | Phase 4 逐项与用户协商，Medium/Low 可批量跳过，避免修复过度 |
