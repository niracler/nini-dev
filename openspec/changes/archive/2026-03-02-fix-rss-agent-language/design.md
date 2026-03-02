## Context

n8n RSS Agent 系统包含 3 个 workflow（rss-daily-digest、taste-profile-update、monthly-review），均使用 OpenRouter 调用 `google/gemini-2.5-flash-lite` 模型。当前每日精选输出为英文，根因已确认：

1. `profile/context.md` 的手写部分（Focus Areas、Content Preferences 等）是纯英文
2. 摘要生成 prompt 缺少显式中文输出约束
3. Gemini Flash Lite 的 instruction following 较弱，输入数据为英文时倾向英文输出

涉及的 n8n 节点（explore 阶段已完整审查）：

| Workflow | 节点 | 用途 | 语言问题 |
|----------|------|------|----------|
| rss-daily-digest | `prepare-data` | 构建评分 system prompt | reason 字段中文约束太弱（只在括号里提了） |
| rss-daily-digest | `collect-select` | 构建摘要 prompt | 完全没有语言约束 |
| rss-daily-digest | `score-article` | HTTP Request 调用 AI | 模型需升级 |
| rss-daily-digest | `gen-summaries` | HTTP Request 调用 AI | 模型需升级 |
| taste-profile-update | `Build Prompt` | 构建画像生成 prompt | 中文约束在末尾，位置弱 |
| taste-profile-update | `Generate Profile` | HTTP Request 调用 AI | 模型需升级 |
| monthly-review | `Compress & Build Prompt` | 构建月度回顾 prompt | 已有中文约束，需加强 |
| monthly-review | `Generate Review` | HTTP Request 调用 AI | 模型需升级 |

## Goals / Non-Goals

**Goals:**

- 所有面向用户的 AI 输出（评分理由、摘要、关联分析、品味画像、月度回顾）为中文
- `context.md` 手写部分改为中文，消除上游语言污染源
- 模型升级到 instruction following 更好的版本，提升中文输出可靠性
- 改动后重新触发 taste-profile-update 验证效果

**Non-Goals:**

- 不重构 workflow 结构或节点编排
- 不修改评分逻辑、选择算法或投递格式
- 不更换 AI provider（仍使用 OpenRouter）
- 不修改 `category` 字段语言（设计上保持英文，如 `ai-tooling`）

## Decisions

### 1. 模型选择：Gemini 2.5 Flash

**决定：** 从 `google/gemini-2.5-flash-lite` 升级到 `google/gemini-2.5-flash`

**原因：**

- 同系列升级，API 调用方式完全不变（只改 model 字符串）
- Instruction following 显著提升，中文输出约束更可靠
- 成本从 ~$1.5/月 增至 ~$3/月，仍在可接受范围
- 不需要调整 temperature、timeout 等参数

**备选方案：**

- `openai/gpt-4o-mini`：instruction following 也好，但切换 provider 可能引入响应格式差异
- `anthropic/claude-haiku-4-5`：中文能力最好，但价格 $0.80/M input 是 Flash 的 5 倍，月成本会到 ~$15
- 保持 Flash Lite 只强化 prompt：能缓解但不能根治，Lite 的 instruction following 本身就弱

### 2. context.md 改写策略

**决定：** 手写部分翻译为中文，保持结构不变，月度方向调整部分（已是中文）不动

**改写范围：**

```
# Focus Areas          → # 关注领域
## Core Interests      → ## 核心兴趣
## Content Preferences → ## 内容偏好
## Current Context     → ## 当前关注 (2026-02)
## Deprioritize        → ## 降低优先级
## 月度方向调整        → （保持不变）
```

**原因：** context.md 作为 system prompt 注入，其语言直接影响模型输出语言。翻译为中文是消除根因的最直接方式。

### 3. Prompt 强化策略：前置 + 强调

**决定：** 在每个 AI 调用的 system prompt 中，将语言约束放在**靠前位置**并使用 `⚠️` 标记

**模式：**

```
system prompt 结构:
  1. 角色定义（一句话）
  2. ⚠️ 语言约束（硬性规则）     ← 新增/前移
  3. 用户画像/上下文内容
  4. 输出格式要求
  5. 其他规则
```

**原因：** 语言约束放在末尾容易被模型忽略（尤其是 context window 较长时）。前置 + 强调记号（⚠️）是 prompt engineering 的常见最佳实践。

### 4. 具体 prompt 变更

**rss-daily-digest / prepare-data（评分 system prompt）：**

```diff
  const systemPrompt = [
    '你是一个 RSS 文章相关度评分助手。...',
+   '',
+   '⚠️ 语言要求：reason 字段必须使用中文撰写，即使原文是英文。',
    '',
    '## 品味画像', tasteContent,
    ...
    '## 评分规则',
    '- score: 0-100 整数',
-   '- reason: 一句话说明评分理由（中文）',
+   '- reason: 一句话说明评分理由',
    ...
  ]
```

**rss-daily-digest / collect-select（摘要 prompt）：**

```diff
- const sysP = '你是一个 RSS 文章摘要助手。为用户生成文章摘要和个性化关联分析。\n\n## 用户画像\n' + ...
+ const sysP = '你是一个 RSS 文章摘要助手。为用户生成文章摘要和个性化关联分析。\n\n⚠️ 语言要求：所有摘要和关联分析必须使用中文撰写，即使原文是英文。\n\n## 用户画像\n' + ...
```

```diff
- const userP = '为以下 ' + N + ' 篇文章各生成：\n1. 3-5 句深度摘要...\n2. 「与你的关联」分析...'
+ const userP = '为以下 ' + N + ' 篇文章各生成：\n1. 3-5 句中文深度摘要（即使原文是英文也必须用中文）\n2. 「与你的关联」中文分析（1-2 句）\n\n⚠️ 所有输出必须使用中文。\n\n...'
```

**taste-profile-update / Build Prompt（品味画像 prompt）：**

```diff
  const systemPrompt = [
    '你是一个用户兴趣分析专家。...',
+   '',
+   '⚠️ 语言要求：整份品味画像必须用中文撰写。书签标题可能是英文，但分析和描述必须全部使用中文。',
    '',
    '## 行为信号说明',
    ...
-   '用中文撰写品味画像。要具体、数据驱动。'
+   '再次强调：用中文撰写，要具体、数据驱动，不要出现英文段落。'
  ]
```

**monthly-review / Compress & Build Prompt（月度回顾 prompt）：**

```diff
- const systemPrompt = '你是一个个人阅读回顾分析师。基于用户过去一个月的 RSS 阅读数据...'
+ const systemPrompt = '你是一个个人阅读回顾分析师。基于用户过去一个月的 RSS 阅读数据...\n\n⚠️ 语言要求：所有输出必须使用中文。\n\n## 输出要求...'
```

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Gemini Flash 响应速度比 Lite 慢 | 每日 workflow 执行时间可能从 ~3min 增至 ~5min | 可接受，Schedule trigger 时间宽裕 |
| Flash 模型 JSON 输出格式可能与 Lite 略有差异 | 评分 JSON 解析失败 | 现有 Code 节点已有 JSON parse fallback（try-catch），且 Flash 的结构化输出能力更好 |
| context.md 翻译后与月度方向调整（中文）混排 | 无实际风险 | 月度方向调整本来就是中文，统一后更自然 |
| 月成本翻倍（~$1.5 → ~$3） | 成本增加但仍很低 | 仍远低于最初设计的 $1/月上限的 3 倍 |
