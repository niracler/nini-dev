## ADDED Requirements

### Requirement: Skill discovery via CSO-compliant description
The skill SHALL have a description that starts with "Use when" and describes triggering conditions without summarizing the workflow.

#### Scenario: User triggers proofreading skill
- **WHEN** user says「帮我改文章」「检查一下」「润色」「帮我改改」「校对一下」
- **THEN** Claude Code loads the writing-proofreading skill

### Requirement: Six-step review workflow
The skill SHALL follow a structured review process: structure → reader context → language → sources → style → markdown format.

#### Scenario: Structure diagnosis first
- **WHEN** review starts
- **THEN** system analyzes paragraph structure and proposes 2-3 reorganization options

#### Scenario: Sequential review steps
- **WHEN** one review step is completed
- **THEN** system moves to the next step in order

### Requirement: Section-based review pace
The skill SHALL review content by markdown heading sections, not all at once.

#### Scenario: Review by heading
- **WHEN** reviewing an article
- **THEN** system processes 1-2 heading sections at a time

#### Scenario: Wait for confirmation
- **WHEN** one section review is complete
- **THEN** system waits for user confirmation before next section

### Requirement: Reader context checking
The skill SHALL identify content that might confuse readers.

#### Scenario: Detect unclear assumptions
- **WHEN** text assumes reader knowledge
- **THEN** system flags「读者看这里会不会不明所以？」

#### Scenario: Identify logic jumps
- **WHEN** text has missing logical connections
- **THEN** system suggests adding transitions

### Requirement: Chinese language style guidelines
The skill SHALL check for common Chinese writing issues based on 余光中's guidelines.

#### Scenario: Abstract noun subjects
- **WHEN** text uses abstract nouns as subjects excessively
- **THEN** system suggests using concrete subjects

#### Scenario: Verbose patterns
- **WHEN** text contains redundant phrases like「基于这个原因」
- **THEN** system suggests simplification

### Requirement: Source verification
The skill SHALL check data sources and credibility.

#### Scenario: Source priority
- **WHEN** article cites data
- **THEN** system checks: government > official institutions > academic papers > avoid unsourced blogs

#### Scenario: Data integration
- **WHEN** data is cited
- **THEN** system ensures data is integrated into narrative, not just dropped

### Requirement: Personal style consistency
The skill SHALL check for consistency with user's writing style.

#### Scenario: Signature expressions
- **WHEN** reviewing
- **THEN** system checks for user's characteristic expressions (「怎么说呢」「其实」)

#### Scenario: Bold restraint
- **WHEN** checking formatting
- **THEN** system ensures bold usage is ≤3 per heading section
