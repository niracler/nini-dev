## Context

Obsidian Note 仓库（`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Note/`）包含 ~150 篇 Markdown 笔记，分布在 `Areas/`（按主题分类）、`Inbox/`（待归类）、`Archives/`（归档）三个目录。bokushi 博客有 3 个 content collection：`blog/`（长文随笔）、`til/`（技术笔记）、`monthly/`（周/月记），共享 frontmatter schema（title, pubDate, tags, description, socialImage, hidden）。

Claude Code session 数据存储在 `~/.claude/projects/<project-path>/sessions-index.json`（含 summary 和 firstPrompt）和 `~/.claude/history.jsonl`（含用户输入的 prompt）。

现有 `repos/skill/` 使用 `skills/<name>/SKILL.md` + 可选 `references/` 的结构。

## Goals / Non-Goals

**Goals:**

- 每周运行一次，交互式选出一篇 Note → 转换为博客草稿（`hidden: true`）
- 利用 LLM 做语义去重（与已发布博文对比）和适配性评估
- 利用近 30 天 session 活跃信号给候选笔记加分
- 支持批量标记 skip/published，状态持久化到 `.note-to-blog.json`
- Obsidian 特有语法自动转换为标准 Markdown
- LLM 自动判断目标 collection（blog/til/monthly）
- 草稿生成后可单独运行 `/writing-proofreading` 审校

**Non-Goals:**

- 不做全自动发布（始终需要用户交互确认）
- 不做 embedding 向量索引（语义判断由 LLM 直接完成）
- 不修改 Note 仓库中的原始文件（标记存储在独立 JSON）
- 不处理图片上传/迁移（保留原始图片 URL）
- 不替代 writing-inspiration（本 skill 是「选题」，不是「从零创作」）

## Decisions

### D1: 候选扫描——全量扫描 + 标记过滤

**选择**: 扫描 Note 仓库全部 `*.md`，仅排除 `.note-to-blog.json` 中已标记的条目

**替代方案**:

- 规则预筛（按目录/字数排除） → 可能误排真正好的文章（用户明确反对）
- 只扫描 `Areas/` → 遗漏 `Inbox/` 和 `Archives/` 中有价值的内容

**理由**: 用户希望全量扫描、主动标记。首次运行时候选较多，但随着每周运行积累 skip/published 标记，候选池会逐渐收敛

### D2: LLM 评估——摘要输入 + 一次调用

**选择**: 取每篇候选的标题 + 前 20 行作为摘要，连同已发布列表和 session 信号，一次 LLM 调用完成评估

**替代方案**:

- 逐篇调用 LLM → 太慢，~100 篇需要 ~100 次调用
- 全文输入 → context 不够，~150 篇全文远超 token 限制

**理由**: 标题 + 前 20 行足以判断主题、完成度和风格。一次调用输出 JSON 格式的 Top 5~8 推荐列表，高效且可解析

### D3: Session 活跃度信号——轻量提取

**选择**: 从 `sessions-index.json` 提取近 30 天 session 的 `summary` + `firstPrompt`，从 `history.jsonl` 提取同期 `display` 字段，作为关键词列表传给 LLM

**替代方案**:

- 解析完整 session jsonl 文件 → 文件巨大（几 MB 到几十 MB），包含大量工具调用噪声
- 不用 session 数据 → 丢失「用户近期在关注什么」的重要信号

**理由**: summary/firstPrompt/display 是已浓缩的意图表达，足够用于语义匹配，且提取成本极低

### D4: 标记存储——Note 仓库根目录 `.note-to-blog.json`

**选择**: 在 Note 仓库根目录存储，使用相对路径作为 key

```json
{
  "published": {
    "Areas/杂谈(Essay)/原生家庭那些事.md": {
      "target": "blog/original-family-matters.md",
      "date": "2024-03-15"
    }
  },
  "skipped": {
    "Areas/人物志(Personal)/他人/黄盛涛.md": {
      "reason": "private",
      "date": "2026-02-07"
    }
  }
}
```

**替代方案**:

- 改 Note 文件的 frontmatter → 侵入 Obsidian 笔记，用户不希望
- 放 nini-dev 根目录 → 跟 Note 仓库弱耦合
- 放 `~/.claude/` → 换机器时丢失

**理由**: 标记本质上是 Note 仓库的元数据，放在 Note 仓库随 git 同步最合理

### D5: 目标 collection 判断——LLM 在评估阶段决定

**选择**: Phase 2 的 LLM 评估同时输出推荐的目标 collection（blog/til/monthly）

**判断依据（写入 scoring-criteria.md 供 LLM 参考）**:

| 类型 | 特征 | 目标 |
|------|------|------|
| 技术笔记 | 教程、TIL、配置指南、单一技术点 | `til/` |
| 长文随笔 | 观点文章、评论、生活感悟、作品评测 | `blog/` |
| 周/月记 | 时间段的生活记录、复盘 | `monthly/` |

**理由**: 用户表示交由 LLM 决定。Phase 3 交互时用户仍可覆盖

### D6: Phase 4 改写程度——轻改写 + 草稿机制

**选择**: 格式转换 + frontmatter 生成 + 基本可读性修复，输出时设 `hidden: true`，深度审校交给后续独立运行的 `/writing-proofreading`

**替代方案**:

- 一次跑完（转换 + 6 步审校） → 流程太长（30~45 min），容易让人懈怠
- 只做格式转换不做任何修复 → 有些文章结构太碎片化，直接转换可读性差

**理由**: 拆分成两次短流程（各 15~20 min）更符合每周一篇的节奏。`hidden: true` 是 bokushi schema 已支持的功能，天然适合草稿

### D7: Obsidian 语法转换规则

| Obsidian 语法 | 转换结果 |
|---------------|----------|
| `![[image.png]]` | `![](image-url)` — 保留原始 URL 不变 |
| `![[image.png\|400]]` | `![](image-url)` — 去掉尺寸参数 |
| `[[wikilink]]` | 纯文本（去掉双括号） |
| `[[wikilink\|display]]` | display 文本 |
| `:span[text]{.spoiler}` | `<span class="spoiler">text</span>` |
| `> [!note]` callout | `> **Note:** ...` blockquote |
| Obsidian frontmatter (`aliases`, `date`, `modified`) | 转换为 bokushi frontmatter（`title`, `pubDate`, `tags` 等） |
| `#tag` 行内标签 | 移除或收集到 frontmatter tags |

## Skill 创建与审查流程

### 流程总览

```
Phase 1        Phase 2         Phase 3          Phase 4          Phase 5
SKILL.md ──▶  References ──▶  Skill Review ──▶ Issue Resolution ──▶ Final
                               (skill-reviewer)  (用户协商)       Verification
```

### Phase 1: SKILL.md 编写

| Step | 内容 | Gate |
|------|------|------|
| 1.1 | 创建目录结构 `skills/note-to-blog/references/` | 目录存在 |
| 1.2 | 研究现有 skill 模式：阅读 `diary-assistant` 和 `worklog` 的 SKILL.md | 了解多数据源整合、交互式流程写法 |
| 1.3 | 编写 frontmatter：name + description（CSO 规范） | frontmatter 合规 |
| 1.4 | 编写 Phase 1~4 完整工作流 | 流程完整 |
| 1.5 | 编写交互式选择的指引（推荐列表展示、批量标记、确认） | 交互逻辑完整 |
| 1.6 | 自审：对照 specs 检查 requirement 覆盖 | 无遗漏 |

### Phase 2: References 编写

| Step | 内容 | Gate |
|------|------|------|
| 2.1 | `user-config.md`：Note 路径、Blog 路径、Session 数据路径、项目路径映射 | 路径可配置 |
| 2.2 | `obsidian-conversion.md`：D7 定义的全部转换规则 + 示例 | 规则完整 |
| 2.3 | `scoring-criteria.md`：LLM 评估 prompt 模板、评分维度、session 加分规则、collection 判断规则 | prompt 可用 |

### Phase 3~5: 同 code-sync 的审查流程

调用 `skill-reviewer` → 逐项与用户协商 → 最终验证

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| 首次运行候选太多（~150 篇），LLM 输入过长 | 每篇只取标题 + 前 20 行（约 5~10 行实际内容），~150 篇预估 ~8K tokens，可控 |
| session 数据路径因项目不同而变化 | user-config.md 中配置项目路径映射，skill 启动时验证路径存在性 |
| `.note-to-blog.json` 与 Note 仓库 git 冲突 | 文件结构简单（flat JSON），冲突概率极低；加入 `.gitignore` 也可以 |
| Obsidian 语法转换遗漏 | obsidian-conversion.md 中列出已知规则，遇到未覆盖语法时保留原文并警告 |
| 生成的草稿质量参差不齐 | 默认 `hidden: true`，必须经过 writing-proofreading 审校才发布 |
| skill-reviewer 发现大量问题 | Phase 4 逐项与用户协商，Medium/Low 可批量跳过 |
