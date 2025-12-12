# Design: Slidev Presentation Architecture

## Context

将 3000+ 行的 AI 编程分享文稿转换为 ~50 页的 Slidev PPT，同时保持文稿版（VitePress）同步更新。这是一个迭代式项目，每页 PPT 都需要用户精修确认。

## Goals

- 创建专业、视觉清晰的演示 PPT
- 保持文稿版与 PPT 版内容同步
- 统一所有专业术语和命名
- 确保所有引用链接有效且准确

## Non-Goals

- 不改变原有内容的核心观点
- 不增加新的技术主题
- 不创建独立仓库（在同一仓库内）

## Decisions

### 1. 项目结构

```text
repos/ai-programming-share/
├── docs/                    # VitePress 文稿版（保留）
│   ├── 01-开场.md
│   ├── 02-1-早期发展.md
│   └── ...
├── slides.md                # Slidev 主文件
├── components/              # 自定义 Vue 组件（如需要）
├── public/                  # 截图、图片资源
│   └── images/
├── package.json             # 更新，添加 Slidev 依赖
└── slidev.config.ts         # Slidev 配置
```

### 2. Slidev 技术选型

**基础配置：**

- **Theme**: `@slidev/theme-seriph` (专业简约风格)
- **代码高亮**: Shiki (已支持)
- **图表**: Mermaid (内置支持)
- **数学公式**: 如需要可启用 KaTeX

**样式约定：**

```css
:root {
  --accent: #FB8F68;           /* 重点色 */
  --accent-light: rgba(251, 143, 104, 0.15);  /* 背景色 */
}
.accent { color: var(--accent); }
.accent-bg { background-color: var(--accent-light); }
```

**技术经验：**

| 问题 | 解决方案 |
|------|----------|
| Mermaid timeline 容易越界 | 改用 `grid` 布局 + 卡片 |
| Vue 组件加载不稳定 | 放弃组件，直接用内联 HTML + Tailwind 类 |
| 重点色需要复用 | 在 `<style>` 中定义 CSS 变量 `--accent` |
| 字体大小不一致 | 建立视觉层次：标题 ≥36pt → 正文 ≥24pt |
| Mermaid 图太小 | 根据布局调整 scale：单列 0.7-0.8，two-cols 0.5-0.6 |

### 3. 术语统一表

| 中文术语 | 英文 | 统一写法 | 备注 |
|---------|------|---------|------|
| 大语言模型 | Large Language Model | LLM | 首次出现时写全称 |
| 词元/令牌 | Token | Token | 统一用 Token |
| 上下文窗口 | Context Window | Context Window | |
| 幻觉 | Hallucination | 幻觉 | |
| 人类反馈强化学习 | RLHF | RLHF | 首次出现时写全称 |
| 多模态 | Multimodal | 多模态 | |
| 函数调用 | Function Call | Function Call | |
| 检索增强生成 | RAG | RAG | 首次出现时写全称 |
| 思维链 | Chain of Thought | CoT | |
| 推理模型 | Reasoning Model | 推理模型 | |
| 智能体/代理 | Agent | Agent | 统一用 Agent |
| 子智能体 | Subagent | Subagent | |
| 模型上下文协议 | Model Context Protocol | MCP | |
| 技能 | Skill | Skill | |

### 4. 设计原则

#### 目标听众：对 AI 了解甚少的物联网工程师

这意味着：

- 避免假设听众已有 AI 背景知识
- 用物联网/嵌入式领域的类比解释 AI 概念
- 首次出现的术语必须简明解释

**核心理念（参考 Nancy Duarte, Garr Reynolds, MIT CommLab）：**

- **Nancy Duarte**: 幻灯片是 "glance media"，一眼能懂
- **Garr Reynolds**: YOU are the content, slides are your Table of Contents
- **核心**: 每页一个核心观点，大量留白

**信噪比原则：**

- **所有页面的信噪比都要尽可能高** — 每个元素都必须有存在的理由
- 删除装饰性内容，保留有意义的信息
- 如果一个元素不能帮助理解，就删掉它

**视觉优先原则：**

- **尽可能多用图，少用纯文字** — 纯文字太素，难以吸引注意力
- 需要截图/素材时，AI 会主动告知用户去准备
- 复杂图形可以先用 ASCII 画草稿，用户确认后再用专业工具绘制
- Mermaid 支持多种图类型（flowchart, sequence, timeline, mindmap 等），可用 context7 MCP 查找用法

**内容原则：**

- **内容量要充足**：空白太多说明内容不够，应增加有意义的内容而非装饰
- **左右分栏要平衡**：两边内容量应大致相当，避免一边空一边满
- **参考外部最佳实践**：遇到布局问题时，查看 [Slidev Showcases](https://sli.dev/resources/showcases) 寻找灵感

**迭代原则：**

- 前面的页面效果可能不够理想，后续可能回来修改
- 不盲目参考已完成的页面，每页独立追求最佳效果

### 5. 每页 PPT 的精修流程

> ⚠️ **核心约束：逐页确认** — 每完成一页 slide 必须暂停，等待用户确认后才能继续下一页。

**流程：**

```text
1. 根据该页内容类型，搜索相关最佳实践
   ↓
2. 参考 Slidev Showcases 和 antfu/talks 寻找类似布局
   ↓
3. 生成该页草稿（Slidev 格式）
   ↓
4. 使用 Playwright MCP 截图验证布局效果
   ↓
5. 用户审核反馈（内容、布局、术语、视觉效果）
   ↓
6. 迭代修改 → Playwright 截图验证 → 直到满意
   ↓
7. 同步更新对应的 VitePress 文稿
   ↓
8. 进入下一页
```

#### Step 1: 搜索最佳实践（强制）

> ⚠️ **强制要求**：每一页 slide 开始前，**必须**使用 WebSearch 搜索相关资料。这是 Context Engineering 页面成功的关键经验。

每页开始前，根据内容类型搜索相关资料：

| 内容类型 | 搜索关键词示例 |
|---------|---------------|
| 时间线/演进 | `timeline slide design best practice` |
| 概念对比 | `comparison slide layout` |
| 流程图 | `process flow presentation design` |
| 数据/统计 | `data visualization slide` |
| 引言/金句 | `quote slide design` |
| 列表/要点 | `bullet points slide alternatives` |
| **技术概念** | `[概念名] best practices 2025` |
| **工具对比** | `[工具名] how it works architecture` |

**搜索策略**：

1. **概念深挖**：搜索官方文档、权威博客、最新研究
2. **多源交叉**：至少 2-3 个不同来源验证信息
3. **WebFetch 深挖**：不只看搜索摘要，获取完整文章内容提取关键信息
4. **信息整合**：从多个来源提炼统一的框架和数据
5. **引用标注**：在 slide 脚注中标明来源

**搜索带来的价值**：

| 收获类型 | 说明 |
|---------|------|
| 权威框架 | 发现业界公认的分类方法、策略模型 |
| 具体数据 | 获取可引用的统计数字、研究结论 |
| 实现细节 | 了解产品/工具的具体工作方式 |
| 可视化灵感 | 从优秀案例中提炼展示方式 |

#### Step 4: Playwright MCP 验证

使用 Playwright MCP 工具自动截图验证布局：

1. 确保 Slidev dev server 运行中 (`pnpm slidev`)
2. 调用 Playwright 截图指定页面
3. 检查：文字是否溢出、间距是否合理、Mermaid 图是否正常渲染

> 不要凭感觉设计布局，要有据可查。

**外部参考资源：**

- [Slidev Showcases](https://sli.dev/resources/showcases) — 寻找类似布局的灵感
- [antfu/talks](https://github.com/antfu/talks) — 高质量开源演示的源码
- [Presentation Zen](https://www.presentationzen.com/) — Garr Reynolds 的设计理念
- [Duarte Blog](https://www.duarte.com/resources/) — Nancy Duarte 的演示技巧

### 6. 布局规范

**推荐布局模式：**

| 布局 | 用途 | 说明 |
|------|------|------|
| 默认布局 | 大多数页面 | 标题左上角，内容自上而下 |
| `layout: center` | 封面等特殊页面 | 居中强调 |
| `layout: two-cols` + `::right::` | 概念+示例 | 左右对比 |
| `grid grid-cols-3 gap-4` | 多项并列 | 卡片网格 + 圆角背景色 |
| 单列居中 | 图表为主 | 让 Mermaid 图成为焦点 |

**可视化技巧**：

- 用「矩形容器」展示容量/范围的填充过程
- 用「进度条」直观展示数值变化
- 用 `v-click` 分步展示，配合演讲节奏
- 左右对比（前/后、旧/新）强化理解

**演讲节奏标记：**

非核心内容可在右上角添加标记，帮助演讲时把握节奏：

```html
<div class="abs-tr m-6 px-2 py-1 text-xs bg-gray-500/10 rounded opacity-60">
⏩ 快速带过
</div>
```

### 7. 脚注与引用规范

**正文标记：**

```html
<sup class="opacity-60">1</sup>
```

**页面底部脚注：**

```html
<div class="abs-bl m-6 text-xs opacity-50">
<sup>1</sup> 🔬 L1 | 来源 "标题" — 简要说明
</div>
```

格式：`信源等级 | 来源 "标题" — 说明`

**优化原则：**

- **数量**：每页 2-3 个为宜，过多会分散注意力
- **内容**：用中文详细描述，包含"为什么重要"
- **精简**：相关引用可合并为一个脚注

### 8. 展示策略

**链接 vs 截图：**

- 展示产品整体效果 → 直接给官方链接（如 Claude Code、Cursor、Copilot 官网）
- 强调特定功能/界面 → 截图（精确控制展示内容）
- 代码示例 → 代码块或截图
- 实时演示 → 现场操作 + 备用录屏

### 9. ASCII 图转换策略

| 图表类型 | 转换方案 | 示例 |
|---------|---------|------|
| 流程图 | Mermaid flowchart | ReAct 循环、RLHF 流程 |
| 架构图 | Mermaid flowchart/C4 | MCP 架构、Agent 组件 |
| 时间线 | Mermaid timeline | AI 编程演进 |
| 对比表格 | Slidev 表格 | 模型价格对比 |
| 概念地图 | 需要手绘/专业工具 | Part 2 概念全景图 |

### 9. 链接校验方案

1. **可访问性检查**: 使用脚本批量检测 HTTP 状态
2. **内容核实**: 人工抽查关键引用
3. **处理失效链接**:
   - 优先找替代来源
   - 标注为 Archive.org 链接
   - 实在找不到则标注「来源已失效」

## Trade-offs

| Decision | Pros | Cons |
|----------|------|------|
| 在同一仓库 | 便于同步维护 | package.json 会更复杂 |
| 逐页迭代 | 质量可控 | 耗时较长 |
| Mermaid 替代 ASCII | 可维护、美观 | 部分复杂图可能需要简化 |

## Resolved Decisions

| 问题 | 决策 |
|------|------|
| PPT 语言 | 纯中文 |
| PDF 导出 | 需要（配置 `slidev export`） |
| 演讲者备注 | 需要（使用 Slidev presenter notes 功能） |
