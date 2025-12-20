## MODIFIED Requirements

### Requirement: Visual Anchor Constraint

Every slide SHALL contain at least one informative visual element. Pure text slides are prohibited.

#### Scenario: Valid visual anchors

- **WHEN** a slide is created
- **THEN** it MUST include at least one of: external screenshot, Mermaid diagram, code block, data visualization, or comparison table with real data

#### Scenario: Decorative elements rejected

- **WHEN** a slide only contains colored cards, emoji lists, borders, or background gradients with text
- **THEN** the slide is considered "pure text" and MUST be redesigned with an informative visual anchor

#### Scenario: External image replacement

- **WHEN** an external image contains dense text that is hard to read during presentation
- **THEN** the core information SHALL be extracted and presented using native Slidev elements (Mermaid diagrams, structured layouts, code blocks) instead of the image
