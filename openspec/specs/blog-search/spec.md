# blog-search Specification

## Purpose

TBD - created by archiving change enhance-blog-features. Update Purpose after archive.

## Requirements

### Requirement: Full-Text Search

The blog SHALL provide full-text search functionality using Pagefind.

#### Scenario: User searches for content

- **WHEN** user opens search modal (via icon or Cmd/Ctrl+K)
- **THEN** a search input is displayed
- **AND** user can type search query
- **AND** results are displayed in real-time

#### Scenario: Search results display

- **WHEN** search query matches content
- **THEN** matching articles are listed with title, excerpt, and highlighted matches
- **AND** results are clickable to navigate to the article

#### Scenario: No results found

- **WHEN** search query matches no content
- **THEN** an empty state message is displayed

### Requirement: Search Scope

The search index SHALL include all published content from blog, til, and monthly collections.

#### Scenario: Content is indexed

- **WHEN** the site is built
- **THEN** Pagefind indexes all content in blog, til, and monthly directories
- **AND** the search index is generated in `_pagefind/` directory

### Requirement: Keyboard Navigation

The search modal SHALL support keyboard navigation.

#### Scenario: Open search with keyboard

- **WHEN** user presses Cmd/Ctrl+K
- **THEN** the search modal opens with focus on input

#### Scenario: Close search with keyboard

- **WHEN** user presses Escape while search modal is open
- **THEN** the search modal closes
