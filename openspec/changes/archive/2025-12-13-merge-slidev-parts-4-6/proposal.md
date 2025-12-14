# Change: 合并 Slidev Part 4-6 为单一 Part

## Why

当前 AI 编程分享的 Part 4（正确使用）、Part 5（风险与心智）、Part 6（团队采用）存在内容重复和结构冗余：

- Oxide 五原则在 Part 5 和 Part 6 都有
- 模拟器心智模型在 Part 4 和 Part 5 重复出现
- 代码审查原则散落在多处
- Part 3 已经讲了 Vibe Coding 踩坑，Part 5 再展开风险有些累赘

合并后可以：
1. 减少重复，让演讲更紧凑
2. 突出重点（Context Engineering、OCaml 案例、现场演示）
3. 时间从 ~55min 压缩到 ~35-40min

## What Changes

将 `docs/04-正确使用.md`、`docs/05-风险与心智.md`、`docs/06-团队采用.md` 合并为单一文件 `docs/04-正确使用.md`，并同步更新 `slides.md`。

### 新结构

| 节 | 内容 | 时间 |
|---|---|---|
| 4.1 心智模型 | 「AI 是模拟器不是人」+ 正确的对话姿势 | 5min |
| 4.2 Context Engineering 实操 | 好/坏 Context 对比 + 三条原则 + Course Correct | 8min |
| 4.3 CLAUDE.md 与工具链 | WHAT/WHY/HOW + OpenSpec + Skills 简介 | 5min |
| 4.4 现场演示 | 时钟从零到部署 + Git Workflow Skill | 12min |
| 4.5 使用边界 | 什么时候用/不用 + 七条实践建议 | 5min |
| 4.6 团队采用 | OCaml 13K PR 案例 + 分阶段策略 + 代码审查原则 | 5min |
| 4.7 Q&A 与资源 | 常见问题 + 推荐阅读 | 5min |

### 删除/降级内容

| 内容 | 处理 |
|---|---|
| 葵花宝典比喻 | 删除（用词不雅，且 Part 3「捷径的代价」已表达类似意思） |
| Lovable 安全事件 | 降为脚注引用 |
| METR 研究 | 精简为一句话佐证 |
| 技能退化四征兆 | 合并到「使用边界」中简述 |
| Oxide 五原则 | 只在团队采用部分保留一处 |
| 成本意识 | 简化为一页 slide |

## Impact

- Affected specs: `documentation`
- Affected files:
  - `docs/04-正确使用.md` — 重写
  - `docs/05-风险与心智.md` — 删除
  - `docs/06-团队采用.md` — 删除
  - `docs/07-附录.md` — 重命名为 `docs/05-附录.md`
  - `slides.md` — 更新 Part 4-6 部分
