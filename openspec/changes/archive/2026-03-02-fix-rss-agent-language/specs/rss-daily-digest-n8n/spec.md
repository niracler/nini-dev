## MODIFIED Requirements

### Requirement: Daily RSS article scoring

The system SHALL fetch articles from all RSS feeds defined in the GitHub repository's feeds configuration file, and score each article against the current taste profile using AI API. The scoring prompt SHALL include an explicit Chinese language constraint for the `reason` field output.

#### Scenario: Normal daily scoring run

- **WHEN** the daily schedule trigger fires (default: 06:00)
- **THEN** the system fetches articles published in the last 24 hours from all active feeds, sends each article (title + content/description) to the AI model with the taste profile as system prompt, and receives a relevance score (0-100) for each article

#### Scenario: Scoring output language

- **WHEN** the AI model returns a scoring result for an article (regardless of the article's original language)
- **THEN** the `reason` field in the JSON response MUST be in Chinese

#### Scenario: Feed fetch failure

- **WHEN** one or more RSS feeds fail to respond (timeout, 403, 404)
- **THEN** the system continues processing remaining feeds and includes a note about failed sources in the output

#### Scenario: No articles available

- **WHEN** no feeds return articles within the 24-hour window
- **THEN** the system sends a brief notification and skips GitHub output

### Requirement: Summary and relevance generation

The system SHALL generate a 3-5 sentence summary and a personalized relevance analysis ("与你的关联") for each selected article using AI API. All summary and relevance output MUST be in Chinese, regardless of the article's original language.

#### Scenario: Full article content available

- **WHEN** the RSS feed provides full article content
- **THEN** the system generates a Chinese-language summary from the full content

#### Scenario: Only title and description available

- **WHEN** the RSS feed only provides title and a short description
- **THEN** the system generates a Chinese-language summary from the available metadata and notes limited source data

#### Scenario: English source article

- **WHEN** the source article is written in English
- **THEN** the system MUST still generate the summary and relevance analysis in Chinese

## ADDED Requirements

### Requirement: Chinese language output enforcement

All user-facing AI-generated text in the daily digest workflow SHALL be in Chinese. This includes scoring reasons, article summaries, and relevance analyses. The `category` field remains in English by design.

#### Scenario: System prompt language constraint

- **WHEN** the system constructs an AI prompt for scoring or summary generation
- **THEN** the system prompt MUST include an explicit Chinese language constraint (placed near the beginning of the prompt, not at the end)

#### Scenario: Profile documents language

- **WHEN** the system reads `profile/context.md` for injection into AI prompts
- **THEN** the content of `context.md` MUST be in Chinese to avoid language contamination of the AI output
