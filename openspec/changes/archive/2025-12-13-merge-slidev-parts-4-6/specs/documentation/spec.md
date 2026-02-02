## MODIFIED Requirements

### Requirement: AI Programming Share Presentation Structure

The AI programming share presentation SHALL be organized into the following parts:

1. Part 1: 开场（~5min）
2. Part 2: AI 编程简史与核心概念（~40min）
3. Part 3: 我的踩坑故事（~15min）
4. Part 4: 正确使用 AI 编程（~35-40min）
5. Part 5: 附录

Part 4 SHALL contain the following sections:

- 4.1 心智模型
- 4.2 Context Engineering 实操
- 4.3 CLAUDE.md 与工具链
- 4.4 现场演示
- 4.5 使用边界
- 4.6 团队采用
- 4.7 Q&A 与资源

#### Scenario: Presentation covers AI mental model

- **WHEN** presenting section 4.1
- **THEN** the content explains "AI is a simulator, not an entity" mental model
- **AND** demonstrates correct prompting posture (ask "what would an expert say" instead of "what do you think")

#### Scenario: Presentation includes live demo

- **WHEN** presenting section 4.4
- **THEN** the demo shows building a clock app from scratch
- **AND** demonstrates deploying to GitHub Pages
- **AND** showcases Git Workflow Skill usage

#### Scenario: Presentation covers team adoption

- **WHEN** presenting section 4.6
- **THEN** the content includes the OCaml 13K PR case study
- **AND** explains phased adoption strategy
- **AND** covers code review principles

## REMOVED Requirements

### Requirement: Separate Risk and Team Adoption Parts

**Reason**: Part 5 (风险与心智) and Part 6 (团队采用) are merged into Part 4 to reduce redundancy and improve presentation flow.

**Migration**: Content from original Part 5 and Part 6 is selectively merged into new Part 4 sections 4.5, 4.6, and 4.7.
