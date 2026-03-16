---
name: finding-code-patterns
description: "Finds similar implementations and concrete examples in the codebase. Use when you need to answer 'where do we already do X?', 'show me a similar pattern', or 'find an example to model after'."
allowed-tools:
  - Read
  - Grep
  - Glob
  - LS
---

# Finding Code Patterns

Find concrete examples of how similar problems are already solved in the codebase.

## Workflow

1. Identify the pattern type the user is looking for.
2. Search for multiple likely examples instead of stopping at the first match.
3. Read the strongest candidates closely enough to extract the pattern.
4. Return concrete examples with file references and concise notes on how each one is used.
5. Include tests when they show the pattern more clearly.

## Output Format

Return results in this shape:

1. `Summary` - what patterns were found
2. `Pattern Examples` - grouped by pattern or variation
3. `Testing Examples`
4. `Code References`
5. `Open Questions`

## Guardrails

- Show what exists; do not recommend which pattern is better unless explicitly asked.
- Keep snippets short and focused on the pattern.
- Prefer examples that are clearly in active use.
