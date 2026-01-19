# Tasks: Bokushi 博客功能增强

> **核心约束**：每个 Phase 独立分支、独立 PR、独立上线。完成一个 Phase 后等待用户确认再开始下一个。

## 通用流程

每个功能遵循以下步骤：

```text
Step A: 研究准备 — 搜索最佳实践、参考实现
Step B: 技术设计 — 确认方案、创建分支
Step C: 核心实现 — 编写代码
Step D: UI/UX 细节 — 样式、交互、响应式、无障碍
Step E: 设计审查 — 使用 /rams 进行无障碍和视觉审查
Step F: 测试验证 — 本地测试、截图确认
Step G: PR 提交 — 创建 PR，等待 Review
```

### 设计审查标准 (Step E)

遵循 **Vercel Design Guidelines** 和 **Rams 无障碍审查**：

- **交互**: 键盘可操作、焦点可见 (`:focus-visible`)、触控区域 ≥44px
- **视觉**: 层次阴影、同心圆角、明暗主题一致
- **无障碍**: 图标按钮有 `aria-label`、表单有 `label`、对比度 ≥4.5:1

每个 Phase 完成 UI 后运行 `/rams` 审查组件代码。

---

## Phase 1: 全文搜索 (Pagefind) ✅

**状态**: 已完成，直接合并到 main

### 1.1 研究准备

- [x] A1: 阅读 Pagefind 官方文档，了解 Astro 集成方式
- [x] A2: 搜索 `pagefind astro integration best practices`
- [x] A3: 查看 Astro 官方推荐的搜索方案

### 1.2 技术设计

- [x] B1: 确认索引范围（blog、til、monthly 是否都索引）→ 全部索引
- [x] B2: 确认 UI 方案（Modal vs 独立页面）→ Modal 弹窗
- [x] B3: 直接在 main 分支实现

### 1.3 核心实现

- [x] C1: 安装 `astro-pagefind` 依赖
- [x] C2: 配置 `astro.config.mjs` 集成 Pagefind
- [x] C3: 创建 `SearchModal.astro` 组件
- [x] C4: 添加搜索触发按钮到 Header

### 1.4 UI/UX 细节

- [x] D1: 实现键盘快捷键 `Cmd/Ctrl + K`
- [x] D2: 搜索结果样式适配明暗主题
- [x] D3: 移动端适配
- [x] D4: 无结果时的空状态设计
- [x] D5: 搜索按钮添加 `aria-label="搜索"`
- [x] D6: Modal 焦点管理（打开时聚焦输入框，关闭时恢复焦点）
- [x] D7: ESC 键关闭 Modal
- [x] D8: 搜索输入框关联 `<label>` 或 `aria-label`

### 1.5 设计审查

- [x] E1: 运行 `/rams` 审查 `SearchModal.astro` → 88/100
- [x] E2: 修复 Critical/Serious 级别问题（输入框焦点样式、关闭按钮尺寸）
- [x] E3: 确认触控区域 ≥44px、焦点样式可见

### 1.6 测试验证

- [x] F1: 本地 `pnpm build && pnpm preview` 测试 → 索引 115 页
- [x] F2: 截图确认 UI 效果
- [x] F3: 测试中文搜索准确性
- [x] F4: 键盘导航测试（Tab/Enter/ESC）

### 1.7 提交

- [x] G1: 提交 commit `feat(search): add Pagefind search`
- [x] G2: 直接推送到 main 分支

---

## Phase 2: 文章分享按钮 ✅

**状态**: 已完成，直接合并到 main

### 2.1 研究准备

- [x] A1: 搜索 `blog article social sharing sidebar design`
- [x] A2: 参考其他博客的分享按钮实现
- [x] A3: 确认各平台分享链接格式 → Twitter intent、Telegram share URL

### 2.2 技术设计

- [x] B1: 确认分享渠道优先级 → Twitter、Telegram、复制链接
- [x] B2: 确认固定 sidebar vs 悬浮按钮方案 → 桌面端左侧 sidebar，移动端悬浮按钮
- [x] B3: 直接在 main 分支实现（与 Phase 1 一致）

### 2.3 核心实现

- [x] C1: 创建 `ShareSidebar.astro` 组件
- [x] C2: 实现各平台分享链接生成（Twitter intent、Telegram share）
- [x] C3: 实现复制链接功能（Clipboard API + fallback）
- [x] C4: 集成到 `BlogPost.astro` 布局

### 2.4 UI/UX 细节

- [x] D1: 图标设计 → 使用 astro-icon (ri:twitter-fill, ri:telegram-fill, ri:link)
- [x] D2: Hover 效果和动画 → border-accent、shadow-md、scale 动画
- [x] D3: 复制成功 Toast 提示 → 底部居中 toast，2 秒自动消失
- [x] D4: 移动端适配 → 悬浮按钮 + 展开式分享菜单
- [x] D5: 每个图标按钮添加 `aria-label`（如 `aria-label="分享到 Twitter"`）
- [x] D6: 按钮触控区域 ≥44px → h-11 w-11 (44px)、移动端 h-12 w-12
- [x] D7: `:focus-visible` 焦点样式 → focus-accent 类
- [x] D8: Toast 添加 `role="status"` 供屏幕阅读器播报

### 2.5 设计审查

- [x] E1: 运行 `/rams` 审查 `ShareSidebar.astro`
- [x] E2: 修复 Critical/Serious 级别问题
- [x] E3: 确认图标对比度、焦点可见

### 2.6 测试验证

- [x] F1: 本地测试各分享链接
- [x] F2: 截图确认 UI 效果
- [x] F3: 测试移动端交互
- [x] F4: 键盘导航测试

### 2.7 提交

- [x] G1: 提交 commit `feat(share): add social sharing sidebar`
- [x] G2: 修复图标 bundle 问题 `perf(icons): only bundle used icons`
- [x] G3: 部署成功

---

## Phase 3: IndieWeb / Webmentions

**分支**: `feature/indieweb`

### 3.1 研究准备

- [ ] A1: 阅读 IndieWeb 入门指南
- [ ] A2: 了解 Webmention 协议
- [ ] A3: 注册 webmention.io 账号
- [ ] A4: 搜索 `astro webmention integration`

### 3.2 技术设计

- [ ] B1: 确认是否需要 Bridgy 集成
- [ ] B2: 确认 Webmention 展示位置和样式
- [ ] B3: 创建 `feature/indieweb` 分支

### 3.3 核心实现

- [ ] C1: 添加 `<link rel="webmention">` 到 `BaseHead.astro`
- [ ] C2: 添加 h-card 微格式到关于页面
- [ ] C3: 创建 `Webmentions.astro` 组件
- [ ] C4: 实现 webmention.io API 调用
- [ ] C5: 集成到文章页面

### 3.4 UI/UX 细节

- [ ] D1: Likes 展示（头像列表）
- [ ] D2: Reposts 展示（来源链接）
- [ ] D3: Mentions 展示（类似评论）
- [ ] D4: 空状态设计
- [ ] D5: 头像添加 `alt` 属性（用户名或 "用户头像"）
- [ ] D6: 外部链接添加 `rel="noopener"` 和可选的外链图标
- [ ] D7: 使用语义化列表 `<ul>/<li>` 结构
- [ ] D8: 加载状态使用 `aria-busy="true"`

### 3.5 设计审查

- [ ] E1: 运行 `/rams` 审查 `Webmentions.astro`
- [ ] E2: 修复 Critical/Serious 级别问题
- [ ] E3: 确认头像对比度、链接可识别

### 3.6 测试验证

- [ ] F1: 验证 webmention.io 配置
- [ ] F2: 测试 API 数据获取
- [ ] F3: 截图确认 UI 效果
- [ ] F4: 屏幕阅读器测试（VoiceOver/NVDA）

### 3.7 PR 提交

- [ ] G1: 提交 commit，创建 PR
- [ ] G2: 用户 Review ← **等待确认**

---

## Phase 4: AI 相关文章推荐

**分支**: `feature/ai-recommendations`

### 4.1 研究准备

- [ ] A1: 搜索 `static site related posts embedding`
- [ ] A2: 了解 OpenAI text-embedding API
- [ ] A3: 搜索 `astro build time recommendations`

### 4.2 技术设计

- [ ] B1: 确认 Embedding 模型（OpenAI vs 本地）
- [ ] B2: 确认推荐数量（3 篇？5 篇？）
- [ ] B3: 设计数据结构和存储方式
- [ ] B4: 创建 `feature/ai-recommendations` 分支

### 4.3 核心实现 — Embedding 生成

- [ ] C1: 创建 `scripts/generate-embeddings.ts`
- [ ] C2: 实现文章内容提取和预处理
- [ ] C3: 调用 Embedding API 生成向量
- [ ] C4: 存储 embedding 到 JSON 文件

### 4.4 核心实现 — 推荐计算

- [ ] C5: 实现余弦相似度计算
- [ ] C6: 为每篇文章生成 Top N 推荐
- [ ] C7: 输出推荐数据到 `src/data/recommendations.json`

### 4.5 核心实现 — 页面集成

- [ ] C8: 创建 `RelatedPosts.astro` 组件
- [ ] C9: 在 `BlogPost.astro` 中集成
- [ ] C10: 实现推荐数据读取

### 4.6 UI/UX 细节

- [ ] D1: 推荐卡片设计
- [ ] D2: 相似度展示（可选）
- [ ] D3: 响应式布局
- [ ] D4: 卡片使用 `<article>` 或 `<li>` 语义结构
- [ ] D5: 标题使用适当的 heading 层级（如 `<h3>`）
- [ ] D6: 卡片链接触控区域 ≥44px
- [ ] D7: `:focus-visible` 焦点样式
- [ ] D8: 无推荐时的空状态使用友好文案

### 4.7 设计审查

- [ ] E1: 运行 `/rams` 审查 `RelatedPosts.astro`
- [ ] E2: 修复 Critical/Serious 级别问题
- [ ] E3: 确认卡片对比度、焦点可见

### 4.8 测试验证

- [ ] F1: 验证 Embedding 生成流程
- [ ] F2: 检查推荐结果质量
- [ ] F3: 截图确认 UI 效果
- [ ] F4: 键盘导航测试

### 4.9 PR 提交

- [ ] G1: 提交 commit，创建 PR
- [ ] G2: 用户 Review ← **等待确认**

---

## 收尾

- [ ] 所有 Phase PR 合并后，归档本 proposal
- [ ] 更新 GitHub Issue #1 状态
