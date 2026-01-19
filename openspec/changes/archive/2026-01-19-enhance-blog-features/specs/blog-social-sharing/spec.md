# Blog Social Sharing

## ADDED Requirements

### Requirement: Share Sidebar

Article pages SHALL display a share sidebar on the left side of the content.

#### Scenario: Share sidebar visibility

- **WHEN** user views an article page on desktop
- **THEN** a share sidebar is visible on the left side
- **AND** the sidebar remains fixed during scroll

#### Scenario: Share sidebar on mobile

- **WHEN** user views an article page on mobile
- **THEN** share buttons are displayed as a floating button or bottom toolbar

### Requirement: Share to Twitter

Users SHALL be able to share articles to Twitter/X.

#### Scenario: Share to Twitter

- **WHEN** user clicks the Twitter share button
- **THEN** a new window opens with Twitter compose dialog
- **AND** the tweet is pre-filled with article title and URL

### Requirement: Share to Telegram

Users SHALL be able to share articles to Telegram.

#### Scenario: Share to Telegram

- **WHEN** user clicks the Telegram share button
- **THEN** a new window opens with Telegram share dialog
- **AND** the message is pre-filled with article title and URL

### Requirement: Copy Link

Users SHALL be able to copy the article URL to clipboard.

#### Scenario: Copy link success

- **WHEN** user clicks the copy link button
- **THEN** the article URL is copied to clipboard
- **AND** a success toast notification is displayed
