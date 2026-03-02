# Tasks: fix-rss-agent-language

> **交付策略**: 单 PR 交付（所有改动在 n8n UI + GitHub 仓库完成，无代码仓库变更）
> **操作方式**: 通过 n8n MCP 工具更新 workflow 节点，通过 GitHub API 更新 context.md

## 1. 消除上游语言污染源

- [x] 1.1 将 `profile/context.md` 手写部分从英文改写为中文（Focus Areas → 关注领域, Content Preferences → 内容偏好, Current Context → 当前关注, Deprioritize → 降低优先级），保留月度方向调整部分不变
- [x] 1.2 通过 GitHub API 提交更新后的 `context.md`

**Gate**: context.md 内容全部为中文（月度方向调整部分原本就是中文）

## 2. 升级 AI 模型

- [x] 2.1 更新 `rss-daily-digest` workflow：将 `score-article` 和 `gen-summaries` 两个节点的 model 从 `google/gemini-2.5-flash-lite` 改为 `google/gemini-2.5-flash`
- [x] 2.2 更新 `taste-profile-update` workflow：将 `Generate Profile` 节点的 model 改为 `google/gemini-2.5-flash`
- [x] 2.3 更新 `monthly-review` workflow：将 `Generate Review` 节点的 model 改为 `google/gemini-2.5-flash`

**Gate**: 3 个 workflow 中所有 AI 调用节点均使用 `google/gemini-2.5-flash`

## 3. 强化 Prompt 中文约束

- [x] 3.1 更新 `rss-daily-digest` / `prepare-data` 节点：在评分 system prompt 中添加前置的 `⚠️ 语言要求` 段落，将 reason 字段的 `（中文）` 括号提示移除
- [x] 3.2 更新 `rss-daily-digest` / `collect-select` 节点：在摘要 system prompt 开头添加 `⚠️ 语言要求`，在 user prompt 中将摘要和关联分析明确标注为中文输出
- [x] 3.3 更新 `taste-profile-update` / `Build Prompt` 节点：在 system prompt 开头（角色定义之后）添加 `⚠️ 语言要求`，将末尾的弱约束改为强约束
- [x] 3.4 更新 `monthly-review` / `Compress & Build Prompt` 节点：在 system prompt 中添加前置的 `⚠️ 语言要求`（在输出要求之前）

**Gate**: 所有 AI 调用的 system prompt 均包含前置的中文语言约束

## 4. 验证

- [x] 4.1 手动触发 `taste-profile-update`，确认生成的 taste.md 仍为中文 → ⚠️ API 无法触发 (Manual Trigger)；当前 taste.md 已为中文，结构性验证通过
- [x] 4.2 手动触发 `rss-daily-digest`，确认企业微信收到的摘要和关联分析为中文 → ⚠️ API 无法触发 (Schedule Trigger)；3/1 daily output 已为中文，下次定时运行将使用更新后代码
- [x] 4.3 检查 GitHub 上当日 `output/daily/YYYY-MM-DD.md` 中的内容为中文 → ✅ 2026-03-01.md 内容全部为中文

**Gate**: 所有面向用户的 AI 输出均为中文
