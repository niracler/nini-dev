## ADDED Requirements

### Requirement: Script-based note scanning and filtering

The `note-to-blog.py collect` command SHALL scan the Note repository for all `*.md` files, exclude entries already marked in `.note-to-blog.json` (drafted, published, or skipped), and output a structured JSON to stdout.

#### Scenario: First run with no state file

- **WHEN** `collect` runs and `.note-to-blog.json` does not exist
- **THEN** it SHALL create an empty `.note-to-blog.json` at the Note repository root and include all `*.md` files as candidates

#### Scenario: Subsequent run with existing marks

- **WHEN** `collect` runs and `.note-to-blog.json` contains 10 drafted, 5 published, and 20 skipped entries
- **THEN** those 35 files SHALL be excluded from the candidate list

#### Scenario: State file references a deleted note

- **WHEN** a file listed in `.note-to-blog.json` no longer exists on disk
- **THEN** `collect` SHALL silently ignore the missing entry (no error, no cleanup)

### Requirement: Candidate summary extraction

For each candidate file, `collect` SHALL extract the title (from frontmatter `title` or `aliases` field, fallback to filename without `.md`), the first 20 non-empty non-frontmatter lines as summary, the total character count, and a list of outgoing `[[wikilink]]` targets.

#### Scenario: File with Obsidian frontmatter

- **WHEN** a candidate has YAML frontmatter with `aliases`, `tags`, `date`, `modified` fields
- **THEN** `collect` SHALL extract metadata from frontmatter and start the summary from the first line after the closing `---`

#### Scenario: File without frontmatter

- **WHEN** a candidate has no YAML frontmatter
- **THEN** `collect` SHALL use the filename (without `.md`) as the title and extract the first 20 non-empty lines as summary

#### Scenario: File with wikilinks

- **WHEN** a candidate contains `[[优雅的哲学-v2.0]]` and `[[费曼学习法|费曼学习法]]` in its body
- **THEN** `collect` SHALL include `["优雅的哲学-v2.0", "费曼学习法"]` in the candidate's `outgoing_links` field

### Requirement: Wikilink cluster discovery

`collect` SHALL build a directed graph from all `[[wikilink]]` references across candidates, identify hub nodes (notes referenced by 3 or more other notes), and output a `clusters` array in the JSON.

#### Scenario: Hub node with multiple inbound links

- **WHEN** "优雅的哲学-v2.0.md" is referenced by 9 other candidate files via `[[优雅的哲学-v2.0]]`
- **THEN** the `clusters` array SHALL include an entry with `hub` pointing to that file, `related` listing the 9 referencing files, and `link_count: 9`

#### Scenario: No hub nodes found

- **WHEN** no note is referenced by 3 or more other notes
- **THEN** the `clusters` array SHALL be empty

#### Scenario: Wikilinks inside code blocks

- **WHEN** a `[[wikilink]]` appears inside a fenced code block (``` or ~~~)
- **THEN** `collect` SHALL NOT count it as a link reference

### Requirement: Session activity signal extraction

`collect` SHALL read `sessions-index.json` from configured Claude Code project paths and `history.jsonl` from the global history path, extracting activity signals within the last 30 days into a `session_keywords` array.

#### Scenario: Session data available

- **WHEN** `sessions-index.json` exists with 50 sessions, 20 of which have `fileMtime` within the last 30 days
- **THEN** `collect` SHALL extract `summary` and `firstPrompt` from those 20 sessions

#### Scenario: Session data not found

- **WHEN** `sessions-index.json` or `history.jsonl` does not exist at the configured paths
- **THEN** `collect` SHALL output an empty `session_keywords` array and print a warning to stderr

#### Scenario: Multiple project paths

- **WHEN** the user has session data under multiple configured project paths
- **THEN** `collect` SHALL read from all paths and merge the signals into a single `session_keywords` array

### Requirement: Published blog post extraction

`collect` SHALL read all `.md` and `.mdx` files from `blog/`, `til/`, and `monthly/` collections in the bokushi repository, extracting title and tags from frontmatter into a `published_posts` array.

#### Scenario: Standard extraction

- **WHEN** the bokushi repository has 20 blog posts, 16 til posts, and 13 monthly posts
- **THEN** `collect` SHALL output 49 entries in `published_posts`, each with `title`, `tags`, and `collection` fields

### Requirement: Collect output format

`collect` SHALL output a single JSON object to stdout containing: `candidates` (array), `clusters` (array), `published_posts` (array), `session_keywords` (array), and `stats` (object with `total_scanned`, `filtered_out`, `candidates_count`).

#### Scenario: Complete output

- **WHEN** `collect` finishes scanning 988 files with 35 marked entries
- **THEN** stdout SHALL contain valid JSON with `stats.total_scanned: 988`, `stats.filtered_out: 35`, `stats.candidates_count: 953`

### Requirement: Level selection after collect

After `collect` completes, the skill SHALL display data volume (candidates count, clusters count) and offer Level 1-3 selection. The skill SHALL recommend a Level based on candidate count.

#### Scenario: Level selection display

- **WHEN** `collect` outputs 45 candidates and 3 clusters
- **THEN** the skill SHALL display candidate count, cluster count, and a Level 1-3 menu with recommended Level highlighted

#### Scenario: Auto-recommend Level 1

- **WHEN** `collect` outputs ≤ 10 candidates
- **THEN** the skill SHALL recommend Level 1 (浏览)

#### Scenario: Auto-recommend Level 2

- **WHEN** `collect` outputs > 10 candidates
- **THEN** the skill SHALL recommend Level 2 (推荐)

### Requirement: Level 1 browsing mode

At Level 1, the skill SHALL skip LLM evaluation entirely and display candidates sorted by character count descending. The user selects items directly, and all selections go to fast track.

#### Scenario: Level 1 display and selection

- **WHEN** the user selects Level 1 with 8 candidates
- **THEN** the skill SHALL display a numbered list with title and char_count, and the user picks items for fast track processing

#### Scenario: Level 1 does not offer deep track

- **WHEN** the user is in Level 1
- **THEN** the skill SHALL NOT offer deep track or cluster analysis

### Requirement: Level 3 deep exploration

At Level 3, the skill SHALL perform Level 2 evaluation AND additionally read hub note full text for each cluster, appending the content to the LLM evaluation prompt for more accurate cluster analysis.

#### Scenario: Level 3 hub content reading

- **WHEN** the user selects Level 3 and there are 3 clusters with hub notes
- **THEN** the skill SHALL Read the full text of each hub note and include it in the LLM evaluation prompt alongside the collect JSON data

#### Scenario: Level 3 without clusters

- **WHEN** the user selects Level 3 but `collect` found 0 clusters
- **THEN** the behavior SHALL be identical to Level 2 (no hub notes to read)

### Requirement: `<skill-dir>` path convention

All script invocations in SKILL.md SHALL use `<skill-dir>/scripts/...` placeholder instead of bare relative paths. The Agent SHALL resolve `<skill-dir>` to the actual skill installation directory before execution.

#### Scenario: Script invocation format

- **WHEN** SKILL.md instructs the Agent to run the collect script
- **THEN** the command SHALL use `python3 <skill-dir>/scripts/note-to-blog.py collect ...` format

### Requirement: LLM evaluation with mixed recommendations

The SKILL.md SHALL instruct the LLM to evaluate both individual candidates and topic clusters from the `collect` JSON output. The LLM SHALL return a JSON array of 5~8 recommendations, each typed as either `single` (individual note) or `cluster` (topic group).

#### Scenario: Mixed recommendation list

- **WHEN** the LLM evaluates 953 candidates with 3 clusters
- **THEN** the recommendation list SHALL contain a mix of `single` and `cluster` entries, each with score, target collection, effort, session activity, and duplicate risk

#### Scenario: Cluster recommendation

- **WHEN** a cluster with hub "优雅的哲学" and 9 related notes is among the candidates
- **THEN** the LLM MAY recommend it as `type: "cluster"` with a `theme_summary` and `related_count`

#### Scenario: Session activity boost

- **WHEN** a candidate matches 3+ recent session keywords
- **THEN** it SHALL receive a higher score compared to a similar-quality candidate with no session matches

### Requirement: Batch interactive selection

After presenting the recommendation list, the SKILL.md SHALL allow the user to: select multiple items for processing, assign each to fast or deep track, mark items as skipped with optional reason, and override target collection.

#### Scenario: User selects multiple items with mixed tracks

- **WHEN** the user says "1 和 3 快速转换，2 走深度"
- **THEN** items 1 and 3 SHALL be queued for fast track, item 2 for deep track

#### Scenario: Batch skip with reason

- **WHEN** the user says "4~6 跳过，reason: private"
- **THEN** the skill SHALL call `state skip` for each of those items with reason "private"

#### Scenario: User overrides target collection

- **WHEN** the LLM recommends `blog` for item 1 but the user says "1 放 til"
- **THEN** item 1 SHALL use `til` as the target collection

#### Scenario: User wants more candidates

- **WHEN** the user indicates the recommendations are not satisfactory
- **THEN** the skill SHALL request additional recommendations from the LLM, excluding previously shown items

### Requirement: Fast track conversion via script

For items assigned to fast track, the SKILL.md SHALL instruct an Agent to run `note-to-blog.py convert <path>` to perform Obsidian-to-standard-Markdown conversion, then review the output and generate a `description` field.

#### Scenario: Single article fast track

- **WHEN** "SSH 私钥加密.md" is assigned to fast track targeting `til`
- **THEN** an Agent SHALL run the convert script, review the converted content, generate a one-sentence description, write the draft to `repos/bokushi/src/content/til/<slug>.md` with `hidden: true`, and call `state draft` to update the state file

#### Scenario: Agent provides review feedback

- **WHEN** an Agent completes fast track conversion
- **THEN** it SHALL return a brief review including: conversion status, any issues found, and suggestions for improvement

### Requirement: Deep track research

For items assigned to deep track (typically clusters), the SKILL.md SHALL instruct an Agent to read all related notes, produce a structured research report including topic map, overlaps/contradictions, gaps, and a suggested outline.

#### Scenario: Cluster deep track

- **WHEN** the "优雅的哲学" cluster with 9 related notes is assigned to deep track
- **THEN** an Agent SHALL read all 9+1 notes and output a report containing: notes involved with word counts, topic map, overlaps and contradictions, gaps, and a suggested blog post outline

#### Scenario: Deep track result does not auto-convert

- **WHEN** a deep track Agent completes its research report
- **THEN** the skill SHALL present the report to the user and wait for direction (write based on outline, modify outline, or defer)

### Requirement: Agent Teams parallel dispatch

When the user has selected N items, the SKILL.md SHALL dispatch N parallel Agents using the Task tool, one per selected item. Each Agent operates independently. The main agent collects results and presents a summary.

#### Scenario: Three items selected

- **WHEN** the user selects 2 fast track items and 1 deep track item
- **THEN** the skill SHALL dispatch 3 parallel Agents, collect their results, and present a unified summary

#### Scenario: State updates after parallel agents complete

- **WHEN** all parallel Agents have completed
- **THEN** the main agent SHALL execute all `state` updates sequentially (not the individual Agents) to avoid write conflicts on `.note-to-blog.json`

### Requirement: Obsidian syntax conversion via script

The `note-to-blog.py convert <path>` command SHALL convert Obsidian-specific Markdown to standard Markdown and output the result to stdout. Standard Markdown SHALL be preserved unchanged.

#### Scenario: Image embed with size

- **WHEN** the source contains `![[CleanShot 2023-08-30@2x.png|400]]`
- **THEN** the output SHALL contain `![](CleanShot 2023-08-30@2x.png)`

#### Scenario: Wikilink with display text

- **WHEN** the source contains `[[费曼学习法|费曼学习法]]`
- **THEN** the output SHALL contain `费曼学习法` (plain text)

#### Scenario: Callout conversion

- **WHEN** the source contains `> [!warning] 注意安全`
- **THEN** the output SHALL contain `> **Warning:** 注意安全`

#### Scenario: Highlight and comment

- **WHEN** the source contains `==important==` and `%%hidden comment%%`
- **THEN** the output SHALL contain `**important**` and the comment SHALL be removed entirely

#### Scenario: Inline tag collection

- **WHEN** the source body contains `#CyberSecurity` and `#SSH` (not in code blocks or headings)
- **THEN** the tags SHALL be collected, removed from body text, and included in the converted output's frontmatter `tags` array

#### Scenario: Mixed Obsidian and standard Markdown

- **WHEN** the source contains both `![[image.png]]` and `![alt](https://example.com/image.png)`
- **THEN** the Obsidian embed SHALL be converted while the standard image SHALL be preserved unchanged

#### Scenario: Unrecognized Obsidian syntax

- **WHEN** the source contains Obsidian-specific syntax not covered by the conversion rules
- **THEN** `convert` SHALL preserve it as-is and add `<!-- TODO: manual conversion needed -->` on the next line

### Requirement: Frontmatter conversion

`convert` SHALL strip Obsidian-specific frontmatter fields (aliases, date, modified, date updated, score, cssclasses) and generate a bokushi-compatible frontmatter with `title`, `pubDate` (today), `tags` (merged from frontmatter + inline tags), and `hidden: true`.

#### Scenario: Standard frontmatter conversion

- **WHEN** the source has frontmatter `aliases: [], tags: [], date: 2024-04-01, modified: 2025-04-29`
- **THEN** the output frontmatter SHALL contain `title` (from filename), `pubDate` (today's date), `tags: []`, `hidden: true`, and the Obsidian fields SHALL be removed

#### Scenario: Description field

- **WHEN** `convert` produces output
- **THEN** the frontmatter SHALL NOT include a `description` field (this is generated by the LLM Agent, not the script)

### Requirement: State management

The `note-to-blog.py state` command SHALL manage `.note-to-blog.json` with subcommands: `status` (display pipeline overview), `draft` (mark as drafted with target path), `publish` (move from drafted to published), `skip` (mark as skipped with optional reason).

#### Scenario: Status display

- **WHEN** `state status` is run with 3 drafted, 5 published, and 20 skipped entries
- **THEN** it SHALL output a human-readable summary listing drafted items (with target paths) and counts for each category

#### Scenario: Draft a note

- **WHEN** `state draft "Areas/.../xxx.md" --target "blog/xxx.md"` is run
- **THEN** `.note-to-blog.json` SHALL add an entry under `drafted` with the target path and today's date

#### Scenario: Publish a drafted note

- **WHEN** `state publish "Areas/.../xxx.md"` is run and the note is currently in `drafted`
- **THEN** the entry SHALL move from `drafted` to `published`, preserving the target path

#### Scenario: Skip notes with reason

- **WHEN** `state skip "Areas/.../yyy.md" --reason "private"` is run
- **THEN** `.note-to-blog.json` SHALL add an entry under `skipped` with reason "private" and today's date

#### Scenario: Skip without reason

- **WHEN** `state skip "Areas/.../zzz.md"` is run without `--reason`
- **THEN** the entry SHALL be added with `reason: "no reason"`

### Requirement: Trigger word isolation

The note-to-blog skill SHALL use trigger words `选一篇笔记发博客`, `note to blog`, `写博客`, `博客选题` that do not overlap with writing-inspiration or writing-proofreading triggers.

#### Scenario: User says note-to-blog trigger

- **WHEN** the user says "选一篇笔记发博客" or "note to blog" or "博客选题"
- **THEN** the note-to-blog skill is activated

#### Scenario: User says writing-inspiration trigger

- **WHEN** the user says "帮我构思" or "不知道写什么"
- **THEN** writing-inspiration is activated (not note-to-blog)

### Requirement: PyYAML as sole external dependency

The `note-to-blog.py` script SHALL use only Python standard library modules plus PyYAML. No other external dependencies SHALL be required.

#### Scenario: Missing PyYAML

- **WHEN** `note-to-blog.py` is run and PyYAML is not installed
- **THEN** the script SHALL print a clear error message with install instructions (`pip install pyyaml`) and exit with non-zero status

#### Scenario: Standard library usage

- **WHEN** the script performs file scanning, regex conversion, JSON I/O, and date handling
- **THEN** it SHALL use `pathlib`, `re`, `json`, and `datetime` from the standard library
