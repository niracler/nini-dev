## Why

n8n RSS Agent 系统的每日精选输出为英文，而预期应为中文。根因是 `profile/context.md` 的手写部分（Focus Areas、Content Preferences、Deprioritize 等）是纯英文的，这份内容作为 system prompt 注入到评分和摘要生成的 AI 调用中，再加上 RSS 文章本身以英文为主，导致 Gemini Flash Lite 模型倾向于用英文输出。同时，摘要生成的 prompt 缺少显式的中文输出约束，进一步加剧了问题。

## What Changes

- **将 `context.md` 手写部分改写为中文**：Focus Areas、Content Preferences、Current Context、Deprioritize 四个部分从英文改为中文，月度方向调整部分（已是中文）保持不变
- **强化 3 个 workflow 的 AI prompt 中文约束**：在评分、摘要、品味画像、月度回顾的 prompt 中增加显式的中文输出要求（`⚠️` 级别的硬性约束，而非括号提示）
- **将 AI 模型从 `google/gemini-2.5-flash-lite` 升级为 `google/gemini-2.5-flash`**：提升 instruction following 能力，更可靠地遵循中文输出指令。涉及 3 个 workflow 共 4 个 HTTP Request 节点
- **重新触发 taste-profile-update**：验证升级后的 prompt 和模型能正确生成中文 taste.md（当前版本已是中文，但需验证模型更换后仍然正常）

## Capabilities

### New Capabilities

<!-- 无新增 capability -->

### Modified Capabilities

- `rss-daily-digest-n8n`: 评分 prompt 和摘要 prompt 增加中文输出硬性约束；AI 模型从 Flash Lite 升级到 Flash
- `taste-profile`: 品味画像生成 prompt 强化中文约束；AI 模型升级
- `monthly-review`: 月度回顾 prompt 增加中文输出约束；AI 模型升级

## Impact

- **涉及系统**: n8n workflows（3 个：rss-daily-digest、taste-profile-update、monthly-review）+ GitHub 仓库 `niracler/rss-agent`
- **涉及仓库**: 无代码仓库变更，所有改动在 n8n UI 和 GitHub 远程仓库完成
- **成本影响**: Gemini Flash 价格约为 Flash Lite 的 2 倍（$0.15/M input vs $0.075/M），预估月成本从 ~$1.5 增至 ~$3，仍在可接受范围
- **Rollback**: n8n workflow 可通过版本历史回退；`context.md` 可通过 GitHub git history 恢复
