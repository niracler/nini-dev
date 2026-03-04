## MODIFIED Requirements

### Requirement: Tag audit mode

The skill SHALL provide an interactive tag audit mode that pulls all bookmarks from Pinboard, identifies tag issues according to the tag convention, and presents them to the user for review and correction.

Tag issues SHALL be categorized as:

- Typos (e.g., `ainme` → `anime`, `editer` → `editor`)
- Case inconsistency (e.g., `Health` → `health`)
- Chinese tags that need English equivalents
- Missing tags (bookmarks with no tags)
- Conceptual overlap (multiple tags meaning the same thing)

#### Scenario: User triggers tag audit

- **WHEN** user says "pinboard 整理 tag" or "pinboard audit"
- **THEN** skill fetches all bookmarks via `/posts/all` API
- **THEN** skill groups issues by category and presents 5-10 items per batch
- **THEN** skill shows the current tag(s) and suggested replacement(s) for each item

#### Scenario: User confirms tag changes

- **WHEN** user confirms a batch of suggested changes
- **THEN** skill applies changes via Pinboard `/posts/add` API (overwrite mode)
- **THEN** skill passes all original fields (description, extended, shared, toread) to avoid data loss
- **THEN** skill shows a summary of applied changes

#### Scenario: User skips a suggestion

- **WHEN** user says "skip" or "跳过" for a suggestion
- **THEN** skill moves to the next item without making changes

#### Scenario: User triggers timeliness check from mode selection

- **WHEN** user says "pinboard 检查时效" or "pinboard timeliness check" or "pinboard 过时检测"
- **THEN** skill enters timeliness check mode as defined in `pinboard-timeliness` spec
