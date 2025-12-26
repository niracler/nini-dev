# Tasks: unify-card-styles

## Phase 1: 建立 Surface Card 系统

- [x] **Task 1.1**: 在 `global.css` 中扩展 `.surface-card` 变体
  - 添加 `--soft`、`--flat`、`--compact` 修饰类
  - 添加 `--hover-border`、`--hover-none` hover 变体
  - **验证**: `pnpm build` 成功

- [x] **Task 1.2**: 使用 Chrome DevTools 检查变体样式
  - 打开 dev server
  - 检查新增类是否正确生效

## Phase 2: 迁移 Channel 页面

- [x] **Task 2.1**: 迁移 `.channel-info-card` 样式
  - 圆角改为 `var(--radius-lg)`
  - 阴影改为 `var(--shadow-soft)`
  - **验证**: Chrome 检查 `/channel` 页面视觉一致

- [x] **Task 2.2**: 迁移 `.telegram-post` 样式
  - 圆角改为 `var(--radius-lg)`
  - 移除 `translateY(-2px)` hover
  - 阴影改为令牌
  - **验证**: Chrome 检查 hover 效果

- [x] **Task 2.3**: 迁移 `.pagination-link` 样式
  - 圆角改为 `var(--radius-md)`
  - 移除 `translateY(-2px)` hover
  - **验证**: Chrome 检查分页按钮

## Phase 3: 迁移 MangaShots 页面

- [x] **Task 3.1**: 迁移 `.manga-search` 样式
  - 圆角改为 `var(--radius-lg)`
  - 边框改为 1px
  - **验证**: Chrome 检查 `/mangashots` 搜索框

- [x] **Task 3.2**: 迁移 `.filter-chip` 样式
  - 圆角改为 `var(--radius-md)`
  - 边框改为 1px
  - **验证**: Chrome 检查筛选芯片

- [x] **Task 3.3**: 简化 `.manga-shot-item` hover
  - 移除 `translateY(-12px)` 和 `scale(1.02)`
  - 简化阴影为单层
  - **验证**: Chrome 检查图片卡片 hover

## Phase 4: 迁移 PostList 组件

- [x] **Task 4.1**: 迁移 `.post-link` 样式
  - 使用语义化类替代 Tailwind 混合
  - **验证**: Chrome 检查 `/blog` 列表页
  - **备注**: 已符合规范，无需修改

## Phase 5: 更新文档

- [x] **Task 5.1**: 简化 `design-primitives.md` 卡片相关内容
  - 删除 "统一卡片样式" 待重构条目
  - 简化 `.surface-card` 介绍，指向 `global.css`
  - 删除 translateY hover 相关描述

- [x] **Task 5.2**: 同步更新 `AGENTS.md` (CLAUDE.md)
  - 更新 Design Reference 章节，确保与 design-primitives.md 保持一致
  - 添加 surface-card 变体的简要说明（如有必要）
  - 确保文档引用路径正确
  - **验证**: 阅读两份文档确认信息一致

- [x] **Task 5.3**: 最终验证
  - Chrome 检查 `/channel`、`/mangashots`、`/blog` 三个页面
  - 确认视觉一致性
  - `pnpm build` 成功

## 依赖关系

```
Phase 1 ──┬── Phase 2
          ├── Phase 3
          └── Phase 4
                │
                v
            Phase 5
```

Phase 2、3、4 可并行进行（都依赖 Phase 1 完成）。
