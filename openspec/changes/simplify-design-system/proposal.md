# Change: Simplify Design System

## Why

当前 bokushi 博客的设计系统存在两个核心问题：

1. **文档膨胀**：`design-primitives.md` 有 846 行，包含大量实现细节、过时记录和冗余内容，难以作为实际的设计规范使用
2. **过度设计**：现有 design-system spec 承诺了过多抽象（Unified Drawer、Unified Button 等），但实际收益低于实现成本

本着"如无必要，勿增实体"的原则，本提案聚焦于**减法**：删除不必要的复杂度，统一现有用法，而非增加新抽象。

## What Changes

### Phase 1: 精简文档 (design-primitives.md)

**REMOVE**:

- ASCII 布局图（302-349 行）- 难以维护，与代码不同步
- Markdown 处理管道细节（63-91 行）- 属于 Astro 配置，非设计决策
- 单位说明基础知识（366-376 行）- 链接到 MDN 即可
- PageSpeed 实战记录（671-679 行）- 一次性快照，会过时
- 重复的代码示例 - 与 tokens.css/global.css 内容重复

**SIMPLIFY**:

- "待重构"章节：删除过度设计项，仅保留真正有价值的改进方向

**目标**：从 ~850 行压缩到 ~400 行

### Phase 2: 统一样式用法

统一组件中 token 的使用方式，选择单一模式：

| 当前混用 | 统一为 |
|---------|--------|
| `text-[var(--color-text-primary)]` | `text-primary` |
| `bg-[color-mix(...)]` | 预定义 token 类 |
| 硬编码 `#fffaf4` | `bg-page` |

**不新增抽象**，仅规范化现有 token 用法。

### Phase 3: 移除过度设计需求

从 design-system spec 中移除以下需求：

| 需求 | 移除理由 |
|------|----------|
| Unified Drawer Component | 两个抽屉（导航+TOC）独立工作良好，抽象收益低 |
| 部分 Token Completeness 场景 | 某些硬编码值出现频率极低，token 化得不偿失 |

保留高价值需求：

- Surface Card Variants
- Border Radius Standardization
- Shadow Token Usage
- Hover Effect Constraints
- Scroll Lock Utility
- No Important Override

## Impact

- **Affected specs**: `design-system`
- **Affected files**:
  - `repos/bokushi/src/content/blog/design-primitives.md`
  - `repos/bokushi/src/styles/tokens.css`（可能小幅调整）
  - `repos/bokushi/src/components/*.astro`（统一 token 用法）
- **Breaking changes**: 无
