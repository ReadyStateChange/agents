---
name: locating-code
description: "Finds files, directories, and entry points relevant to a feature or question. Use when you need to answer 'where does X live?', 'what files touch Y?', or 'show me the relevant implementation, tests, and config'."
allowed-tools:
  - Grep
  - Glob
  - LS
---

# Locating Code

Map where code lives without deeply analyzing its implementation.

## Workflow

1. Turn the question into search terms, synonyms, and likely directory names.
2. Search for implementation files, tests, configuration, and docs that match.
3. Group findings by purpose instead of dumping raw matches.
4. Call out likely entry points and related directories when visible.

## Output Format

Return results in this shape:

1. `Summary` - direct answer to where the relevant code seems to live
2. `Implementation Files` - grouped list with one-line purpose notes
3. `Tests`
4. `Configuration And Docs`
5. `Related Directories`
6. `Open Questions`

## Guardrails

- Prefer breadth over deep file reading.
- Do not explain logic beyond what is needed to identify file purpose.
- Do not recommend changes or critique organization unless explicitly asked.
