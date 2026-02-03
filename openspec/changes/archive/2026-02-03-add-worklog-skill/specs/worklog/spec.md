## ADDED Requirements

### Requirement: Local git statistics collection

`stats.sh` SHALL scan `~/code/*/` and `~/code/*/repos/*/` for git repositories and output a JSON object containing per-repo commit statistics for a given time range.

The script SHALL accept:

- `--since YYYY-MM-DD` (required): start date of the period
- `--until YYYY-MM-DD` (required): end date of the period
- `--author <name|email>` (optional): filter by author; defaults to `git config user.name`

Each repo entry SHALL contain: `name`, `path`, `remote_url`, `commits`, `insertions`, `deletions`, `files_changed`, `authors`, `first_commit`, `last_commit`.

The output SHALL include a `totals` object with: `repos_active`, `repos_scanned`, `commits`, `insertions`, `deletions`.

The output SHALL include a `period` object with: `from`, `to`.

Non-git directories SHALL be silently skipped. Repos with zero commits in the period SHALL be excluded from the `repos` array but counted in `repos_scanned`.

#### Scenario: Daily statistics

- **WHEN** `stats.sh --since 2026-02-02 --until 2026-02-02` is run
- **THEN** it outputs a JSON object with statistics for all repos that had commits on 2026-02-02, plus totals

#### Scenario: Weekly statistics

- **WHEN** `stats.sh --since 2026-01-27 --until 2026-02-02` is run
- **THEN** it outputs a JSON object with statistics aggregated across the week for each repo

#### Scenario: Author filter

- **WHEN** `stats.sh --since 2026-02-01 --until 2026-02-02 --author niracler` is run
- **THEN** only commits by the specified author are counted in the statistics

#### Scenario: No author specified

- **WHEN** `stats.sh` is run without `--author`
- **THEN** it defaults to the value of `git config user.name` for filtering

#### Scenario: Non-git directory encountered

- **WHEN** a scanned path is not a git repository
- **THEN** it SHALL be excluded from the output

#### Scenario: Repo with no commits in period

- **WHEN** a git repo has zero commits in the specified time range
- **THEN** it SHALL NOT appear in the `repos` array but SHALL be counted in `totals.repos_scanned`

### Requirement: Mode selection

The worklog skill SHALL support two modes: daily and weekly. Mode selection SHALL be based on user input.

#### Scenario: User requests daily review

- **WHEN** user says "日报" or "今天做了什么" or "daily worklog"
- **THEN** the skill SHALL run in daily mode for the current date

#### Scenario: User requests weekly review

- **WHEN** user says "周报" or "本周总结" or "weekly worklog"
- **THEN** the skill SHALL run in weekly mode for the current week (Monday to today)

#### Scenario: Ambiguous request

- **WHEN** user says "工作回顾" or "worklog" without specifying daily or weekly
- **THEN** the skill SHALL ask the user which mode to use

### Requirement: GitHub activity collection

`github.sh` SHALL collect GitHub PR and Issue activity for a given time range using the `gh` CLI and output a JSON object.

The script SHALL accept:

- `--since YYYY-MM-DD` (required): start date of the period
- `--until YYYY-MM-DD` (required): end date of the period
- `--username <github-username>` (optional): GitHub username; defaults to `gh api user` lookup

The output SHALL include a `prs` array with: `repo`, `number`, `title`, `state` (merged/open/closed), `created_at`, `merged_at`.

The output SHALL include an `issues` array with: `repo`, `number`, `title`, `state`, `created_at`.

The output SHALL include a `totals` object with: `prs_merged`, `prs_open`, `issues_opened`, `issues_closed`.

PR query scope SHALL include: PRs created in the period + PRs merged in the period (regardless of creation date) + currently open PRs by the user.

#### Scenario: Weekly GitHub activity

- **WHEN** `github.sh --since 2026-01-26 --until 2026-02-01` is run
- **THEN** it outputs a JSON object with PRs and Issues matching the query scope

#### Scenario: No GitHub activity

- **WHEN** the user has no PR or Issue activity in the period
- **THEN** the output SHALL have empty `prs` and `issues` arrays with zero totals

#### Scenario: gh CLI not authenticated

- **WHEN** `gh` CLI is not authenticated
- **THEN** the script SHALL exit with an error message suggesting `gh auth login`

### Requirement: Data source integration

The worklog skill SHALL integrate three data sources: local git statistics (stats.sh), GitHub activity (github.sh), and Yunxiao MCP. Scripts (stats.sh, github.sh) SHALL be run via Bash. Yunxiao data SHALL be fetched via MCP tools at runtime. Sources SHALL be fetched in parallel where possible.

#### Scenario: All sources available

- **WHEN** stats.sh and github.sh succeed and Yunxiao MCP returns data
- **THEN** the output SHALL include local git statistics, GitHub PR/Issue activity, and Yunxiao MR/Bug/Task records

#### Scenario: GitHub script fails

- **WHEN** github.sh fails or `gh` CLI is not available
- **THEN** the output SHALL include local git statistics and Yunxiao data, with a note that GitHub data was not available

#### Scenario: Yunxiao MCP unavailable

- **WHEN** Yunxiao MCP tools are not connected or return an error
- **THEN** the output SHALL include local git statistics and GitHub data, with a note that Yunxiao data was not available

#### Scenario: Only local git available

- **WHEN** both github.sh and Yunxiao MCP fail
- **THEN** the output SHALL include local git statistics only, with notes about unavailable sources

### Requirement: Output template format

The output SHALL use a narrative + table hybrid format, grouped by work theme (not by data source).

The output SHALL begin with a blockquote overview line containing: total commits, code changes, repo count, and MR/PR summary counts.

Each work theme section SHALL contain: a narrative paragraph explaining the work context, followed by structured tables for MR/Bug/PR details where applicable.

MR and PR entries SHALL be grouped by logical theme (related MRs on the same row), not listed individually. Bug entries SHALL be listed individually (each row = one bug).

Low-activity repos SHALL be aggregated into an "其他" line.

#### Scenario: Daily output with all data sources

- **WHEN** daily mode completes with data from all three sources
- **THEN** the output SHALL contain a blockquote overview, theme sections with narrative + tables (MR grouped by theme, Bug listed individually), and GitHub repo activity

#### Scenario: Daily output with no activity

- **WHEN** daily mode runs but no commits, MRs, or PRs exist for the day
- **THEN** the output SHALL report "No activity recorded for today"

### Requirement: Weekly output additions

In weekly mode, the output SHALL include everything from the daily format plus: a per-day commit distribution (ASCII bar chart) and a highlights section.

The commit distribution SHALL show commit counts for each day of the week (Monday through Friday, plus weekends if they have commits).

The highlights section SHALL include: most active repo, largest change by lines, and notable achievements (sprint completion, PR activity summary).

#### Scenario: Weekly output with statistics

- **WHEN** weekly mode completes with commit data
- **THEN** the output SHALL contain all daily sections plus an ASCII commit distribution chart and a highlights section

#### Scenario: Weekly commit distribution format

- **WHEN** weekly mode renders the commit distribution
- **THEN** each day SHALL be displayed as a labeled bar (e.g., `Mon  ████░░  4 commits`)

### Requirement: diary-assistant integration

The diary-assistant skill SHALL delegate its Work Log step to the worklog skill (daily mode). diary-assistant SHALL NOT maintain its own data fetching logic for work logs.

#### Scenario: diary-assistant triggers worklog

- **WHEN** diary-assistant reaches the Work Log step on a weekday
- **THEN** it SHALL invoke the worklog skill in daily mode and embed the output directly into the diary

#### Scenario: diary-assistant on weekend

- **WHEN** diary-assistant runs on a weekend
- **THEN** it SHALL skip the worklog step entirely (no invocation of worklog skill)

### Requirement: Trigger word isolation

The worklog skill SHALL use trigger words `工作回顾`, `日报`, `周报`, `worklog` that do not overlap with diary-assistant or code-sync trigger words.

#### Scenario: User says worklog trigger

- **WHEN** user says "工作回顾" or "日报" or "周报" or "worklog"
- **THEN** the worklog skill is activated (not diary-assistant, not code-sync)

#### Scenario: User says diary trigger

- **WHEN** user says "写日记" or "记录今天" or "今天的日记"
- **THEN** diary-assistant is activated (not worklog directly, though diary may invoke worklog internally)

#### Scenario: User says code-sync trigger

- **WHEN** user says "同步代码" or "code-sync" or "下班同步"
- **THEN** code-sync is activated (not worklog)

### Requirement: User configuration

The worklog skill SHALL maintain a `references/user-config.md` containing identity and data source configuration.

Required configuration: Yunxiao username, Yunxiao organization ID, GitHub username.

These configuration values SHALL be migrated from diary-assistant's `references/user-config.md`.

#### Scenario: Configuration present

- **WHEN** worklog skill reads user-config.md with all fields populated
- **THEN** it SHALL use the configured identities for filtering data from all sources

#### Scenario: Configuration missing

- **WHEN** user-config.md is absent or has empty fields
- **THEN** the skill SHALL fall back to `git config user.name` for local stats and warn about missing remote source configuration
