# blog-indieweb Specification

## Purpose

TBD - created by archiving change enhance-blog-features. Update Purpose after archive.

## Requirements

### Requirement: Webmention Endpoint

The blog SHALL advertise a Webmention endpoint for receiving mentions.

#### Scenario: Webmention discovery

- **WHEN** another site parses the blog's HTML
- **THEN** they can discover the Webmention endpoint via `<link rel="webmention">`

### Requirement: Webmention Display

Article pages SHALL display received Webmentions.

#### Scenario: Display likes

- **WHEN** an article has received likes via Webmention
- **THEN** the likes are displayed as a row of avatars

#### Scenario: Display reposts

- **WHEN** an article has been reposted via Webmention
- **THEN** the reposts are displayed with source links

#### Scenario: Display mentions

- **WHEN** an article has been mentioned via Webmention
- **THEN** the mentions are displayed similar to comments

#### Scenario: No webmentions

- **WHEN** an article has no received Webmentions
- **THEN** the Webmention section is hidden or shows an empty state

### Requirement: h-card Microformat

The about page SHALL include an h-card microformat for author identity.

#### Scenario: Author identity

- **WHEN** a Webmention consumer parses the about page
- **THEN** they can extract author name, photo, and website URL from h-card
