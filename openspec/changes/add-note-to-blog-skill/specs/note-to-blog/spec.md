## ADDED Requirements

### Requirement: Note scanning and filtering

The skill SHALL scan the Note repository for all `*.md` files across `Areas/`, `Inbox/`, and `Archives/` directories. Files marked as `published` or `skipped` in `.note-to-blog.json` SHALL be excluded from the candidate list.

#### Scenario: First run with no prior marks

- **WHEN** the skill runs for the first time and `.note-to-blog.json` does not exist
- **THEN** it SHALL create an empty `.note-to-blog.json` at the Note repository root and include all `*.md` files as candidates

#### Scenario: Subsequent run with existing marks

- **WHEN** the skill runs and `.note-to-blog.json` contains 10 published and 5 skipped entries
- **THEN** those 15 files SHALL be excluded from the candidate list

#### Scenario: Note file no longer exists

- **WHEN** a file listed in `.note-to-blog.json` no longer exists on disk
- **THEN** the skill SHALL silently ignore the missing entry (no error, no cleanup)

### Requirement: Candidate summary extraction

For each candidate file, the skill SHALL extract the title (from filename or frontmatter `title` field) and the first 20 non-empty, non-frontmatter lines as a summary. The file's word count SHALL also be calculated.

#### Scenario: File with Obsidian frontmatter

- **WHEN** a candidate has YAML frontmatter with `aliases` or `tags` fields
- **THEN** the skill SHALL extract metadata from frontmatter and start summary from the first line after the closing `---`

#### Scenario: File without frontmatter

- **WHEN** a candidate has no YAML frontmatter
- **THEN** the skill SHALL use the filename (without `.md`) as the title and extract the first 20 non-empty lines as summary

### Requirement: Session activity signal extraction

The skill SHALL read `sessions-index.json` and `history.jsonl` from the Claude Code project data directory, extracting `summary` and `firstPrompt` fields from sessions and `display` fields from history entries within the last 30 days. These SHALL be compiled into a keyword list for the LLM evaluation.

#### Scenario: Session data available

- **WHEN** `sessions-index.json` exists with 50 sessions, 20 of which are within the last 30 days
- **THEN** the skill SHALL extract summary + firstPrompt from those 20 sessions as activity signals

#### Scenario: Session data not found

- **WHEN** `sessions-index.json` or `history.jsonl` does not exist at the configured path
- **THEN** the skill SHALL proceed without session signals (no error) and note "session 数据未找到，跳过活跃度分析" in the output

#### Scenario: Multiple project paths

- **WHEN** the user has session data under multiple project paths (e.g., nini-dev and bokushi)
- **THEN** the skill SHALL read from all configured project paths and merge the signals

### Requirement: Blog deduplication check

The skill SHALL read all existing files from `blog/`, `til/`, and `monthly/` collections in the bokushi repository, extracting titles and tags for semantic deduplication by the LLM.

#### Scenario: Existing blog post with same topic

- **WHEN** a Note titled "原生家庭那些事" exists and a blog post "original-family-matters.md" with similar content is already published
- **THEN** the LLM evaluation SHALL flag this as a duplicate and exclude it from recommendations (or mark with high duplicate risk)

#### Scenario: Note is an updated version of published post

- **WHEN** a Note titled "我为什么会喜欢一首歌 2.0" exists and "why-i-love-one-music.md" is already published
- **THEN** the LLM evaluation SHALL flag this as a potential update and recommend it with a note about the existing version

### Requirement: LLM evaluation and ranking

The skill SHALL make a single LLM call with the candidate summaries, published blog list, and session signals. The LLM SHALL return a JSON array of Top 5~8 recommendations, each containing: file path, score (0-100), target collection (blog/til/monthly), effort level (小/中/大), session activity indicator, duplicate risk, and a one-line recommendation reason.

#### Scenario: Standard evaluation

- **WHEN** the skill has 80 candidates, 20 published blog posts, and 15 session signals
- **THEN** the LLM SHALL return 5~8 ranked recommendations in valid JSON format

#### Scenario: Target collection assignment

- **WHEN** a candidate is a technical tutorial about SSH key encryption
- **THEN** the LLM SHALL recommend `til` as the target collection

#### Scenario: Session activity boost

- **WHEN** a candidate titled "后 LLM 时代代码 Review" matches 3 recent sessions about LLM and code review
- **THEN** the candidate SHALL receive a higher score compared to a similar-quality candidate with no session matches

### Requirement: Interactive selection and marking

After presenting the recommendation list, the skill SHALL allow the user to: (a) select one article to convert, (b) mark articles as `skipped` with an optional reason, or (c) both. Batch marking SHALL be supported.

#### Scenario: User selects one article

- **WHEN** the user selects recommendation #1 for conversion
- **THEN** the skill SHALL read the full text of that article and show a confirmation prompt with estimated word count, recommended effort level, and target collection

#### Scenario: User marks articles as skip

- **WHEN** the user marks recommendations #3, #5, #7 as skip with reason "private"
- **THEN** the skill SHALL update `.note-to-blog.json` with those entries under the `skipped` key, each with the reason and current date

#### Scenario: User overrides target collection

- **WHEN** the LLM recommends `blog` but the user says "放 til 吧"
- **THEN** the skill SHALL use `til` as the target collection for the conversion

#### Scenario: User wants to see more candidates

- **WHEN** the user says "还有别的吗" or indicates the recommendations are not satisfactory
- **THEN** the skill SHALL request a second batch of recommendations from the LLM, excluding the previously shown ones

### Requirement: Obsidian syntax conversion

The skill SHALL convert Obsidian-specific Markdown syntax to standard Markdown compatible with Astro.

| Obsidian syntax | Conversion |
|-----------------|------------|
| `![[image.png]]` | `![](original-url)` |
| `![[image.png\|400]]` | `![](original-url)` (size removed) |
| `[[wikilink]]` | plain text (brackets removed) |
| `[[wikilink\|display]]` | display text only |
| `:span[text]{.spoiler}` | `<span class="spoiler">text</span>` |
| `> [!type] title` callout | `> **Type:** title` blockquote |
| inline `#tag` | removed from body, collected to frontmatter tags |

#### Scenario: Image with Obsidian embed syntax

- **WHEN** the source contains `![[CleanShot 2023-08-30 at 21.54.28@2x.png|400]]`
- **THEN** the output SHALL contain `![](original-url-if-available)` or a placeholder `![](TODO: add image URL)` if the URL cannot be resolved

#### Scenario: Wikilink with display text

- **WHEN** the source contains `[[费曼学习法|费曼学习法]]`
- **THEN** the output SHALL contain `费曼学习法` (plain text)

#### Scenario: Mixed Obsidian and standard Markdown

- **WHEN** the source contains both `![[image.png]]` and `![alt](https://example.com/image.png)`
- **THEN** the Obsidian syntax SHALL be converted while standard Markdown images SHALL be preserved unchanged

### Requirement: Frontmatter generation

The skill SHALL generate bokushi-compatible frontmatter with: `title` (from Note title or filename), `pubDate` (current date), `tags` (from Note frontmatter + inline tags), `description` (LLM-generated one-sentence summary), `hidden: true` (always, for draft mode).

#### Scenario: Note with existing frontmatter

- **WHEN** the source Note has frontmatter `tags: [CyberSecurity, SSH]` and `date: 2023-07-31`
- **THEN** the output frontmatter SHALL include `tags: ["CyberSecurity", "SSH"]`, `pubDate` set to today's date (not the original date), and `hidden: true`

#### Scenario: Note without frontmatter

- **WHEN** the source Note has no frontmatter
- **THEN** the skill SHALL generate frontmatter using the filename as title, today as pubDate, tags inferred from inline `#tag` markers, and a LLM-generated description

### Requirement: Draft output and state update

The skill SHALL write the converted article to `repos/bokushi/src/content/{collection}/` with `hidden: true` and update `.note-to-blog.json` to mark the source Note as `published`.

#### Scenario: Successful draft creation

- **WHEN** the conversion completes for "SSH私钥加密.md" targeting `til`
- **THEN** the skill SHALL write to `repos/bokushi/src/content/til/<slug>.md` with `hidden: true` and add an entry to `.note-to-blog.json` under `published` with `target: "til/<slug>.md"` and today's date

#### Scenario: File naming

- **WHEN** the source Note title is "用三分钟对你个人电脑上的 SSH 私钥进行加密吧"
- **THEN** the output filename SHALL be a reasonable kebab-case slug (e.g., `ssh-key-encryption.md`)

### Requirement: Writing proofreading integration

After draft creation, the skill SHALL inform the user that the draft is ready for proofreading and suggest running `/writing-proofreading` as a separate session.

#### Scenario: Draft created successfully

- **WHEN** a draft has been written to bokushi
- **THEN** the skill SHALL output a message like "草稿已生成：`repos/bokushi/src/content/til/ssh-key-encryption.md`（hidden: true）。建议下次运行 `/writing-proofreading` 进行审校，完成后改 `hidden: false` 发布。"

### Requirement: Trigger word isolation

The note-to-blog skill SHALL use trigger words `选一篇笔记发博客`, `note to blog`, `写博客`, `博客选题` that do not overlap with writing-inspiration or writing-proofreading triggers.

#### Scenario: User says note-to-blog trigger

- **WHEN** the user says "选一篇笔记发博客" or "note to blog" or "博客选题"
- **THEN** the note-to-blog skill is activated

#### Scenario: User says writing trigger

- **WHEN** the user says "帮我构思" or "不知道写什么"
- **THEN** writing-inspiration is activated (not note-to-blog)
