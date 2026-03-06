## Why

Pinboard 中收藏的技术类文章会随时间失去时效性——框架版本迭代、API 废弃、最佳实践更新。现有的 `pinboard-manager` skill 只能检测死链（HTTP 状态码），无法判断内容本身是否过时。用户需要一种方式识别「链接活着但内容已过时」的 bookmark，避免将过时资料当作有效参考。

## What Changes

- **扩展 `pinboard-manager` skill**：新增「时效性检测」模式
  - 启发式筛选：按 tag 类型过滤技术类 bookmark → 按保存/发布时间过滤老文章 → 按标题/URL 中的版本号标记可疑项
  - AI 分析：通过 Jina Reader（`r.jina.ai`）抓取页面内容 → 当前会话 Claude 判断时效性
  - 分批展示结果，用户决定保留/删除/标记 evergreen
- **不修改** n8n workflow（本次只涉及 skill 部分）

**涉及仓库**: `repos/skill`（pinboard-manager skill）

## Capabilities

### New Capabilities

- `pinboard-timeliness`: Pinboard bookmark 内容时效性检测，包含启发式预筛选和 AI 内容分析

### Modified Capabilities

- `pinboard-manager`: 新增时效性检测模式入口（SKILL.md 增加第三个模式）

## Impact

- **修改**: `repos/skill/skills/workflow/pinboard-manager/SKILL.md`（新增 timeliness check 模式）
- **触发词**: `pinboard 检查时效` / `pinboard timeliness check` / `pinboard 过时检测`
- **依赖**: Jina Reader（`r.jina.ai`，免费，无需 API key）、Pinboard API、当前会话 Claude
- **Rollback**: 从 SKILL.md 中移除 timeliness check 相关 section
