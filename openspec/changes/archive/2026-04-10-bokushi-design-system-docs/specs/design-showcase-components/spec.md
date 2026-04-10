## ADDED Requirements

### Requirement: ColorPalette Component

`src/components/design/ColorPalette.astro` SHALL render a grid of color swatches using the blog's live CSS variables.

#### Scenario: Swatch rendering

- **WHEN** the component is rendered in a blog post
- **THEN** MUST display swatches for all semantic color groups (background, text, accent, border, state)
- **AND** each swatch MUST use `var(--color-*)` as its background (ensuring visual accuracy)
- **AND** each swatch MUST display the token name and hex value as text labels

#### Scenario: Theme responsiveness

- **WHEN** the user switches between light and dark themes
- **THEN** swatch backgrounds MUST update automatically (via CSS variables)
- **AND** hex value labels MAY remain static (acceptable trade-off per design decision)

### Requirement: TypographyScale Component

`src/components/design/TypographyScale.astro` SHALL render text samples at each level of the type hierarchy.

#### Scenario: Scale rendering

- **WHEN** the component is rendered
- **THEN** MUST display actual text at each font size (font-size-2xs through font-size-3xl)
- **AND** each sample MUST show the size name, pixel value, and rem value

#### Scenario: Heading hierarchy

- **WHEN** displaying heading levels
- **THEN** MUST demonstrate h1 through h4 with their actual font-size, font-weight, and line-height values

### Requirement: ComponentShowcase Component

`src/components/design/ComponentShowcase.astro` SHALL render live examples of the blog's UI components.

#### Scenario: Card variants

- **WHEN** the component is rendered
- **THEN** MUST display `.surface-card` in all variants: default, `--soft`, `--flat`, `--compact`
- **AND** MUST display hover variant indicators (`--hover-border`, `--hover-none`)

#### Scenario: Pill/Tag variants

- **WHEN** displaying pill components
- **THEN** MUST show default `.pill` and accent-toned `.pill[data-tone="accent"]`

#### Scenario: Shadow levels

- **WHEN** displaying elevation examples
- **THEN** MUST show cards with `shadow-soft` and `shadow-strong` side by side

### Requirement: Component Architecture

All showcase components SHALL be pure Astro components with no client-side JavaScript.

#### Scenario: Zero JS overhead

- **WHEN** a showcase component is included in an MDX post
- **THEN** MUST NOT ship any client-side JavaScript
- **AND** MUST NOT require hydration directives (`client:load`, `client:visible`, etc.)

#### Scenario: Component location

- **WHEN** the components are created
- **THEN** all MUST reside under `src/components/design/`
- **AND** filenames MUST use PascalCase (matching project convention)
