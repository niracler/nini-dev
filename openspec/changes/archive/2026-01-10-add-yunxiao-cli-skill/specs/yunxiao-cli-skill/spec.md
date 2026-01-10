## ADDED Requirements

### Requirement: Yunxiao CLI Skill Structure

The skill SHALL follow the standard skill structure with SKILL.md and references folder.

#### Scenario: Skill directory created
- **WHEN** the skill is implemented
- **THEN** the directory `repos/skill/src/yunxiao-cli/` SHALL exist
- **AND** it SHALL contain `SKILL.md` as the main entry point
- **AND** it SHALL contain a `references/` folder for detailed documentation

### Requirement: SKILL.md Content

The SKILL.md SHALL provide overview, quick reference, and common workflows for Yunxiao CLI tools.

#### Scenario: YAML frontmatter valid
- **WHEN** the skill is loaded
- **THEN** the frontmatter SHALL contain `name` and `description` fields
- **AND** the description SHALL start with "Use when..."
- **AND** the total frontmatter SHALL be under 1024 characters

#### Scenario: Core sections present
- **WHEN** reading SKILL.md
- **THEN** it SHALL include Overview section
- **AND** it SHALL include When to Use section
- **AND** it SHALL include Quick Reference table
- **AND** it SHALL include Common Workflows section

### Requirement: Git-Repo Documentation

The skill SHALL document git-repo tool installation and core commands.

#### Scenario: Installation guide provided
- **WHEN** user asks how to install git-repo
- **THEN** the skill SHALL provide download URL and installation steps
- **AND** it SHALL cover Linux, macOS, and Windows platforms

#### Scenario: Core commands documented
- **WHEN** user needs to create MR via CLI
- **THEN** the skill SHALL document `git pr` command
- **AND** it SHALL document `git peer-review` command
- **AND** it SHALL document `git download` command

### Requirement: Push Review Mode Documentation

The skill SHALL document the zero-installation Push Review Mode as an alternative.

#### Scenario: Push review commands documented
- **WHEN** user cannot install git-repo
- **THEN** the skill SHALL provide `git push -o review=new` for creating MR
- **AND** it SHALL provide `git push -o review=<id>` for updating MR
- **AND** it SHALL explain when to use push review vs git-repo

### Requirement: OpenAPI Reference

The skill SHALL document Alibaba Cloud CLI usage for Yunxiao operations.

#### Scenario: Tag creation documented
- **WHEN** user needs to create release tag via API
- **THEN** the skill SHALL reference CreateTag API
- **AND** it SHALL provide authentication setup guidance

#### Scenario: Task query documented
- **WHEN** user needs to view Projex tasks
- **THEN** the skill SHALL reference relevant Projex APIs
- **AND** it SHALL explain AccessToken acquisition
