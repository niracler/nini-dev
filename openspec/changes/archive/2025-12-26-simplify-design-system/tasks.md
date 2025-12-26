# Tasks: Simplify Design System

## Phase 1: 精简文档

- [x] 1.1 备份 design-primitives.md 到 git（确保可回滚）
- [x] 1.2 删除 ASCII 布局图（第 302-349 行）
- [x] 1.3 删除 Markdown 处理管道详细配置（第 63-91 行），保留一句话概述
- [x] 1.4 删除单位说明基础知识（第 366-376 行），替换为 MDN 链接
- [x] 1.5 删除 PageSpeed 实战记录（第 671-679 行及截图引用）
- [x] 1.6 精简代码示例：移除与 tokens.css 重复的 CSS 块
- [x] 1.7 重写"待重构"章节：
  - [x] 1.7.1 保留：独立策展页模板
  - [x] 1.7.2 移除：统一按钮组件（过早抽象）
  - [x] 1.7.3 移除：Token 与 JS 同步（收益过低）
  - [x] 1.7.4 移除：响应式断点管理（Tailwind 已解决）
  - [x] 1.7.5 评估：表格响应式处理（看实际使用频率决定保留或移除）
  - [x] 1.7.6 移除：图片处理不一致（三种来源本质不同，不强求统一）
  - [x] 1.7.7 移除：移动端导航体验（两个抽屉工作良好）
  - [x] 1.7.8 移除：CSS 类命名不统一（重构成本高，收益低）
- [x] 1.8 验证精简后的文档仍然完整覆盖核心设计决策

## Phase 2: 统一样式用法

- [x] 2.1 审计所有 `.astro` 文件，列出 token 使用不一致的位置
- [x] 2.2 选择统一模式：优先使用 Tailwind utility（`text-primary`）而非 bracket notation
- [x] 2.3 批量替换 `text-[var(--color-*)]` 为对应的 Tailwind utility
- [x] 2.4 批量替换 `bg-[var(--color-*)]` 为对应的 Tailwind utility
- [x] 2.5 识别 `color-mix()` 内联用法，评估是否需要新增 token（保留作为例外）
- [x] 2.6 更新 tailwind.config.mjs 以覆盖缺失的 token 映射（如需要）- 无需更新
- [x] 2.7 验证所有页面视觉无变化

## Phase 3: 移除过度设计需求

- [x] 3.1 从 design-system spec 移除 "Unified Drawer Component" 需求
- [x] 3.2 精简 "Design Token Completeness" 需求，允许低频场景硬编码
- [x] 3.3 添加 "Token Usage Consistency" 需求
- [x] 3.4 运行 `openspec validate --strict` 确认 spec 格式正确

## Validation

- [x] 4.1 运行 `pnpm build` 确认构建成功
- [x] 4.2 运行 `pnpm astro check` 确认类型检查通过
- [x] 4.3 文档行数 846 → 623（26% 缩减）
