## ADDED Requirements

### Requirement: Skill discovery via CSO-compliant description

The skill SHALL have a description that starts with "Use when" and describes triggering conditions without summarizing the workflow.

#### Scenario: User triggers diary skill

- **WHEN** user says「帮我写日记」「记录今天」「写日记」
- **THEN** Claude Code loads the diary-assistant skill

### Requirement: Pre-diary clarification

The skill SHALL confirm the diary date and file path before proceeding.

#### Scenario: Confirm diary date

- **WHEN** user triggers diary skill
- **THEN** system asks「今天的日记是 YYYY-MM-DD.md 吗？」using the current date

#### Scenario: Use configured diary path

- **WHEN** user-config.md specifies diary_path
- **THEN** system reads diary template from that path

### Requirement: Existing diary file handling

The skill SHALL detect if the diary file already exists and offer options.

#### Scenario: Diary file exists

- **WHEN** diary file for the date already exists
- **THEN** system asks user to choose: 继续（continue editing）/ 追加（append）/ 重新开始（overwrite）

#### Scenario: New diary file

- **WHEN** diary file does not exist
- **THEN** system proceeds to create new file based on template

### Requirement: Simplified task review with batch selection

The skill SHALL fetch today's Reminders and allow batch selection of completed tasks.

#### Scenario: Fetch today's tasks

- **WHEN** diary session starts after date confirmation
- **THEN** system calls schedule-manager to get today's Reminders

#### Scenario: Display task list for batch selection

- **WHEN** today has planned tasks
- **THEN** system displays numbered list and asks「哪些完成了？（输入序号，如「1,3」，或「全部」/「都没完成」）」

#### Scenario: Defer incomplete tasks to tomorrow

- **WHEN** user indicates which tasks are complete
- **THEN** system marks completed tasks as done, defers remaining to tomorrow by default

#### Scenario: No tasks today

- **WHEN** today has no planned tasks
- **THEN** system skips task review step

### Requirement: Mandatory Work Log on workdays

The skill SHALL automatically fetch Work Log from git/yunxiao on workdays without asking.

#### Scenario: Workday Work Log

- **WHEN** current day is Monday-Friday
- **THEN** system automatically fetches commits from configured repos

#### Scenario: Weekend skips Work Log

- **WHEN** current day is Saturday or Sunday
- **THEN** system skips Work Log fetching

### Requirement: Adaptive inspirational questioning

The skill SHALL ask different questions based on whether it's a workday or weekend, with final question always about future plans.

#### Scenario: Workday questions (Work Log already recorded work content)

- **WHEN** current day is workday and Work Log is fetched
- **THEN** system asks:
  - Q1:「工作之外，今天还有什么想记录的？」
  - Q2:「之后有什么计划？」

#### Scenario: Weekend questions (no Work Log)

- **WHEN** current day is weekend
- **THEN** system asks:
  - Q1:「今天做了什么？」
  - Q2:「有什么收获或感受？」
  - Q3:「之后有什么计划？」

#### Scenario: Sequential questioning

- **WHEN** user answers a question
- **THEN** system confirms or follows up, then moves to next question

### Requirement: Integrated task capture in final question

The skill SHALL capture future tasks from the final question and create Reminders directly.

#### Scenario: Parse task from plan answer

- **WHEN** user answers「之后有什么计划？」with items like「下周要交报告」「周五开会」
- **THEN** system parses date and task content

#### Scenario: Confirm before creating Reminders

- **WHEN** tasks are parsed from user's answer
- **THEN** system shows parsed tasks with dates for quick confirmation before creating Reminders

#### Scenario: Create Reminders

- **WHEN** user confirms parsed tasks
- **THEN** system calls schedule-manager to create Reminders

### Requirement: Smart follow-up based on content

The skill SHALL detect diary content and recommend relevant actions.

#### Scenario: Detect TIL content

- **WHEN** diary contains TIL (Today I Learned) content
- **THEN** system asks「检测到你今天学了新东西，要生成 Anki 卡片吗？」

#### Scenario: Generate Anki cards

- **WHEN** user confirms Anki generation
- **THEN** system calls anki-card-generator skill

### Requirement: No git commit for Obsidian diaries

The skill SHALL NOT offer git commit for diaries stored in Obsidian.

#### Scenario: Skip git commit

- **WHEN** diary is completed
- **THEN** system does NOT ask about git commit

### Requirement: Time efficiency

The skill SHALL complete the full diary workflow within 45 minutes (one pomodoro).

#### Scenario: Streamlined flow

- **WHEN** executing diary workflow
- **THEN** total time from start to finish should be ≤45 minutes
