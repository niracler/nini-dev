## ADDED Requirements

### Requirement: Heuristic pre-filtering

The skill SHALL pre-filter bookmarks using heuristic rules to identify candidates for AI timeliness analysis, reducing the number of bookmarks that need content fetching.

The heuristic pipeline SHALL apply three filters in order:

1. **Tag filter**: Include only bookmarks with tech-related tags (`llm`, `programming`, `python`, `javascript`, `typescript`, `web`, `devops`, `cloudflare`, `shell`, `github`, `database`, `security`, `home_assistant`, `iot`, `zigbee`). Exclude bookmarks tagged with `evergreen`, `reference`, or `collection`.
2. **Age filter**: Include bookmarks saved more than 2 years ago (based on Pinboard `time` field).
3. **Version detection**: Include bookmarks whose title or URL contains version number patterns (e.g., `React 16`, `v2.x`, `Python 3.8`, `ES6`), regardless of age.

A bookmark matching filter 1 AND (filter 2 OR filter 3) SHALL be considered a candidate.

#### Scenario: Tech bookmark older than 2 years

- **WHEN** a bookmark has tag `javascript` and was saved 3 years ago
- **THEN** it is included in the candidate list for AI analysis

#### Scenario: Tech bookmark with version number in title

- **WHEN** a bookmark has tag `python` and title contains "Python 3.8"
- **AND** it was saved 1 year ago (under the 2-year threshold)
- **THEN** it is still included in the candidate list due to version detection

#### Scenario: Non-tech bookmark excluded

- **WHEN** a bookmark has tag `game` and was saved 5 years ago
- **THEN** it is NOT included in the candidate list

#### Scenario: Evergreen bookmark excluded

- **WHEN** a bookmark has tags `programming evergreen` and was saved 4 years ago
- **THEN** it is NOT included in the candidate list

### Requirement: Content fetching via Jina Reader

The skill SHALL fetch bookmark content using Jina Reader (`r.jina.ai`) to convert web pages into LLM-friendly Markdown.

#### Scenario: Successful content fetch

- **WHEN** skill needs to analyze a candidate bookmark
- **THEN** skill fetches content via `curl -s "https://r.jina.ai/URL"`
- **AND** truncates the result to the first 5000 characters

#### Scenario: Jina Reader unavailable

- **WHEN** Jina Reader returns an error or empty response
- **THEN** skill marks the bookmark as "unable to fetch" and skips it
- **AND** continues with the next candidate

#### Scenario: Rate limiting between fetches

- **WHEN** skill fetches content for multiple candidates
- **THEN** skill waits 2 seconds between each Jina Reader request

### Requirement: AI timeliness analysis

The skill SHALL use the current Claude session to analyze fetched content and determine whether the bookmark's content is outdated.

The AI analysis SHALL output for each candidate:

- **Status**: `outdated` / `possibly_outdated` / `still_valid`
- **Reason**: One sentence explaining the assessment
- **Suggestion**: `delete` / `mark_evergreen` / `keep`

#### Scenario: Outdated content detected

- **WHEN** fetched content discusses deprecated APIs, old framework versions, or superseded practices
- **THEN** AI marks it as `outdated` with a specific reason
- **AND** suggests `delete`

#### Scenario: Possibly outdated content

- **WHEN** fetched content references specific versions but the core concepts may still apply
- **THEN** AI marks it as `possibly_outdated` with a reason
- **AND** suggests `keep`

#### Scenario: Still valid content

- **WHEN** fetched content discusses concepts, patterns, or approaches that remain current
- **THEN** AI marks it as `still_valid`
- **AND** suggests `mark_evergreen`

### Requirement: Batch presentation and user action

The skill SHALL present timeliness analysis results in batches of 5 and let the user decide on each bookmark.

#### Scenario: User triggers timeliness check

- **WHEN** user says "pinboard 检查时效" or "pinboard timeliness check"
- **THEN** skill runs heuristic pre-filtering on all bookmarks
- **THEN** skill reports the number of candidates found
- **THEN** skill begins fetching and analyzing candidates in batches of 5

#### Scenario: Presenting a batch

- **WHEN** a batch of 5 candidates has been analyzed
- **THEN** skill shows each bookmark's title, URL, tags, AI status, reason, and suggestion
- **AND** offers options: confirm suggestions / modify individual / skip all

#### Scenario: User confirms deletion

- **WHEN** user confirms deletion for a bookmark marked as `outdated`
- **THEN** skill deletes it via Pinboard `/posts/delete` API

#### Scenario: User marks as evergreen

- **WHEN** user confirms marking a bookmark as evergreen
- **THEN** skill adds `evergreen` to its tags via `/posts/add` API (preserving all other fields)

#### Scenario: User skips

- **WHEN** user skips a bookmark
- **THEN** skill moves to the next item without changes

#### Scenario: Summary after all batches

- **WHEN** all candidates have been processed
- **THEN** skill shows a summary: total candidates, outdated (deleted/kept), evergreen marked, skipped
