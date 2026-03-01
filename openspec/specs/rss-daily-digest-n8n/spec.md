## ADDED Requirements

### Requirement: Daily RSS article scoring

The system SHALL fetch articles from all RSS feeds defined in the GitHub repository's feeds configuration file, and score each article against the current taste profile using Kimi K2 API.

#### Scenario: Normal daily scoring run

- **WHEN** the daily schedule trigger fires (default: 06:00)
- **THEN** the system fetches articles published in the last 24 hours from all active feeds, sends each article (title + content/description) to Kimi K2 with the taste profile as system prompt, and receives a relevance score (0-100) for each article

#### Scenario: Feed fetch failure

- **WHEN** one or more RSS feeds fail to respond (timeout, 403, 404)
- **THEN** the system continues processing remaining feeds and includes a note about failed sources in the output

#### Scenario: No articles available

- **WHEN** no feeds return articles within the 24-hour window
- **THEN** the system sends a brief "no articles today" notification to Telegram and skips GitHub output

### Requirement: Top 7 selection

The system SHALL select exactly 7 articles from the scored pool, prioritizing the highest-scoring articles while maintaining topic diversity.

#### Scenario: Sufficient articles (>7 scored)

- **WHEN** more than 7 articles receive scores
- **THEN** the system selects the top 7 by score, avoiding more than 2 articles from the same feed source

#### Scenario: Insufficient articles (<7 scored)

- **WHEN** fewer than 7 articles are available in the scoring pool
- **THEN** the system selects all available articles and notes the shortfall in the output

### Requirement: Summary and relevance generation

The system SHALL generate a 3-5 sentence summary and a personalized relevance analysis ("与你的关联") for each selected article using Kimi K2.

#### Scenario: Full article content available

- **WHEN** the RSS feed provides full article content
- **THEN** the system generates the summary from the full content

#### Scenario: Only title and description available

- **WHEN** the RSS feed only provides title and a short description
- **THEN** the system generates the summary from the available metadata and notes limited source data

### Requirement: Telegram delivery

The system SHALL format the 7 selected articles into a structured digest message and deliver it to the configured Telegram group and topic.

#### Scenario: Successful delivery

- **WHEN** all 7 articles are summarized
- **THEN** the system sends a formatted digest to the Telegram group (default: `-1002025331985`) with the configured thread ID, using the output format from the existing `rss-daily-digest` skill as baseline

#### Scenario: Telegram API failure

- **WHEN** Telegram delivery fails
- **THEN** the system retries once, and if still failing, logs the error and still writes the output to GitHub

### Requirement: GitHub output archival

The system SHALL write each daily digest to the GitHub repository as a markdown file for historical reference.

#### Scenario: Successful daily run

- **WHEN** the digest is generated
- **THEN** the system commits a file at `output/daily/YYYY-MM-DD.md` in the GitHub repository containing the full digest with scores, summaries, and relevance analyses

### Requirement: Deduplication

The system SHALL not recommend the same article across consecutive daily digests.

#### Scenario: Article appeared in yesterday's digest

- **WHEN** an article URL was included in the previous day's output
- **THEN** the system excludes that article from scoring in today's run

### Requirement: Feeds configuration from GitHub

The system SHALL read the list of RSS feed URLs from a configuration file in the GitHub repository.

#### Scenario: Reading feeds list

- **WHEN** the daily workflow starts
- **THEN** the system reads the feeds configuration file from the GitHub repository using the GitHub node (Resource: File, Operation: Get)

#### Scenario: Feed added or removed

- **WHEN** a user adds or removes a feed URL in the GitHub configuration file
- **THEN** the next daily run reflects the updated feed list without any workflow modification
