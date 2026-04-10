## Purpose

Upgrade the design primitives blog post from static Markdown to interactive MDX with embedded showcase components and expanded content coverage (button system, shadow hierarchy, responsive breakpoints, Do's/Don'ts).

## Requirements

### Requirement: MDX Migration

`design-primitives.md` SHALL be converted to MDX to support embedded Astro components.

#### Scenario: File rename

- **WHEN** migrating the file
- **THEN** MUST use `git mv` to preserve history
- **AND** the new file MUST be an `.mdx` file under `src/content/blog/zh/`

#### Scenario: Frontmatter preservation

- **WHEN** converting to MDX
- **THEN** all existing frontmatter fields (title, description, pubDate, tags, socialImage) MUST be preserved unchanged

#### Scenario: Existing content preservation

- **WHEN** converting to MDX
- **THEN** all existing markdown content MUST be preserved
- **AND** the Apple HIG three-layer structure (Foundations, Patterns, Components) MUST remain

### Requirement: Showcase Component Integration

The MDX post SHALL embed showcase components at relevant positions within the existing content structure.

#### Scenario: Color section

- **WHEN** the reader reaches the Color section under Foundations
- **THEN** a `<ColorPalette />` component MUST be rendered after the existing color description text
- **AND** the existing token table MAY be kept alongside for reference

#### Scenario: Typography section

- **WHEN** the reader reaches the Typography section
- **THEN** a `<TypographyScale />` component MUST be rendered showing live font samples

#### Scenario: Components section

- **WHEN** the reader reaches the Components section
- **THEN** a `<ComponentShowcase />` component MUST be rendered showing card variants, pills, and elevation examples

### Requirement: Content Gap Completion

The upgraded post SHALL fill existing content gaps by extracting information from the current codebase.

#### Scenario: Button system documentation

- **WHEN** documenting interactive elements
- **THEN** MUST include the `.icon-btn` system (size variants `--xs/--sm/--md`, shape variants `--round/--square`, border variant `--bordered`)
- **AND** content MUST be extracted from `global.css`, not newly designed

#### Scenario: Shadow hierarchy documentation

- **WHEN** documenting depth and elevation
- **THEN** MUST document `shadow-soft`, `shadow-strong`, `shadow-lightbox`, and `shadow-button-hover` as distinct elevation levels
- **AND** MUST note the difference between light and dark mode shadow intensity

#### Scenario: Responsive breakpoints documentation

- **WHEN** documenting responsive behavior
- **THEN** MUST document the breakpoints used in the codebase (640px for sm, 48rem/768px for table card mode)
- **AND** MUST describe the table-to-card responsive pattern

#### Scenario: Do's and Don'ts summary

- **WHEN** documenting design guardrails
- **THEN** MUST consolidate scattered rules into a unified list, including:
  - Warm color palette only (no cool tones)
  - Hover uses color/border changes only (no translateY)
  - Single accent color system
  - Content-first UI philosophy
