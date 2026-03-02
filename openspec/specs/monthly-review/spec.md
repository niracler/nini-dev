## ADDED Requirements

### Requirement: Monthly reflective analysis

The system SHALL generate a monthly review article analyzing the past 30 days of daily digests, focusing on long-term impact rather than individual article summaries.

#### Scenario: Monthly trigger

- **WHEN** the 1st of each month arrives (cron trigger)
- **THEN** the system reads all `output/daily/*.md` files from the past 30 days, sends the aggregated data to Kimi K2, and generates a reflective analysis

### Requirement: Analysis dimensions

The monthly review SHALL address three core dimensions inspired by the user's reading philosophy (niracler.com/feed-reading-posture).

#### Scenario: Knowledge system changes

- **WHEN** the monthly analysis is generated
- **THEN** it includes a section analyzing which articles challenged or expanded existing understanding, identifying knowledge areas that shifted during the month

#### Scenario: Decision impact

- **WHEN** the monthly analysis is generated
- **THEN** it includes a section identifying articles that could influence or have influenced concrete actions (technology choices, tool adoption, workflow changes, purchases)

#### Scenario: Trend discovery

- **WHEN** the monthly analysis is generated
- **THEN** it includes a section identifying recurring themes or emerging patterns across seemingly unrelated articles, connecting dots that individual daily digests cannot reveal

### Requirement: Reflective writing style

The monthly review SHALL be written in the user's reflective blog style, not as a data report.

#### Scenario: Output tone and format

- **WHEN** the review is generated
- **THEN** it uses first-person reflective prose in Chinese, with strategic bold for key phrases, conversational asides, and honest self-assessment — matching the style of niracler.com blog posts

#### Scenario: Actionable closing

- **WHEN** the review is generated
- **THEN** it closes with 2-3 concrete reading direction adjustments for the next month (e.g., "increase depth on X topic", "reduce noise from Y category")

### Requirement: Monthly output storage

The system SHALL store the monthly review in the GitHub repository and deliver a summary to Telegram.

#### Scenario: GitHub archival

- **WHEN** the monthly review is generated
- **THEN** the system commits it to `profile/history/YYYY-MM.md` in the GitHub repository

#### Scenario: Telegram delivery

- **WHEN** the monthly review is generated
- **THEN** the system sends a condensed version (key insights + reading adjustment suggestions) to the configured Telegram group

### Requirement: Taste profile feedback loop

The monthly review SHALL inform the next taste profile update.

#### Scenario: Reading direction adjustments

- **WHEN** the monthly review suggests reading direction changes (e.g., "focus more on distributed systems")
- **THEN** these suggestions are appended to `profile/context.md` as context for the next taste profile generation, allowing the AI to incorporate explicit direction alongside behavioral signals
