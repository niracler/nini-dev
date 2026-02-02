## ADDED Requirements

### Requirement: Repo scanning

`scan.sh` SHALL scan `~/code/*/` and `~/code/*/repos/*/` for git repositories and output a JSON array of repo status objects.

Each object SHALL contain: `path`, `name`, `branch`, `remote`, `remote_url`, `dirty_count`, `has_upstream`, `ahead`, `behind`.

Non-git directories SHALL be silently skipped.

#### Scenario: Standard scan without fetch

- **WHEN** `scan.sh` is run without `--fetch`
- **THEN** it outputs a JSON array with status of all discovered git repos, using local-only data (ahead/behind relative to last fetch)

#### Scenario: Scan with fetch

- **WHEN** `scan.sh` is run with `--fetch`
- **THEN** it runs `git fetch` for each repo before collecting status, with a per-repo timeout of 10 seconds

#### Scenario: Fetch failure for one repo

- **WHEN** `git fetch` fails or times out for a repo during `--fetch`
- **THEN** that repo's entry SHALL include `"fetch_error": true` and scanning SHALL continue with remaining repos

#### Scenario: Non-git directory encountered

- **WHEN** a scanned path is not a git repository
- **THEN** it SHALL be excluded from the output (not listed at all)

### Requirement: Push mode workflow

The SKILL.md SHALL define a push workflow where Claude Code acts as the main loop:

1. Run `scan.sh` to get repo statuses
2. Categorize repos into: up-to-date, needs-push, dirty, skipped
3. Batch push all clean repos with unpushed commits
4. For each dirty repo, examine changes and ask the user how to handle them

#### Scenario: Clean repo with unpushed commits

- **WHEN** a repo has `dirty_count == 0` and `ahead > 0`
- **THEN** Claude Code SHALL push it automatically without asking

#### Scenario: Dirty repo during push

- **WHEN** a repo has `dirty_count > 0`
- **THEN** Claude Code SHALL `cd` into the repo, run `git diff --stat` and `git status`, describe the changes to the user, and ask whether to commit, stash, or skip

#### Scenario: Repo without upstream

- **WHEN** a repo has `has_upstream == false`
- **THEN** Claude Code SHALL report it and ask the user whether to set upstream and push, or skip

#### Scenario: All repos clean and up-to-date

- **WHEN** all repos have `dirty_count == 0` and `ahead == 0`
- **THEN** Claude Code SHALL report "All repos are up to date" without further action

### Requirement: Pull mode workflow

The SKILL.md SHALL define a pull workflow where Claude Code acts as the main loop:

1. Run `scan.sh --fetch` to get repo statuses with remote info
2. Categorize repos into: up-to-date, needs-pull, has-issues
3. Batch pull (ff-only) all clean repos that are behind
4. For each failed pull, examine the situation and ask the user how to handle it

#### Scenario: Clean repo behind remote

- **WHEN** a repo has `dirty_count == 0` and `behind > 0`
- **THEN** Claude Code SHALL run `git pull --ff-only` automatically

#### Scenario: Fast-forward pull fails

- **WHEN** `git pull --ff-only` fails for a repo
- **THEN** Claude Code SHALL examine the divergence, explain the situation to the user, and suggest rebase or merge

#### Scenario: Dirty repo with remote updates

- **WHEN** a repo has `dirty_count > 0` and `behind > 0`
- **THEN** Claude Code SHALL report both issues and ask the user how to proceed (stash+pull, skip, etc.)

### Requirement: Summary report

After completing push or pull operations, Claude Code SHALL output a summary grouping repos by outcome.

#### Scenario: Push summary

- **WHEN** push mode completes
- **THEN** Claude Code outputs a summary with categories: pushed, already up-to-date, resolved (with action taken), skipped

#### Scenario: Pull summary

- **WHEN** pull mode completes
- **THEN** Claude Code outputs a summary with categories: updated, already up-to-date, resolved (with action taken), skipped

### Requirement: Trigger word isolation

The code-sync skill SHALL use trigger words `同步代码`, `code-sync`, `下班同步`, `上班更新` that do not overlap with git-workflow's trigger words.

#### Scenario: User says sync trigger

- **WHEN** user says "同步代码" or "code-sync" or "下班同步" or "上班更新"
- **THEN** the code-sync skill is activated (not git-workflow)

#### Scenario: User says git-workflow trigger

- **WHEN** user says "推代码" or "commit" or "帮我提交"
- **THEN** git-workflow is activated (not code-sync)
