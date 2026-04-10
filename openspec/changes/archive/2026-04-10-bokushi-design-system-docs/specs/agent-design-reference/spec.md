## ADDED Requirements

### Requirement: DESIGN.md Standard Structure

`repos/bokushi/DESIGN.md` SHALL follow the awesome-design-md 9-section format, providing a complete, agent-consumable design specification.

#### Scenario: File location and format

- **WHEN** an AI agent needs design context for bokushi
- **THEN** `DESIGN.md` MUST exist at `repos/bokushi/DESIGN.md`
- **AND** the file MUST be written in English

#### Scenario: Required sections

- **WHEN** the DESIGN.md is created
- **THEN** it MUST contain exactly these 9 sections in order:
  1. Visual Theme & Atmosphere
  2. Color Palette & Roles
  3. Typography Rules
  4. Component Stylings
  5. Layout Principles
  6. Depth & Elevation
  7. Do's and Don'ts
  8. Responsive Behavior
  9. Agent Prompt Guide

### Requirement: Color Palette Coverage

The Color Palette & Roles section SHALL enumerate all semantic color tokens from `tokens.css` with hex values and functional roles.

#### Scenario: Light and dark theme coverage

- **WHEN** listing color tokens
- **THEN** MUST include both light and dark theme values for each token
- **AND** MUST organize by semantic role (background, text, accent, border, state)

#### Scenario: Accent color system

- **WHEN** documenting accent colors
- **THEN** MUST include the full tint scale (`accent`, `accent-dark`, `accent-soft`, `accent-tint-6/8/12/18`)

### Requirement: Component Stylings Coverage

The Component Stylings section SHALL document all component classes from `global.css` with their states.

#### Scenario: Card variants

- **WHEN** documenting `.surface-card`
- **THEN** MUST list all variants (`--soft`, `--flat`, `--compact`) and hover behaviors (`--hover-border`, `--hover-none`)
- **AND** MUST include the specific CSS properties for each variant

#### Scenario: Interactive component states

- **WHEN** documenting `.icon-btn`, `.pill`, `.underline-link`
- **THEN** MUST include default, hover, and focus-visible states

### Requirement: Agent Prompt Guide

Section 9 SHALL provide a quick-reference color lookup table and example prompts for AI agents.

#### Scenario: Color lookup table

- **WHEN** an agent needs to reference a color
- **THEN** the prompt guide MUST include a name-to-hex mapping table for the most-used tokens (at minimum: page background, surface, text primary/secondary/muted, accent, border)

#### Scenario: Example prompts

- **WHEN** providing agent guidance
- **THEN** MUST include 2-3 example prompts demonstrating how to reference the design system (e.g., "Create a card using surface-card with hover-border variant")

### Requirement: CLAUDE.md Reference Update

`repos/bokushi/CLAUDE.md` SHALL reference `DESIGN.md` as the agent design reference.

#### Scenario: Design Reference section update

- **WHEN** DESIGN.md is created
- **THEN** the "Design Reference" section in CLAUDE.md MUST mention DESIGN.md alongside the existing `design-primitives` reference
