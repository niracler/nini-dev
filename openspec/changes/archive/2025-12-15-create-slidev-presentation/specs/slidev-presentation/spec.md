## ADDED Requirements

### Requirement: Slidev Presentation Structure

The AI programming share project SHALL provide a Slidev-based presentation alongside the existing VitePress documentation.

#### Scenario: Developer runs Slidev dev server

- **WHEN** developer runs `pnpm slidev` in the project root
- **THEN** Slidev dev server starts and serves the presentation at localhost

#### Scenario: Presentation contains all parts

- **WHEN** user navigates through the presentation
- **THEN** all parts (Opening, History, Pitfalls, Proper Usage) are accessible

### Requirement: Terminology Consistency

The project SHALL maintain consistent terminology across both Slidev slides and VitePress documentation.

#### Scenario: Technical terms are unified

- **WHEN** a technical term (e.g., Token, Agent, MCP) appears in any document
- **THEN** it uses the standardized form defined in the terminology table

#### Scenario: First occurrence includes full form

- **WHEN** an acronym (e.g., RLHF, RAG, CoT) first appears in a section
- **THEN** the full form is provided alongside the acronym

### Requirement: Visual Anchor Constraint

Every slide SHALL contain at least one informative visual element. Pure text slides are prohibited.

#### Scenario: Valid visual anchors

- **WHEN** a slide is created
- **THEN** it MUST include at least one of: external screenshot, Mermaid diagram, code block, data visualization, or comparison table with real data

#### Scenario: Decorative elements rejected

- **WHEN** a slide only contains colored cards, emoji lists, borders, or background gradients with text
- **THEN** the slide is considered "pure text" and MUST be redesigned with an informative visual anchor

### Requirement: Visual Diagram Support

The project SHALL convert ASCII diagrams to proper visual formats.

#### Scenario: Mermaid diagrams render correctly

- **WHEN** a slide contains a Mermaid diagram
- **THEN** the diagram renders as a visual flowchart/architecture diagram

#### Scenario: Complex diagrams use images

- **WHEN** a diagram is too complex for Mermaid
- **THEN** a professionally created image is used instead (stored in `public/images/`)

### Requirement: Reference Link Validation

The project SHALL ensure all reference links are valid and accurate.

#### Scenario: Link accessibility check

- **WHEN** the link validation script runs
- **THEN** all footnote links are checked for HTTP accessibility

#### Scenario: Broken link handling

- **WHEN** a link is found to be broken
- **THEN** it is either replaced with an alternative source, archived link, or marked as unavailable

### Requirement: Footnote Detail Level

Footnotes SHALL be detailed enough that readers can understand the core information without clicking the link.

#### Scenario: Research source footnote

- **WHEN** a footnote references a research study
- **THEN** it includes: sample size, methodology, key conclusion, and applicable scope

#### Scenario: Tool/product footnote

- **WHEN** a footnote references a tool or product
- **THEN** it includes: what it is, what problem it solves, and core features

#### Scenario: Opinion footnote

- **WHEN** a footnote references an opinion piece
- **THEN** it includes: who said it, their background, and the core argument

### Requirement: PDF Export

The presentation SHALL support PDF export for offline distribution.

#### Scenario: Export to PDF

- **WHEN** developer runs `pnpm slidev export`
- **THEN** a PDF file is generated containing all slides

### Requirement: Speaker Notes

The presentation SHALL include speaker notes for presenter reference.

#### Scenario: Presenter view shows notes

- **WHEN** presenter enters presenter mode
- **THEN** speaker notes are visible alongside the current slide

### Requirement: Single-Slide Workflow

Each apply operation SHALL process exactly one slide. Cross-slide batch processing is prohibited.

#### Scenario: One slide per apply

- **WHEN** AI assistant implements a slide
- **THEN** only one slide is created or modified before awaiting user review

#### Scenario: Review gate

- **WHEN** a slide is completed
- **THEN** user MUST approve it before the next slide can be started

#### Scenario: Rejection handling

- **WHEN** user rejects a slide
- **THEN** the slide is redesigned from scratch (research → narrative → design → review)

### Requirement: Automated Slide Verification

Each slide SHALL be verified via Playwright screenshot before user review.

#### Scenario: Playwright screenshot

- **WHEN** a slide design is completed
- **THEN** a screenshot is captured using Playwright MCP to verify layout correctness

#### Scenario: Layout validation

- **WHEN** the screenshot is reviewed
- **THEN** text overflow, spacing issues, and Mermaid rendering are checked

### Requirement: Manuscript Synchronization

VitePress documentation SHALL be updated in sync with each slide completion.

#### Scenario: Slide-to-doc sync

- **WHEN** a slide is approved
- **THEN** the corresponding VitePress document section is updated to match

### Requirement: Slide Count Constraint

The presentation SHALL contain no more than 50 slides. This is a hard limit requiring content trimming, not condensing.

#### Scenario: Total slide count

- **WHEN** the presentation is complete
- **THEN** the total number of slides does not exceed 50

#### Scenario: Content prioritization

- **WHEN** content exceeds slide allocation for a section
- **THEN** non-essential content is removed from PPT (retained only in VitePress manuscript version)
