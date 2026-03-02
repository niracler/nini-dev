# Tasks: add-rss-ai-agent

> **流程**: Phase 1 → 2 → 3 → 4 → 5，每个 Phase 有 Gate 条件。
> **交付策略**: 非代码仓库项目，通过 n8n UI + GitHub 仓库协作完成。每个 Phase 在 n8n 中验证后继续。
>
> **实施偏差说明**（经确认为有意选择）：
> - AI 模型：使用 OpenRouter + Gemini 2.5 Flash Lite（替代原设计的 Kimi K2）
> - 投递渠道：使用企业微信 webhook（替代原设计的 Telegram）
> - RSS 抓取：使用 Code 节点 fetch()（替代原设计的 RSS Feed Read 节点，更灵活）

## Phase 1: GitHub 仓库与基础配置

- [x] 1.1 创建 GitHub 私有仓库 `rss-agent`，初始化 README
- [x] 1.2 创建 `feeds.yaml`：从现有 blogwatcher 配置迁移 RSS 订阅列表，按 design 中的格式（name/url/category/priority）
- [x] 1.3 创建 `profile/context.md`：手写第一版当前关注上下文（近期项目、兴趣方向、优先话题）
- [x] 1.4 创建 `profile/taste.md`：手写初始品味画像骨架（核心兴趣、偏好内容类型、排除话题），后续由 AI 自动更新
- [x] 1.5 创建目录结构：`profile/history/`、`output/daily/`
- [x] 1.6 在 n8n 中配置 GitHub Access Token credential（PAT，scope: repo）

**Gate**: ✅ n8n GitHub 节点可成功读取私有仓库中的 `feeds.yaml` 和 `profile/taste.md`

## Phase 2: AI API 集成与评分验证（实际使用 OpenRouter + Gemini）

- [x] 2.1 在 n8n 中配置 AI API credential（Bearer Auth，OpenRouter API key）
- [x] 2.2 创建测试 workflow `rss-scoring-test`：手动 trigger → HTTP Request 调用 Gemini chat/completions → 验证响应格式
- [x] 2.3 设计评分 prompt：system prompt 模板（注入 taste.md + context.md），user prompt 模板（文章标题+摘要+来源），要求输出 JSON（score/reason/category）
- [x] 2.4 用 3-5 篇已知文章测试评分质量：验证高兴趣文章得高分、无关文章得低分、分数分布合理
- [x] 2.5 调优 prompt 直到评分结果与人工判断基本一致

**Gate**: ✅ AI API 稳定返回 JSON 评分结果，评分质量可接受

## Phase 3: 每日精选 Workflow

- [x] 3.1 创建 n8n workflow `rss-daily-digest`，添加 Schedule Trigger（每日 06:00）
- [x] 3.2 添加 GitHub 节点读取 `feeds.yaml`，Code 节点解析 YAML 为 feed URL 列表
- [x] 3.3 添加 GitHub 节点读取 `profile/taste.md` 和 `profile/context.md`，拼接为 system prompt
- [x] 3.4 添加 Code 节点用 fetch() 并行抓取 RSS（10 并发，10s 超时），解析 XML 提取文章
- [x] 3.5 添加 Code 节点：合并所有 feed 结果，提取 title/description/url/pubDate，过滤 24h 内文章
- [x] 3.6 添加 Code 节点：去重逻辑——对比 staticData 中最近 7 天已推送 URL，排除重复
- [x] 3.7 添加 HTTP Request 节点调用 Gemini 逐篇评分（循环处理每篇文章）
- [x] 3.8 添加 Code 节点：按 score 排序，同源不超过 2 篇，取 Top 7（4 核心 + 3 探索）
- [x] 3.9 添加 HTTP Request 节点调用 Gemini 为 Top 7 生成摘要 + 关联分析
- [x] 3.10 添加 Code 节点：格式化企业微信 markdown 消息
- [x] 3.11 添加 HTTP Request 节点投递到企业微信 webhook
- [x] 3.12 添加 GitHub 节点：Create file `output/daily/YYYY-MM-DD.md` 写回每日精选存档
- [x] 3.13 添加 Code 节点：更新 staticData 中的已推送 URL 列表（保留最近 7 天）
- [x] 3.14 手动触发全流程测试，验证从抓取到投递到存档的完整链路

**Gate**: 手动触发 workflow 成功完成全流程——企业微信收到 7 篇精选，GitHub 仓库出现当日 daily 文件

## Phase 4: 品味画像自动更新

- [x] 4.1 在每日 workflow 中添加副路径：Pinboard `/posts/update` 检查变更时间
- [x] 4.2 添加 Code 节点：对比 staticData 中记录的上次 profile 更新时间，判断是否有变化
- [x] 4.3 添加 IF 节点：变化时获取最近 30 条书签，新增 >= 10 时触发 profile 更新路径
- [x] 4.4 创建 sub-workflow `taste-profile-update`：Pinboard `/posts/all` 拉取近期书签 → Gemini 分析兴趣模式 → GitHub Edit/Create 更新 `profile/taste.md`
- [x] 4.5 设计 profile 生成 prompt：输入 Pinboard 书签（标题+tags+extended+信号类型）+ 输出结构化品味画像
- [x] 4.6 测试冷启动场景：删除 taste.md，触发 profile 生成，验证从 Pinboard 全量数据生成初始画像
- [x] 4.7 测试增量更新场景：添加几条 Pinboard 书签，验证 profile 更新反映新兴趣

**Gate**: Pinboard 新增书签后，taste.md 自动更新且 commit message 包含触发原因

## Phase 5: 月度回顾

- [x] 5.1 创建 n8n workflow `monthly-review`，添加 Schedule Trigger（每月 1 号 08:00）
- [x] 5.2 添加 GitHub 节点：生成过去 30 天的日期路径，逐个读取 `output/daily/*.md`
- [x] 5.3 添加 Code 节点：预处理压缩——提取每篇的标题、分数、一句话理由、类别，生成摘要列表
- [x] 5.4 设计月度分析 prompt：输入压缩后的 30 天数据 + taste.md + context.md，输出三维度分析（知识变化/决策影响/趋势发现）+ 阅读方向调整建议，要求反思性中文写作风格
- [x] 5.5 添加 HTTP Request 节点调用 Gemini 生成月度回顾长文
- [x] 5.6 添加 GitHub 节点：Create file `profile/history/YYYY-MM.md`
- [x] 5.7 添加 Code 节点：提取月度回顾中的「阅读方向调整」，追加到 `profile/context.md`
- [x] 5.8 添加 HTTP Request 节点：投递精简版月度回顾到企业微信
- [x] 5.9 用过去积累的 daily 数据手动测试全流程

**Gate**: 月度回顾文件成功写入 GitHub，企业微信收到摘要，context.md 更新了阅读方向调整
