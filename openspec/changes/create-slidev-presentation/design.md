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

```
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

- **Theme**: `@slidev/theme-seriph` (专业简约风格)
- **代码高亮**: Shiki (已支持)
- **图表**: Mermaid (内置支持)
- **数学公式**: 如需要可启用 KaTeX

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

### 4. 每页 PPT 的精修流程

```
1. 我生成该页草稿（Slidev 格式）
   ↓
2. 你运行 `pnpm slidev` 查看实际效果
   ↓
3. 你审核反馈（内容、布局、术语、视觉效果）
   ↓
4. 迭代修改 → 再次运行查看 → 直到满意
   ↓
5. 同步更新对应的 VitePress 文稿
   ↓
6. 进入下一页
```

**重要**: 每一页都必须运行 Slidev 实际查看效果后才能继续下一页。

### 5. ASCII 图转换策略

| 图表类型 | 转换方案 | 示例 |
|---------|---------|------|
| 流程图 | Mermaid flowchart | ReAct 循环、RLHF 流程 |
| 架构图 | Mermaid flowchart/C4 | MCP 架构、Agent 组件 |
| 时间线 | Mermaid timeline | AI 编程演进 |
| 对比表格 | Slidev 表格 | 模型价格对比 |
| 概念地图 | 需要手绘/专业工具 | Part 2 概念全景图 |

### 6. 链接校验方案

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
