## MODIFIED Requirements

### Requirement: Automatic taste profile generation

The system SHALL analyze Pinboard bookmark history to extract interest patterns and generate a taste profile document in Chinese, stored as a markdown file in the GitHub repository. The generation prompt SHALL include an explicit, prominently-placed Chinese language constraint.

#### Scenario: Profile generation from Pinboard data

- **WHEN** the taste profile update workflow is triggered
- **THEN** the system fetches recent Pinboard bookmarks (titles, URLs, tags, extended descriptions), sends them to the AI model for interest pattern analysis, and writes the resulting taste profile in Chinese to `profile/taste.md` in the GitHub repository

#### Scenario: First-time generation (cold start)

- **WHEN** no `profile/taste.md` exists in the repository
- **THEN** the system fetches all available Pinboard bookmarks (via `/posts/all`), generates an initial comprehensive taste profile in Chinese, and creates the file

#### Scenario: English bookmark data

- **WHEN** the majority of Pinboard bookmarks have English titles, tags, or descriptions
- **THEN** the generated taste profile MUST still be entirely in Chinese; English terms MAY appear only as proper nouns (e.g., "Home Assistant", "Claude Code")

### Requirement: Taste profile content structure

The taste profile document SHALL include structured sections in Chinese that can be consumed as a system prompt by the daily scoring workflow.

#### Scenario: Generated profile content

- **WHEN** the profile is generated or updated
- **THEN** the output includes in Chinese: core interest areas with relative weights, specific topics of current focus, content types preferred, sources particularly valued, topics to deprioritize or exclude, and recent interest shifts detected from bookmark patterns

#### Scenario: No English paragraphs

- **WHEN** the profile is generated or updated
- **THEN** the output MUST NOT contain full English paragraphs or sentences (isolated English proper nouns within Chinese text are acceptable)
