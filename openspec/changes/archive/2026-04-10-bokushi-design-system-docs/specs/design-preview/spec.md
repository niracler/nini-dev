## ADDED Requirements

### Requirement: Design Preview Page

A publicly deployed Astro page SHALL exist at `/design-preview` for visual demonstration of the design system.

#### Scenario: Page structure

- **WHEN** the preview page is created
- **THEN** `src/pages/design-preview.astro` MUST exist
- **AND** it MUST compose the Phase 2 showcase components (`ColorPalette`, `TypographyScale`, `ComponentShowcase`)
- **AND** it MUST include a page title and brief introduction

#### Scenario: Public deployment

- **WHEN** running `pnpm build`
- **THEN** the page MUST be included in the `dist/` output at `/design-preview/`
- **AND** the page MUST NOT appear in any site navigation or sitemap

#### Scenario: Theme support

- **WHEN** viewing the preview page
- **THEN** it MUST respect the site's light/dark theme switching mechanism

### Requirement: README Screenshots

Design preview screenshots SHALL be embedded in the project README for visual first impression.

#### Scenario: Screenshot files

- **WHEN** screenshots are captured
- **THEN** `docs/design-preview-light.png` (light theme) and `docs/design-preview-dark.png` (dark theme) MUST exist
- **AND** screenshots MUST be captured from the `/design-preview` page

#### Scenario: README integration

- **WHEN** viewing `README.md`
- **THEN** both light and dark screenshots MUST be embedded and visible
