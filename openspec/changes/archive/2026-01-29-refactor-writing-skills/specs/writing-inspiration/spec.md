## ADDED Requirements

### Requirement: Skill discovery via CSO-compliant description
The skill SHALL have a description that starts with "Use when" and describes triggering conditions without summarizing the workflow.

#### Scenario: User triggers writing inspiration skill
- **WHEN** user says「不知道写什么」「帮我构思」「写游记」「记录 TIL」
- **THEN** Claude Code loads the writing-inspiration skill

### Requirement: Article type identification
The skill SHALL identify the type of article user wants to write and select appropriate framework.

#### Scenario: Travel writing
- **WHEN** user mentions travel or trip
- **THEN** system uses travel writing framework (departure → journey → reflection)

#### Scenario: TIL writing
- **WHEN** user mentions learning or technical discovery
- **THEN** system uses TIL framework (background → process → solution → takeaway)

#### Scenario: General article
- **WHEN** article type is unclear
- **THEN** system uses general framework (motivation → viewpoint → elaboration → conclusion)

### Requirement: Inspirational questioning not dictation
The skill SHALL use questions to inspire thinking, not write content for the user.

#### Scenario: Sequential questioning
- **WHEN** user is working on an article section
- **THEN** system asks ONE question at a time and waits for user response

#### Scenario: Confirm before next
- **WHEN** user answers a question
- **THEN** system confirms understanding before moving to next question

### Requirement: Framework-based question templates
The skill SHALL provide appropriate questions for each article type.

#### Scenario: Travel sensory questions
- **WHEN** writing travel article
- **THEN** system asks about what user saw, heard, smelled, tasted

#### Scenario: TIL problem-solving questions
- **WHEN** writing TIL
- **THEN** system asks about problem encountered, attempts made, final solution

### Requirement: Lightweight without complex configuration
The skill SHALL work without requiring user configuration files.

#### Scenario: No config needed
- **WHEN** user triggers the skill
- **THEN** system works immediately without reading config files
