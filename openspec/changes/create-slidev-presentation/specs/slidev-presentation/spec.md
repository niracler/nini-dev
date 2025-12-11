## ADDED Requirements

### Requirement: Slidev Presentation Structure

The AI programming share project SHALL provide a Slidev-based presentation alongside the existing VitePress documentation.

#### Scenario: Developer runs Slidev dev server

- **WHEN** developer runs `pnpm slidev` in the project root
- **THEN** Slidev dev server starts and serves the presentation at localhost

#### Scenario: Presentation contains all 6 parts

- **WHEN** user navigates through the presentation
- **THEN** all 6 parts (Opening, History, Pitfalls, Proper Usage, Risks, Team Adoption) are accessible

### Requirement: Terminology Consistency

The project SHALL maintain consistent terminology across both Slidev slides and VitePress documentation.

#### Scenario: Technical terms are unified

- **WHEN** a technical term (e.g., Token, Agent, MCP) appears in any document
- **THEN** it uses the standardized form defined in the terminology table

#### Scenario: First occurrence includes full form

- **WHEN** an acronym (e.g., RLHF, RAG, CoT) first appears in a section
- **THEN** the full form is provided alongside the acronym

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
- **THEN** all ~70 footnote links are checked for HTTP accessibility

#### Scenario: Broken link handling

- **WHEN** a link is found to be broken
- **THEN** it is either replaced with an alternative source, archived link, or marked as unavailable

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

### Requirement: Per-Slide Review Workflow

Each slide SHALL be reviewed and approved by running the presentation before proceeding to the next slide.

#### Scenario: Generate and preview slide

- **WHEN** a new slide draft is created
- **THEN** user runs Slidev dev server to preview the slide visually

#### Scenario: Iterative refinement

- **WHEN** user provides feedback on a slide
- **THEN** the slide is modified and previewed again until approved

#### Scenario: Proceed to next slide

- **WHEN** user approves the current slide
- **THEN** work proceeds to the next slide (not before)

### Requirement: Slide Count Constraint

The presentation SHALL contain no more than 50 slides. This is a hard limit requiring content trimming, not condensing.

#### Scenario: Total slide count

- **WHEN** the presentation is complete
- **THEN** the total number of slides does not exceed 50

#### Scenario: Content prioritization

- **WHEN** content exceeds slide allocation for a section
- **THEN** non-essential content is removed from PPT (retained only in VitePress manuscript version)
