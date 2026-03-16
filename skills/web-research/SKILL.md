---
name: web-research
description: "Researches current external information and official documentation on the web with citations. Use when a question depends on third-party docs, APIs, standards, libraries, or other up-to-date sources outside the codebase."
allowed-tools:
  - WebSearch
  - WebFetch
  - Read
  - Grep
  - Glob
  - LS
---

# Web Research

Research external sources and answer with links, dates, and clear source attribution.

## Workflow

1. Clarify the exact question, including version or timeframe when relevant.
2. Search primary sources first: official docs, standards bodies, maintainers, and vendor announcements.
3. Fetch the most relevant sources and compare them before answering.
4. Distinguish source-backed facts from inference.
5. Return a concise answer with links and note any uncertainty or conflicting information.

## Output Format

Return results in this shape:

1. `Summary` - direct answer to the question
2. `Findings` - grouped by source or subtopic
3. `Sources` - direct links used in the answer
4. `Open Questions` - unresolved gaps or conflicts

## Guardrails

- Prefer official and current sources over secondary commentary.
- Note dates, versions, and publication context when they matter.
- Do not present stale or unverified web information as certain.
- Keep quoted text short and only where it adds precision.
