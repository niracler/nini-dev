## Context

现有 `pinboard-manager` skill 提供 tag 审计和死链检测两个模式。死链检测只检查 HTTP 状态码，无法判断「链接活着但内容已过时」的情况。用户的 ~370 条 bookmark 中技术类文章占比较高，随框架版本迭代和 API 废弃，部分文章已失去参考价值。

当前 tag 体系已有 `evergreen` meta tag 标记长期有效内容，但大部分 bookmark 没有这个标记，无法区分「确认仍有效」和「未检查」。

## Goals / Non-Goals

**Goals:**

- 识别技术类 bookmark 中内容可能过时的条目
- 使用启发式筛选 + AI 分析的两阶段方案，控制成本
- 交互式展示结果，用户决定保留/删除/标记 evergreen
- 作为 `pinboard-manager` skill 的第三个模式

**Non-Goals:**

- 不做全自动清理（所有操作需用户确认）
- 不分析非技术类内容（游戏、音乐、生活类等）
- 不搜索替代文章（不做「推荐更新版本」）
- 不修改 n8n workflow

## Decisions

### D1: 两阶段筛选——启发式预筛 + AI 分析

**选择**: 先用启发式规则从全量 bookmark 中筛出候选（预计 30-50 条），再对候选逐条抓取内容做 AI 分析。

**替代方案**:

- 全量 AI 分析 → 370+ 条全部抓取并分析，成本和时间不可接受
- 纯启发式 → 只看年龄和版本号，误判率高，无法理解内容

**理由**: 启发式筛选成本为零且速度快，能排除 80%+ 的 bookmark。AI 只分析真正可疑的条目，平衡了准确度和成本。

### D2: 启发式筛选规则

**选择**: 三层过滤管道

1. **Tag 过滤**: 只保留技术类 tag（`llm`, `claude`, `programming`, `python`, `javascript`, `typescript`, `web`, `devops`, `cloudflare`, `shell`, `github`, `database`, `security`, `home_assistant`, `iot`, `zigbee`）。排除 `evergreen`/`reference`/`collection` meta tag。
2. **年龄过滤**: 保存时间超过 2 年的（使用 Pinboard 的 `time` 字段）。
3. **版本号检测**: 标题或 URL 中包含版本号模式的（如 `React 16`, `v2.x`, `Python 3.8`, `ES6`），无论年龄都标记为可疑。

**替代方案**:

- 抓取页面 `<meta>` 发布日期 → 增加一次 HTTP 请求，且很多页面没有标准化的发布日期 meta
- 只按年龄过滤 → 漏掉新收藏的旧文章

**理由**: 三层过滤互补。Tag 过滤排除非技术内容，年龄过滤找到老文章，版本号检测捕获「新收藏但文章本身就旧」的情况。

### D3: 内容抓取——Jina Reader

**选择**: 使用 Jina Reader（`r.jina.ai`）将网页转为 LLM 友好的 Markdown。

```bash
curl -s "https://r.jina.ai/https://example.com/article" | head -c 5000
```

**替代方案**:

- 直接 `curl` 抓 HTML → 噪音多（导航栏、广告、脚本），需要自己清洗
- Firecrawl → 需要 API key 和付费
- Playwright 渲染 → 太重，不适合 skill 场景

**理由**: Jina Reader 免费、零配置、返回干净 Markdown。截取前 5000 字符足够 Claude 判断文章的技术版本和时效性。

### D4: AI 分析——当前会话 Claude

**选择**: 将抓取的内容直接展示在当前会话中，由 Claude 判断时效性并给出结论。

**输出格式**:

- 时效状态: `过时` / `可能过时` / `仍然有效`
- 理由: 一句话解释（如「文章讨论 React 16 lifecycle methods，React 18+ 已推荐 hooks」）
- 建议: `删除` / `标记 evergreen` / `保留`

**替代方案**:

- 调用外部 LLM API（Anthropic API）→ 需要额外 API key 配置，增加复杂度
- 本地模型 → 不实际

**理由**: skill 本身就在 Claude Code 会话中运行，直接利用当前会话的 Claude 是最简单的方案。无需额外配置。

### D5: 分批处理策略

**选择**: 每批 5 条候选 bookmark，逐条抓取 + 分析后展示结果，用户确认后处理下一批。

**理由**: 每条需要抓取网页 + AI 分析，比 tag 审计和死链检测慢。5 条一批保持交互节奏，不会让用户等太久。Jina Reader 无官方限流，但合理间隔（`sleep 2`）避免被封。

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Jina Reader 服务不可用或被限流 | 降级为直接 `curl` 抓取 HTML，用 `<article>` 或 `<main>` 标签提取正文 |
| 抓取内容太长占用 context window | 截取前 5000 字符，技术文章开头通常包含版本信息和核心内容 |
| 启发式筛选漏掉过时文章 | 可接受——本功能定位为辅助工具，不追求 100% 覆盖 |
| 某些网站屏蔽 Jina Reader | 标记为「无法抓取」，跳过该条，不影响其他 |
| AI 判断不准确 | 所有操作需用户确认，AI 只提供建议，不自动执行 |
| 2 年阈值过于粗糙 | 版本号检测作为补充，捕获年龄不到 2 年但内容已过时的文章 |
