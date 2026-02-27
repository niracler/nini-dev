## Why

RSS 订阅源存在「量-质不匹配」问题：高频源（如 Hacker News、微博热搜）每天产出数十到上百篇内容，但真正值得阅读的不到 10%。当前的粗暴做法是直接取关超过 50 条/周的源，导致错过高质量内容。现有 `rss-daily-digest` Claude Code skill 虽然能做每日精选，但依赖 Claude Code 运行时且成本较高，无法全自动 cron 运行。

需要一个基于 n8n + 廉价 LLM（Kimi K2）的自动化资讯 Agent，能根据个人品味画像（Taste Profile）从 RSS 全量内容中筛选每日 7 篇精选，并通过 Telegram 投递。品味画像基于 Pinboard 收藏行为自动生成和更新。每月生成一篇反思性长文，分析过去一个月阅读内容的长期影响和趋势。

## What Changes

- **新增 GitHub 私有仓库结构**: 存储 RSS 订阅列表、品味画像（Taste Profile）、每日精选输出、月度分析报告
- **新增 n8n workflow — 每日精选**: Schedule trigger → 从 GitHub 拉取 feeds 列表和 taste profile → RSS 抓取 → Kimi K2 逐篇评分 → 取 Top 7 → 生成摘要 → Telegram 投递 → 写回 GitHub
- **新增 n8n workflow — 品味画像更新**: 事件驱动（Pinboard 新增 N 条书签触发）→ 拉取 Pinboard 近期书签 + 近期推送记录 → Kimi 分析兴趣模式 → 更新 GitHub 上的 taste profile
- **新增 n8n workflow — 月度分析**: 每月 1 号触发 → 汇总过去 30 天的每日精选 → Kimi 生成反思性长文（知识体系变化、决策影响、趋势发现）→ 写回 GitHub + Telegram 投递

### 核心设计决策

| 决策 | 选择 | 理由 |
|------|------|------|
| 编排引擎 | n8n (self-hosted) | 已有实例，可视化 workflow，丰富集成，cron 原生支持 |
| AI 模型 | Kimi K2 (Moonshot) | 便宜够用（$0.39/M input，自动缓存 $0.15/M），OpenAI SDK 兼容 |
| 配置存储 | GitHub 私有仓库 | 版本控制、透明变更历史、n8n GitHub 节点原生支持读写 |
| 品味学习 | 方案 B（Pinboard 行为自动提取） | Pinboard 有现成 API 和 n8n workflow，书签自带 tags 信息密度高 |
| 投递渠道 | Telegram | 与现有 n8n workflow 一致，已有 bot credentials |
| 月度分析风格 | 反思性长文 | 参照 niracler.com/feed-reading-posture 的阅读哲学 |

## Capabilities

### New Capabilities

- `rss-daily-digest-n8n`: n8n 每日 RSS 精选 workflow——从订阅源抓取内容、基于品味画像 AI 评分、筛选 Top 7、生成摘要与个人关联分析、Telegram 投递、写回 GitHub 存档
- `taste-profile`: 品味画像管理——基于 Pinboard 收藏行为（star/toread→read）自动提取兴趣模式，事件驱动更新，作为 system prompt 注入每日评分
- `monthly-review`: 月度阅读回顾——汇总 30 天推送记录，分析知识体系变化、决策影响和趋势发现，生成反思性长文

### Modified Capabilities

<!-- 无需修改现有 capability。现有 rss-daily-digest Claude Code skill 保持不变，两者并行运行 -->

## Impact

- **新建仓库**: GitHub 私有仓库（暂定 `rss-agent`），包含 feeds 配置、taste profile、每日/月度输出
- **新增 n8n workflows**: 3 个（每日精选、品味更新、月度分析）
- **依赖服务**: n8n 实例（已有）、Kimi/Moonshot API token、Pinboard API token（已有）、GitHub PAT（已有）、Telegram Bot（已有）
- **涉及 n8n credentials**: GitHub Access Token、Kimi API（OpenAI 兼容格式）、Pinboard Query Auth（已有）、Telegram Bot（已有）
- **预估成本**: Kimi API ~$0.64/月（每日 50 篇评分 + 7 篇摘要），几乎可忽略
- **与现有系统关系**: 与 `rss-daily-digest` Claude Code skill 并行，不互相依赖；复用现有 pinboard n8n workflow 的 credentials
- **Rollback**: 删除 n8n workflows + GitHub 仓库即可，不影响任何现有系统
