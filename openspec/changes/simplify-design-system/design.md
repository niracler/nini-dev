# Design: Simplify Design System

## Context

bokushi 博客是通过 vibe-coding 搭建的，设计文档 `design-primitives.md` 记录了所有设计决策，但随着时间推移：

- 文档积累了大量实现细节和一次性记录
- "待重构"章节列出了许多改进想法，但很多是过度设计
- 现有 design-system spec 承诺了过多抽象组件

用户明确表示：没有前端经验，希望设计尽可能简洁有效。

## Goals / Non-Goals

### Goals

- 将 design-primitives.md 精简为可维护的设计规范（~400 行）
- 统一现有 token 的使用方式，消除不一致
- 从 spec 中移除过度设计的需求，降低未来实现负担

### Non-Goals

- 不新增抽象组件（Button、Drawer、Image 等）
- 不进行大规模重构
- 不改变视觉设计本身

## Decisions

### Decision 1: Token 使用统一模式

**选择**：优先使用 Tailwind utility class（`text-primary`），而非 bracket notation（`text-[var(--color-text-primary)]`）

**理由**：

- Tailwind utility 更简洁，IDE 自动补全更好
- 现有 `tailwind.config.mjs` 已经做了映射
- 减少心智负担：一种写法，一个地方查

**替代方案**：全部使用 raw CSS variable

- 优点：不依赖 Tailwind
- 缺点：更冗长，与现有代码风格不一致

### Decision 2: 移除 Unified Drawer Component 需求

**选择**：保持导航抽屉和 TOC 抽屉独立实现

**理由**：

- 只有两个抽屉，抽象的复用收益极低
- 两者的触发方式、内容、位置都不同
- 独立实现已经工作良好，无明显 bug

**权衡**：如果未来新增更多抽屉场景，可能需要重新评估

### Decision 3: 保留哪些"待重构"项

| 保留 | 理由 |
|------|------|
| 独立策展页模板 | 真正有价值，能简化多个页面 |

| 移除 | 理由 |
|------|------|
| 统一按钮组件 | 按钮类型少，过早抽象 |
| Token 与 JS 同步 | 硬编码几个值不是大问题 |
| 响应式断点管理 | Tailwind 已有完善方案 |
| 图片处理不一致 | 三种来源本质不同 |
| 移动端导航体验 | 两个抽屉独立工作良好 |
| CSS 类命名不统一 | 重构成本高，收益低 |

### Decision 4: 文档精简策略

**保留**：

- 核心设计决策（色彩哲学、布局原语、排版规范）
- Token 定义和使用说明
- 组件设计原则

**移除**：

- 实现细节（具体配置、代码块重复）
- 一次性记录（PageSpeed 快照）
- 基础知识教学（rem/ch 单位说明）

## Risks / Trade-offs

### Risk 1: 删除过多导致信息丢失

**缓解**：

- Git 历史保留完整版本
- 精简前先确认每段内容的价值
- 可将详细内容移至代码注释或 README

### Risk 2: 统一 token 用法可能引入视觉回归

**缓解**：

- 使用 find-replace 批量操作，保证映射正确
- 实施前列出所有变更位置
- 手动验证关键页面

### Risk 3: 移除需求后未来需要重新添加

**缓解**：

- 本质是"延迟决策"而非"永久否决"
- 如果未来确实需要，可以重新添加
- 当前避免过早抽象的收益大于未来重新添加的成本

## Migration Plan

1. **Phase 1** 可独立完成，不影响代码
2. **Phase 2** 应在单个 PR 中完成，便于回滚
3. **Phase 3** 是 spec 层面的变更，实际代码无需改动

回滚方案：每个 Phase 对应一个 git commit，可独立 revert

## Open Questions

1. 表格响应式处理是否值得保留？需要检查博客中表格的实际使用频率
2. 是否需要为 `color-mix()` 计算值创建新的 token？需要统计内联用法数量
