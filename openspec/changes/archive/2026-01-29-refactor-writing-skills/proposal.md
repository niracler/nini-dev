## Why

当前 `writing-assistant` skill 职责过载，违反单一职责原则：同时包含「启发写作」和「审校润色」两个完全独立的工作流，且日记功能比其他文章类型复杂得多（有模板配置、Work Log 自动化、任务联动、收尾流程），混在一起难以维护和使用。此外，description 违反 CSO 规范，描述了「做什么」而非「何时使用」。

## What Changes

- **拆分 skill**：将 `writing-assistant` 拆分为 3 个独立 skill
  - `diary-assistant`: 日记专用，包含完整的任务联动流程
  - `writing-inspiration`: 通用写作启发（游记/TIL/通用文章）
  - `writing-proofreading`: 文章审校
- **新增任务联动**：diary-assistant 与 Reminders 集成
  - 开始时：获取今日任务，确认完成情况
  - 结束时：规划明天任务，写入 Reminders
- **Work Log 必须执行**：工作日自动从 git/云效获取，不询问
- **移除 git 提交**：日记存储在 Obsidian，不需要 git 提交
- **BREAKING**: 删除旧的 `writing-assistant` skill

## Capabilities

### New Capabilities

- `diary-assistant`: 日记助手，包含任务回顾、Work Log 自动化、启发提问、明日计划、智能收尾
- `writing-inspiration`: 通用写作启发，包含游记/TIL/通用文章的框架和启发问题
- `writing-proofreading`: 文章审校，包含结构诊断、语言规范、信源查证、风格检查

### Modified Capabilities

<!-- 无需修改现有 capability，这是全新拆分 -->

## Impact

- **删除**: `repos/skill/src/writing-assistant/` 目录及所有 references
- **新建**: `repos/skill/src/diary-assistant/`, `repos/skill/src/writing-inspiration/`, `repos/skill/src/writing-proofreading/`
- **依赖 skill**: `schedule-manager`（任务联动）、`anki-card-generator`（TIL 收尾）、`yunxiao`（云效 Work Log）
- **用户配置**: 需要迁移 `user-config.md` 到 `diary-assistant`
