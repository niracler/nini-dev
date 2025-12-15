## ADDED Requirements

### Requirement: Slide Type Annotation

Every slide SHALL have a type annotation in speaker notes indicating presentation pacing.

#### Scenario: Type annotation format

- **WHEN** a slide is created or reviewed
- **THEN** speaker notes MUST begin with one of: `🔴 重点`, `⚡ 快速带过`, or `💻 Coding 演示`

#### Scenario: Key concept slide

- **WHEN** a slide covers a core concept or critical insight
- **THEN** it is annotated as `🔴 重点` with detailed speaking points

#### Scenario: Transition slide

- **WHEN** a slide provides background context or transitions between sections
- **THEN** it is annotated as `⚡ 快速带过`

#### Scenario: Demo slide

- **WHEN** a slide requires live coding demonstration
- **THEN** it is annotated as `💻 Coding 演示` with demo preparation notes

### Requirement: Footnote Recommendation Marker

Footnotes referencing highly recommended source materials SHALL be marked with ⭐.

#### Scenario: Recommended source marking

- **WHEN** a footnote references a canonical resource or essential reading
- **THEN** the footnote description is prefixed with ⭐

#### Scenario: Marker placement

- **WHEN** ⭐ marker is used
- **THEN** it appears after the superscript number and before the source level indicator (e.g., `<sup>1</sup> ⭐ 🔬 L1 | ...`)

### Requirement: Best Practice Page

The presentation SHALL include a page demonstrating the Prompt → OpenSpec → Skill workflow as a practical Context Engineering example.

#### Scenario: Best Practice content

- **WHEN** user navigates to the Best Practice page
- **THEN** it shows a concrete workflow example with visual diagram

#### Scenario: Page placement

- **WHEN** the presentation structure is reviewed
- **THEN** Best Practice page appears in Part 4 (Proper Usage) section

### Requirement: Tool Recommendations Integration

Tool recommendations (MCP servers, Skills, AI resources) SHALL be integrated into relevant concept pages rather than standalone pages.

#### Scenario: MCP recommendation

- **WHEN** MCP concept is explained
- **THEN** practical MCP server recommendations are included in footnotes or supplementary content

#### Scenario: Resource consolidation

- **WHEN** AI frontier resources are referenced
- **THEN** they appear as footnotes on relevant concept pages, not as separate "resource list" pages

## MODIFIED Requirements

### Requirement: Slide Count Constraint

The presentation SHALL contain no more than 30 slides. This is a hard limit requiring content merging and trimming, not condensing.

#### Scenario: Total slide count

- **WHEN** the presentation refinement is complete
- **THEN** the total number of slides does not exceed 30

#### Scenario: Content prioritization

- **WHEN** content exceeds slide allocation for a section
- **THEN** slides are merged or non-essential content is removed (retained only in VitePress manuscript version)

#### Scenario: Merge decision

- **WHEN** user reviews a slide during refinement
- **THEN** user decides whether to merge with adjacent slides based on content coherence
