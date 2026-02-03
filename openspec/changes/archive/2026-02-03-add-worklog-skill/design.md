## Context

diary-assistant 当前包含一个 Work Log 自动化步骤（`references/worklog-automation.md`），通过 subagent 并行获取云效和 GitHub 数据，输出非结构化 Markdown 列表嵌入日记。数据源配置在 `references/user-config.md` 中，与日记配置混在一起。

code-sync skill 有一个 `scan.sh` 脚本，扫描 `~/code/*/` 和 `~/code/*/repos/*/` 下所有 git 仓库并输出 JSON 状态。worklog 的仓库发现可复用相同路径逻辑。

用户需求：个人开发回顾，给自己看，不给别人看。需要量化分析（commit 数、代码行数等），支持 daily 和 weekly 两种时间粒度，每次独立从 git/API 重算。

## Goals / Non-Goals

**Goals:**

- 提供独立的 worklog skill，可脱离日记流程使用
- `stats.sh` 收集本地 git 统计数据，输出 JSON
- 整合三个数据源：本地 git（stats.sh）、GitHub API（gh CLI）、云效 MCP
- 结构化 Markdown 模板输出，包含概览 + 按项目明细 + 统计
- diary-assistant 的 worklog 步骤改为调用 worklog skill
- 触发词与 diary-assistant 完全隔离

**Non-Goals:**

- 不做自动定时生成（用户手动触发或由 diary-assistant 调用）
- 不做给他人看的周报格式（无需考虑汇报措辞和脱敏）
- 不做跨周/跨月的长期趋势分析
- 不做中间数据存储（每次独立重算）
- 不修改 yunxiao skill 或 code-sync skill 本身

## Decisions

### D1: stats.sh 与 scan.sh 的关系——独立脚本，复用扫描逻辑

**选择**: 新建独立的 `stats.sh`，内部复用 scan.sh 相同的目录扫描模式（`~/code/*/` 和 `~/code/*/repos/*/`）

**替代方案**:

- 直接调用 scan.sh 再补充统计 → scan.sh 输出的是同步状态（dirty_count, ahead, behind），不包含统计信息，改造 scan.sh 会影响 code-sync
- 让 stats.sh import/source scan.sh → 增加耦合，scan.sh 输出 JSON 不方便复用

**理由**: 两个脚本职责不同（scan.sh = 实时同步状态，stats.sh = 历史统计数据），独立维护更清晰。扫描路径的重复是可接受的（3 行代码）

### D2: stats.sh 输出结构

**选择**: 输出 JSON，按仓库聚合统计

```json
{
  "period": {"from": "2026-01-27", "to": "2026-02-02"},
  "repos": [
    {
      "name": "skill",
      "path": "/Users/.../skill",
      "remote_url": "https://github.com/niracler/skill.git",
      "commits": 12,
      "insertions": 847,
      "deletions": 232,
      "files_changed": 15,
      "authors": ["niracler"],
      "first_commit": "2026-01-27T09:15:00+08:00",
      "last_commit": "2026-02-02T18:30:00+08:00"
    }
  ],
  "totals": {
    "repos_active": 3,
    "repos_scanned": 28,
    "commits": 23,
    "insertions": 1847,
    "deletions": 632
  }
}
```

**参数**:

- `--since YYYY-MM-DD` 和 `--until YYYY-MM-DD`：时间范围（必须）
- `--author <email|name>`：按作者过滤（可选，默认取 `git config user.name`）

**理由**: 时间范围参数化让 daily 和 weekly 复用同一脚本，只是传入不同的日期。JSON 输出让 skill 层灵活渲染

### D3: 每日提交时间分布——仅周报包含

**选择**: 每日按星期几聚合 commit 数（简易 ASCII 柱状图），仅在 weekly 模式输出

**替代方案**:

- 每小时分布 → 对个人回顾过于细致
- 不做时间分布 → 周报缺少节奏感

**理由**: 按天聚合直观反映一周工作节奏，实现简单（git log --format=%aI 提取日期即可）

### D4: 数据源整合策略——脚本做确定性操作，skill 层做 MCP

**选择**: 数据获取分两层

```
脚本层 (确定性，CLI)               skill 层 (需 MCP/上下文)
──────────────────               ─────────────────────────
stats.sh: git log 统计            云效 MCP: MR/Bug/任务
github.sh: gh api PR/Issue        主题归纳 + 模板渲染
           ↓                              ↓
        JSON 输出                    结构化数据
              ↘                    ↙
               整合 → 模板渲染 → Markdown
```

**替代方案**:

- 全部在脚本里做（包括云效）→ `aliyun devops` CLI 可靠性不足（SYSTEM_UNAUTHORIZED_ERROR、复杂参数格式），yunxiao skill 自己也建议优先用 MCP
- 全部在 skill 层做 → 丢失脚本的确定性和速度优势
- GitHub 也放 skill 层 → `gh` CLI 本地已认证且稳定，脚本化更可靠

**理由**: 延续 code-sync 的"脚本做确定性操作，Claude Code 做模糊决策"模式。`stats.sh` 和 `github.sh` 处理有明确 CLI 的数据源；云效因 MCP 工具比 CLI 更稳定，保留在 skill 层

### D5: 模板结构——叙事 + 表格混合，按工作主题分组

**选择**: 叙事段落提供上下文，表格承载结构化细节。按工作主题分组（非数据源分组）。

```
┌─────────────────────────────────────────┐
│  > 一行概览 (数字速览)                    │
├─────────────────────────────────────────┤
│  叙事段落 (给上下文: 在干嘛、为什么)       │
│  ┌─────────────────────────────────┐    │
│  │  表格 (结构化细节: MR/Bug/PR)    │    │
│  └─────────────────────────────────┘    │
│  ... 重复每个主题 ...                    │
├─────────────────────────────────────────┤
│  统计图 + 亮点 (仅 weekly)               │
└─────────────────────────────────────────┘
```

**关键规则**:

- **MR/PR**: 按主题合并行（相关的 MR 放同一行），不逐条列
- **Bug**: 逐条列（通常不多，且各有不同状态）
- **分组**: 按工作主题（如 "Sunlite Backend" "Skills 重构" "HA 开源贡献"），不按数据源（云效/GitHub）
- **概览**: 引用行格式 `> 100 commits · +63,182 / -20,459 · 13 repos`
- **"其他"归类**: 低活动 repo 聚合为一行

**替代方案**:

- 按数据源分组（云效 → GitHub）→ 读起来像"各系统有什么数据"，不像"做了什么"
- 全部表格化 → 缺少叙事上下文，难以理解工作目的
- 全部叙事化 → 难以快速查找特定 MR/Bug 编号

**理由**: 叙事回答"做了什么、为什么"，表格回答"具体哪些项目"。主题分组让读者按工作流理解进展，而非按工具理解数据

### D6: diary-assistant 集成方式——worklog skill 作为数据提供者

**选择**: diary-assistant 的 worklog 步骤改为调用 worklog skill（daily 模式），获取格式化的 Markdown 直接嵌入日记

**具体改动**:

```
diary-assistant SKILL.md:
  步骤 3 "Work Log 自动化" →
    "调用 worklog skill 获取当日工作回顾，
     将输出直接作为日记的 Work Log 部分"

删除: references/worklog-automation.md
修改: references/user-config.md（移除 worklog_sources、yunxiao_org_id、github_user）
```

**替代方案**:

- worklog 提供结构化数据，diary 自行渲染 → 增加集成复杂度
- diary 保留自己的获取逻辑作为备份 → 两套逻辑需维护

**理由**: worklog 已经输出格式化 Markdown，diary 直接使用即可，最简方案

### D7: 触发词隔离

| Skill | 触发词 | 场景 |
|-------|--------|------|
| worklog | 工作回顾、日报、周报、worklog | 独立生成工作回顾 |
| diary-assistant | 写日记、记录今天、今天的日记 | 完整日记流程（内部调用 worklog） |
| code-sync | 同步代码、code-sync、下班同步 | Git 仓库批量同步 |

完全不重叠

### D8: GitHub 数据收集——独立脚本 `github.sh`

**选择**: 新建 `scripts/github.sh`，通过 `gh` CLI 收集 PR/Issue 活动，输出 JSON

**参数**:

- `--since YYYY-MM-DD` 和 `--until YYYY-MM-DD`：时间范围
- `--username <github-username>`：GitHub 用户名（可选，默认从 `gh api user` 获取）

**输出结构**:

```json
{
  "period": {"from": "2026-01-26", "to": "2026-02-01"},
  "prs": [
    {"repo": "niracler/skill", "number": 3, "title": "...", "state": "merged", "created_at": "...", "merged_at": "..."}
  ],
  "issues": [
    {"repo": "...", "number": 1, "title": "...", "state": "open", "created_at": "..."}
  ],
  "totals": {"prs_merged": 5, "prs_open": 2, "issues_opened": 0, "issues_closed": 0}
}
```

**查询范围**: 该时段内创建的 PR/Issue + 该时段内 merged 的 PR（可能创建于更早）+ 当前 open 的 PR

**替代方案**:

- 在 skill 层用 `gh api` 命令 → 查询逻辑分散在 SKILL.md 文本中，难以测试和验证
- 用 GitHub REST API via curl → `gh` CLI 已处理认证和分页，没必要绕过

**理由**: 与 `stats.sh` 同模式——确定性脚本，JSON 输出，skill 层只做渲染。`gh` CLI 本地已认证且稳定

### D9: 云效数据收集——保持 MCP，不脚本化

**选择**: 云效数据继续由 agent 在运行时通过 MCP 工具获取，不创建脚本

**理由**:

- `aliyun devops` CLI 可靠性不足：部分操作返回 SYSTEM_UNAUTHORIZED_ERROR，参数格式复杂（JSON 数组、REST API 格式）
- yunxiao skill 的 cheatsheet 16 条 golden rules 大多是 CLI 的坑
- MCP 工具在 agent 运行时更稳定
- 如果未来 CLI 改善，可以再考虑脚本化

## Skill 创建与审查流程

### 流程总览

```
Phase 1         Phase 2        Phase 3        Phase 4           Phase 5           Phase 6
stats.sh ──▶  github.sh ──▶  SKILL.md  ──▶  diary 重构  ──▶  Skill Review  ──▶  Issue Resolution
                              + template      + 配置迁移       (skill-reviewer)    + Final Verify
```

### Phase 1: stats.sh 脚本 ✅ (已完成)

| Step | 内容 | Gate |
|------|------|------|
| 1.1 | 创建目录结构 `skills/worklog/scripts/` | 目录存在 |
| 1.2 | 实现仓库扫描：遍历 `~/code/*/` 和 `~/code/*/repos/*/` | 发现所有 git 仓库 |
| 1.3 | 实现 git 统计：`--since`/`--until` 参数，按仓库聚合 commit 数、增删行数 | 输出有效 JSON |
| 1.4 | 实现汇总统计：totals 部分（总 commit、总增删、活跃仓库数） | totals 正确 |
| 1.5 | 终端验证：`stats.sh --since <today> --until <today>` | 输出有效 JSON |

**Phase Gate**: stats.sh 输出符合 D2 定义的 JSON 结构

### Phase 2: github.sh 脚本

| Step | 内容 | Gate |
|------|------|------|
| 2.1 | 实现参数解析：`--since`/`--until`（必须）、`--username`（可选，默认 `gh api user`） | 参数正确 |
| 2.2 | 实现 PR 查询：created + merged in period + currently open | 输出 PR 列表 |
| 2.3 | 实现 Issue 查询：created in period | 输出 Issue 列表 |
| 2.4 | 实现 JSON 输出：period + prs 数组 + issues 数组 + totals | 符合 D8 结构 |
| 2.5 | 终端验证：运行 daily 和 weekly 范围，确认 JSON 输出 | 输出有效 JSON |

**Phase Gate**: github.sh 输出符合 D8 定义的 JSON 结构

### Phase 3: SKILL.md + 模板更新

| Step | 内容 | Gate |
|------|------|------|
| 3.1 | 更新 SKILL.md Step 2a：引用 github.sh 替代内联 gh api 命令 | 脚本引用正确 |
| 3.2 | 更新 SKILL.md Step 2c：补充云效 MCP 查询细节（MR/Bug/Task 的具体查询参数） | 查询逻辑完整 |
| 3.3 | 重写 `references/template.md`：叙事 + 表格混合格式，主题分组规则，MR 合并规则 | 模板符合 D5 |
| 3.4 | 自审：对照 specs 检查所有 requirement 覆盖 | 无遗漏 |

**Phase Gate**: SKILL.md + template.md 反映新的数据流和模板规范

### Phase 4: diary-assistant 重构 ✅ (已完成)

| Step | 内容 | Gate |
|------|------|------|
| 4.1 | 修改 SKILL.md：worklog 步骤改为调用 worklog skill | 引用正确 |
| 4.2 | 删除 `references/worklog-automation.md` | 文件已删除 |
| 4.3 | 修改 `references/user-config.md`：移除数据源配置 | 日记配置保留 |
| 4.4 | 更新 README.md：新增 worklog skill 到技能列表，更新依赖图 | 文档一致 |

**Phase Gate**: diary-assistant 仍能正确触发 worklog

### Phase 5: Skill Review + Issue Resolution ✅ (已完成)

调用 `skill-reviewer` 审查，流程同 code-sync change（结构校验 → 内容质量 → 兼容性审计 → 报告 → 逐项协商修复）

### Phase 6: Final Verification

| Step | 内容 | Gate |
|------|------|------|
| 6.1 | 重跑 `validate.sh` | PASS |
| 6.2 | 测试触发词隔离：「工作回顾」触发 worklog，「写日记」触发 diary | 正确触发 |
| 6.3 | 测试 daily 模式：生成当日工作回顾 | 输出完整 |
| 6.4 | 测试 weekly 模式：生成本周工作回顾 | 输出完整，含统计 |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| stats.sh 遍历 28 个仓库的 git log 耗时 | git log 是本地操作，预计 1-3 秒完成；如果仓库极大可用 `--no-merges` 减少计算 |
| 云效 API 或 gh API 不可用时 | skill 层分别 try-catch，某个数据源失败不影响其他源，输出中标注"未获取" |
| weekly 的 gh events API 分页限制（每页 100，最多 300） | 对个人开发者足够；超出时用 per-repo commits API 补充 |
| diary-assistant 调用 worklog 后格式不兼容 | worklog 输出标准 Markdown，diary 直接嵌入；D5 模板设计时已考虑嵌入场景 |
| stats.sh 统计的 author 与云效/GitHub 身份不一致 | user-config.md 统一配置用户名，stats.sh 用 `--author` 过滤 |
