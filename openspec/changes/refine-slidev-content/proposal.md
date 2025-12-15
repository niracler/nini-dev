# Change: Slidev 内容精修重构

## Why

初版 PPT 已完成（37 页），但存在以下问题：

1. **概念与实践割裂** — Part 2 纯讲概念，Part 4 才讲实践，听众难以建立联系
2. **缺少演讲节奏标注** — 演讲者不知道哪些是重点、哪些可快速带过
3. **脚注缺少推荐标记** — 优质原文资料没有突出标识
4. **页数偏多** — 37 页需要精简到 30 页，部分纯文字页需重新设计
5. **缺少实操内容** — 没有 Best Practice 页面展示 Prompt → OpenSpec → Skill 工作流

## What Changes

### 新增能力

- **页面类型标注** — 在 speaker notes 中标注「🔴 重点」「⚡ 快速带过」「💻 Coding 演示」
- **脚注推荐标记** — 强烈推荐阅读的原文脚注加 ⭐ 标识
- **Best Practice 页** — 新增一页展示 Prompt → OpenSpec → Skill 实操流程
- **工具安利融入** — MCP、Skill、AI 前沿资讯融入对应概念页的脚注或补充说明

### 修改约束

- **BREAKING** 页数上限从 50 页降至 30 页
- 纯文字页必须按精修流程重新设计（已有约束，执行层面强化）

### 精修流程

每页 Review 时增加：
1. 确定页面类型标注
2. 检查脚注是否需要 ⭐
3. 考虑是否可与相邻页合并

## Impact

- Affected specs: `slidev-presentation`
- Affected code: `repos/ai-programming-share/slides.md`
- 预期从 37 页精简到 ≤30 页
