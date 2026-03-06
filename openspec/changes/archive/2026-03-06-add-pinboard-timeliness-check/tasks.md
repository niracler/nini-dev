# Tasks: add-pinboard-timeliness-check

> **流程**: Phase 1 → 2 → 3 → 4，单 PR 交付（仅修改 `repos/skill`）。
> **范围**: 仅修改 SKILL.md，新增第三个模式（Timeliness Check），不涉及 n8n workflow。

## 1. SKILL.md 模式入口

- [x] 1.1 在 Mode Selection 表格中新增 timeliness check 行：触发词「pinboard 检查时效」「pinboard timeliness check」「pinboard 过时检测」
- [x] 1.2 在 SKILL.md description frontmatter 中追加 timeliness 相关触发词

**Gate**: Mode Selection 表格包含三个模式

## 2. Timeliness Check 模式实现

- [x] 2.1 新增 `## Timeliness Check Mode` section，包含 Overview 说明（两阶段：启发式预筛 + AI 分析）
- [x] 2.2 实现 Step 1: Fetch all bookmarks（复用已有的 `/posts/all` 缓存到 `/tmp/pinboard_all.json`）
- [x] 2.3 实现 Step 2: Heuristic pre-filtering，包含三层过滤管道：
  - Tag 过滤：只保留技术类 tag（`llm`, `programming`, `python`, `javascript`, `typescript`, `web`, `devops`, `cloudflare`, `shell`, `github`, `database`, `security`, `home_assistant`, `iot`, `zigbee`），排除 `evergreen`/`reference`/`collection`
  - 年龄过滤：保存时间超过 2 年（基于 Pinboard `time` 字段）
  - 版本号检测：标题或 URL 含版本号模式（如 `React 16`, `v2.x`, `Python 3.8`, `ES6`），无论年龄
  - 候选条件：Tag 过滤 AND (年龄过滤 OR 版本号检测)
- [x] 2.4 实现 Step 3: Content fetching via Jina Reader，包含：
  - 抓取命令 `curl -s "https://r.jina.ai/URL"`，截取前 5000 字符
  - 抓取失败处理（标记「无法抓取」，跳过）
  - 请求间隔 `sleep 2`
- [x] 2.5 实现 Step 4: AI timeliness analysis，定义输出格式：
  - Status: `outdated` / `possibly_outdated` / `still_valid`
  - Reason: 一句话解释
  - Suggestion: `delete` / `mark_evergreen` / `keep`
- [x] 2.6 实现 Step 5: Batch presentation（每批 5 条），包含：
  - 展示格式（标题、URL、tags、AI 状态、理由、建议）
  - 用户操作选项：confirm suggestions / modify individual / skip all
- [x] 2.7 实现 Step 6: Apply user actions，包含：
  - 删除：`/posts/delete` API
  - 标记 evergreen：`/posts/add` API 追加 `evergreen` tag（保留所有原有字段）
  - 跳过：不做操作
- [x] 2.8 实现 Step 7: Summary（总候选数、outdated 删除/保留、evergreen 标记数、跳过数）

**Gate**: Timeliness Check Mode 覆盖 spec 中所有 4 个 requirement 和 14 个 scenario

## 3. Skill Review

- [x] 3.1 自审：对照 specs/pinboard-timeliness/spec.md 检查所有 requirement 和 scenario 覆盖
- [x] 3.2 自审：对照 specs/pinboard-manager/spec.md 检查 mode entry 修改是否完整
- [x] 3.3 确认 SKILL.md 无 markdownlint 问题（MD022 标题前后空行、MD032 列表前后空行）

**Gate**: 所有 spec requirement 和 scenario 已覆盖，格式合规

## 4. Final Verification

- [x] 4.1 新会话测试：触发 "pinboard 检查时效"，确认能运行启发式筛选并报告候选数
- [x] 4.2 新会话测试：确认 Jina Reader 抓取 + AI 分析流程正常，分批展示结果
- [x] 4.3 新会话测试：确认删除、标记 evergreen、跳过操作正确执行
