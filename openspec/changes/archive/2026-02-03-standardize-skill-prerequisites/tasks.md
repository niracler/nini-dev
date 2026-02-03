## 1. 迁移现有依赖章节（有旧格式的 skill）

- [x] 1.1 schedule-manager: 将 `依赖与权限` 章节迁移为 Prerequisites 表格，权限配置保留为补充说明
- [x] 1.2 markdown-lint: 将 `前置条件` 章节迁移为 Prerequisites 表格
- [x] 1.3 diary-assistant: 将 `依赖 Skill` 章节合并为 Prerequisites 表格
- [x] 1.4 worklog: 汇总散落在正文中的依赖信息为 Prerequisites 表格

## 2. 新增 Prerequisites（隐式依赖的 skill）

- [x] 2.1 git-workflow: 新增 Prerequisites 表格（git, gh）
- [x] 2.2 code-sync: 新增 Prerequisites 表格（git, git-workflow skill）
- [x] 2.3 yunxiao: 新增 Prerequisites 表格（yunxiao MCP, aliyun CLI, jq, git）
- [x] 2.4 ha-integration-reviewer: 新增 Prerequisites 表格（git, gh, Context7 MCP）
- [x] 2.5 writing-proofreading: 新增 Prerequisites 表格（markdownlint-cli2, markdown-lint skill）
- [x] 2.6 skill-reviewer: 新增 Prerequisites 表格（writing-skills skill）

## 3. 更新 skill-reviewer 审查规则

- [x] 3.1 在 skill-reviewer SKILL.md 中新增 Prerequisites 格式审查项

## 4. 更新 README

- [x] 4.1 在 README.md 的 skill 列表表格中增加 Dependencies 列
- [x] 4.2 更新 ASCII 架构图，补充外部依赖层

## 5. 验证

- [x] 5.1 检查所有 10 个有依赖的 skill 都有标准格式的 Prerequisites 表格
- [x] 5.2 确认 3 个无依赖 skill 没有多余的 Prerequisites 章节
- [x] 5.3 运行 `scripts/validate.sh` 确保 frontmatter 格式未被破坏
