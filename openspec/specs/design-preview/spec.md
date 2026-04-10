## Purpose

A publicly deployed Astro page for visual demonstration and screenshot capture of the design system. Not linked from navigation. Screenshots embedded in README for project visual identity.

## Requirements

### Requirement: Design Preview Page

A publicly deployed Astro page SHALL exist for visual demonstration of the design system.

#### Scenario: Page structure

- **WHEN** the preview page is created
- **THEN** an Astro page file MUST exist under `src/pages/`
- **AND** it MUST compose the showcase components (`ColorPalette`, `TypographyScale`, component showcases)
- **AND** it MUST include a page title and brief introduction

#### Scenario: Public deployment

- **WHEN** running `pnpm build`
- **THEN** the page MUST be included in the `dist/` output
- **AND** the page MUST NOT appear in any site navigation or sitemap

#### Scenario: Theme support

- **WHEN** viewing the preview page
- **THEN** it MUST respect the site's light/dark theme switching mechanism

### Requirement: README Screenshots

Design preview screenshots SHALL be embedded in the project README for visual first impression.

#### Scenario: Screenshot files

- **WHEN** screenshots are captured
- **THEN** light theme and dark theme screenshot PNGs MUST exist under project assets
- **AND** screenshots MUST be captured from the design preview page

#### Scenario: README integration

- **WHEN** viewing `README.md`
- **THEN** both light and dark screenshots MUST be embedded and visible
