## ADDED Requirements

### Requirement: Automatic taste profile generation

The system SHALL analyze Pinboard bookmark history to extract interest patterns and generate a taste profile document, stored as a markdown file in the GitHub repository.

#### Scenario: Profile generation from Pinboard data

- **WHEN** the taste profile update workflow is triggered
- **THEN** the system fetches recent Pinboard bookmarks (titles, URLs, tags, extended descriptions), sends them to Kimi K2 for interest pattern analysis, and writes the resulting taste profile to `profile/taste.md` in the GitHub repository

#### Scenario: First-time generation (cold start)

- **WHEN** no `profile/taste.md` exists in the repository
- **THEN** the system fetches all available Pinboard bookmarks (via `/posts/all`), generates an initial comprehensive taste profile, and creates the file

### Requirement: Event-driven profile update

The system SHALL update the taste profile when sufficient new Pinboard activity is detected, rather than on a fixed schedule.

#### Scenario: Threshold reached

- **WHEN** the Pinboard monitoring detects N new bookmarks since the last profile update (N configurable, default: 10)
- **THEN** the system triggers the profile update workflow

#### Scenario: Below threshold

- **WHEN** fewer than N new bookmarks exist since the last update
- **THEN** the system does not trigger a profile update

### Requirement: Taste profile content structure

The taste profile document SHALL include structured sections that can be consumed as a system prompt by the daily scoring workflow.

#### Scenario: Generated profile content

- **WHEN** the profile is generated or updated
- **THEN** the output includes: core interest areas with relative weights, specific topics of current focus, content types preferred (deep analysis vs quick news vs tutorials), sources particularly valued, topics to deprioritize or exclude, and recent interest shifts detected from bookmark patterns

### Requirement: Pinboard behavior signals

The system SHALL interpret different Pinboard behaviors as distinct taste signals.

#### Scenario: Public bookmark (shared=yes, toread=no)

- **WHEN** a bookmark is shared and not marked toread
- **THEN** the system treats it as a strong positive signal (user actively curated and published)

#### Scenario: Toread-to-read transition

- **WHEN** a bookmark transitions from toread=yes to toread=no
- **THEN** the system treats it as a moderate positive signal (user completed reading)

#### Scenario: Bookmark tags

- **WHEN** a bookmark has tags
- **THEN** the system uses tags as high-confidence topic indicators for the taste profile

### Requirement: Profile versioning

The system SHALL preserve profile update history through GitHub commits.

#### Scenario: Profile updated

- **WHEN** the taste profile is regenerated
- **THEN** the system commits the updated `profile/taste.md` with a descriptive commit message including the trigger reason and number of new bookmarks analyzed
