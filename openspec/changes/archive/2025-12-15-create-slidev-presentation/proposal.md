# Change: Create Slidev Presentation from AI Programming Share Docs

## Why

现有的 AI 编程分享文档（VitePress 格式）内容完整但形式不适合演示。需要创建一份 Slidev 格式的 PPT，同时：

- 保留 VitePress 作为文稿版（演讲稿）
- 统一所有专业术语、命名、叫法
- 将 ASCII 图表转换为 Mermaid 或截图
- 校验并核实所有引用链接

## What Changes

### 1. Slidev 项目初始化

- 在 `repos/ai-programming-share/` 中添加 Slidev 配置
- 创建 `slides.md` 作为主 PPT 文件
- 配置适合技术分享的主题和样式

### 2. 内容转换（最多 38 页 PPT）

- **核心原则**: 38 页上限是硬约束，需要**删减非核心内容**保留重点
- 每页 PPT 逐页精修，用户决定保留/删除哪些内容
- 删除的内容仅保留在文稿版中作为补充阅读

### 3. 文稿版同步精修

- 在精修每页 PPT 时同步更新 VitePress 文稿
- 统一术语表（见 design.md）
- 重新排版、优化表述

### 4. 图表优化

- ASCII 图 → Mermaid 或专业截图
- 需要新增的截图/思维导图（TODO 清单中已列出）
- 逐页判断是否转换

### 5. 链接校验

- 检查所有 ~70 个脚注链接的可访问性
- 验证引用内容与描述是否匹配
- 用户审核确认

## Docs Structure (Updated 2025-12-13)

文稿版已重组，将原 Part 4-6 合并压缩为 Part 4：

| 文件 | 内容 |
|------|------|
| `01-开场.md` | Part 1: 开场 |
| `02-1-早期发展.md` | Part 2.1: GPT-3、Token、Copilot |
| `02-2-多模态与工具.md` | Part 2.2: ChatGPT、GPT-4、Function Call、RAG |
| `02-3-推理模型.md` | Part 2.3: 推理模型 (o1, DeepSeek R1) |
| `02-4-Agent与工具.md` | Part 2.4: Agent、Cursor/Claude Code、MCP |
| `02-5-进阶能力.md` | Part 2.5: Subagent、Context Engineering |
| `02-6-概念总结.md` | Part 2.6: 概念路线图 |
| `03-踩坑故事.md` | Part 3: 踩坑故事 |
| `04-1-实操指南.md` | Part 4.1: 心智模型、实操技巧、CLAUDE.md |
| `04-2-边界与采用.md` | Part 4.2: 使用边界、团队采用、Q&A |
| `05-附录.md` | 附录: 资源、TODO |

**归档文件** (`docs/archive/`): 原 `04-正确使用.md`、`05-风险与心智.md`、`06-团队采用.md`

## Impact

- **Affected files**:
  - 新增: `slides.md`, Slidev 配置文件
  - 修改: `docs/*.md` (术语统一、排版优化)
- **Affected specs**: 新增 `slidev-presentation` capability
- **Dependencies**: 需要安装 Slidev 依赖

## Risks

| Risk | Mitigation |
|------|------------|
| 内容取舍困难 | 每页逐一讨论，用户决定保留/删除 |
| 链接失效 | 提供替代来源或标注为「已失效」 |
| 术语不一致遗漏 | 建立术语表，逐文件检查 |
