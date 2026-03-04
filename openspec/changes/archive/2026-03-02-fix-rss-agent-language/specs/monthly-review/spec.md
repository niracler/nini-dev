## MODIFIED Requirements

### Requirement: Reflective writing style

The monthly review SHALL be written in the user's reflective blog style in Chinese, not as a data report. The generation prompt SHALL include an explicit Chinese language constraint placed prominently (near the beginning of the system prompt).

#### Scenario: Output tone and format

- **WHEN** the review is generated
- **THEN** it uses first-person reflective prose in Chinese, with strategic bold for key phrases, conversational asides, and honest self-assessment — matching the style of niracler.com blog posts

#### Scenario: Actionable closing

- **WHEN** the review is generated
- **THEN** it closes with 2-3 concrete reading direction adjustments for the next month in Chinese

#### Scenario: Language enforcement

- **WHEN** the system constructs the AI prompt for monthly review generation
- **THEN** the system prompt MUST include an explicit Chinese language constraint (e.g., "所有输出必须使用中文") placed before the output format requirements, not at the end of the prompt
