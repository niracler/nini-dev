# Change: Refine MCP Slide Visual Design

## Why

当前 MCP 页面右侧直接放置了一张信息密集的长图（来自 @knowledgefxg），图片字小、内容多，演示效果差。图片内容与左侧文案有重复，且无法在演示时清晰传达。需要将图片中的核心知识点融入页面设计，提升信息传达效率。

## What Changes

- 移除右侧外部图片，改用 `layout: default` 或 `layout: two-cols`
- 将图片中的核心知识点（问题 → 解决方案 → 工作流程）融入页面
- 新增一个简洁的 Mermaid 序列图，展示 MCP 实际工作流程（用户 → Claude → MCP Server → GitHub）
- 保留现有的 USB-C 比喻、架构说明、三大 Primitives、时间线
- 保留所有脚注引用

## Impact

- Affected specs: `slidev-presentation`
- Affected code: `repos/ai-programming-share/slides.md` (MCP 页面，约第 1035-1087 行)
- 页面数量：保持 1 页不变
