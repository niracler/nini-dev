### Requirement: Skills discoverable via npx skills standard path

仓库 SHALL 使用 `skills/` 作为顶级目录存放所有 skill，使 `npx skills` 能通过标准路径搜索发现。

#### Scenario: npx skills list discovers all skills

- **WHEN** 用户运行 `npx skills add niracler/skill --list`
- **THEN** 所有 skill（git-workflow, yunxiao, ha-integration-reviewer, diary-assistant, writing-inspiration, writing-proofreading, anki-card-generator, schedule-manager, zaregoto-miko）均被列出

#### Scenario: npx skills add installs selected skill

- **WHEN** 用户运行 `npx skills add niracler/skill --skill git-workflow`
- **THEN** git-workflow skill 被安装到用户的 agent 配置中

### Requirement: Claude marketplace installation continues to work

`.claude-plugin/marketplace.json` SHALL 保持有效，路径引用指向 `skills/` 目录。

#### Scenario: marketplace add installs all plugins

- **WHEN** 用户运行 `claude plugin marketplace add https://github.com/niracler/skill.git`
- **THEN** 所有 plugin group（workflow-skills, writing-skills, learning-skills, fun-skills）均可被安装

### Requirement: All path references updated consistently

仓库内所有引用 skill 目录的文件 SHALL 使用 `skills/` 路径，不存在残留的 `src/` 引用。

#### Scenario: validate script runs successfully

- **WHEN** 用户运行 `./scripts/validate.sh`
- **THEN** 所有 skill 通过验证，无 "No skills found" 错误

#### Scenario: README reflects correct structure

- **WHEN** 用户查看 README.md
- **THEN** 目录结构图、安装说明、开发命令均使用 `skills/` 路径
