## ADDED Requirements

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

### Requirement: Dead link detection mode
The skill SHALL provide a dead link detection mode that checks all bookmarks for broken URLs using HTTP HEAD requests.

#### Scenario: User triggers dead link check
- **WHEN** user says "pinboard 检查死链" or "pinboard check links"
- **THEN** skill fetches all bookmarks via `/posts/all` API
- **THEN** skill checks each URL with HTTP HEAD request (10 second timeout)
- **THEN** skill processes URLs in batches of 10 to avoid rate limiting

#### Scenario: Dead link found
- **WHEN** a URL returns 4xx or 5xx status
- **THEN** skill reports the URL, its title, and the HTTP status code
- **THEN** skill asks user whether to delete or keep the bookmark

#### Scenario: HEAD request rejected by server
- **WHEN** a URL returns 403 or 405 on HEAD request
- **THEN** skill retries with a GET request once before marking as failed

#### Scenario: URL timeout
- **WHEN** a URL does not respond within 10 seconds
- **THEN** skill marks it as "timeout" and includes it in the report for user review

### Requirement: Tag convention reference
The skill SHALL include a `references/tag-convention.md` file defining the tag standard.

The convention SHALL specify:
- All tags in English lowercase
- Multi-word tags use underscore `_` as separator
- Singular form preferred (`tool` not `tools`)
- Two tag layers: topic tags (what it's about) and meta tags (what kind of content)
- A canonical list of approved topic tags grouped by category
- A canonical list of meta tags: `evergreen`, `tool`, `reference`, `collection`
- A migration mapping table from existing problematic tags to new canonical tags

#### Scenario: Tag convention is referenced during audit
- **WHEN** skill runs tag audit mode
- **THEN** skill loads tag-convention.md to determine correct tags and identify violations

### Requirement: Pinboard API authentication
The skill SHALL document Pinboard API auth_token configuration in `references/user-config.md` and use the token for all API calls.

#### Scenario: First time setup
- **WHEN** user runs the skill for the first time without a configured token
- **THEN** skill guides user to obtain their auth_token from Pinboard settings
- **THEN** skill explains how to set the token as an environment variable

### Requirement: n8n workflow filters toread from recent posts
The existing n8n pinboard workflow's `/posts/recent` branch SHALL exclude bookmarks where `toread` equals `yes`, in addition to the existing `shared=yes` filter.

#### Scenario: New bookmark saved as toread
- **WHEN** a new bookmark is added with `toread=yes` and `shared=yes`
- **THEN** the `/posts/recent` branch does NOT push it to Telegram

#### Scenario: New bookmark saved as already read
- **WHEN** a new bookmark is added with `toread=no` (or unset) and `shared=yes`
- **THEN** the `/posts/recent` branch pushes it to Telegram as before

### Requirement: n8n workflow detects toread-to-read transitions
The n8n pinboard workflow SHALL include a new branch that detects when bookmarks transition from `toread=yes` to `toread=no` and pushes them to Telegram.

#### Scenario: User marks bookmark as read
- **WHEN** a bookmark previously in the toread list is marked as read (toread=no)
- **AND** the bookmark still exists and has `shared=yes`
- **THEN** workflow pushes it to Telegram

#### Scenario: User deletes a toread bookmark
- **WHEN** a bookmark previously in the toread list is deleted entirely
- **THEN** workflow does NOT push it to Telegram

#### Scenario: User makes a toread bookmark private
- **WHEN** a bookmark previously in the toread list changes to `shared=no`
- **THEN** workflow does NOT push it to Telegram

#### Scenario: First run with empty staticData
- **WHEN** the toread diff branch runs for the first time (no previous toread list stored)
- **THEN** workflow stores the current toread URL list without triggering any pushes
