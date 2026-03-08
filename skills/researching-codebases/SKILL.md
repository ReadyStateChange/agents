---
name: researching-codebases
description: "Researches how a codebase currently works and produces structured findings with references. Use when asked to map architecture, trace flows, or gather technical context before planning."
allowed-tools:
  - finder
  - Read
  - Grep
  - glob
  - shell_command
argument-hint: "Provide the research question and optional output path if you want a persisted research document."
---

# Researching Codebases

Document how the system works today using evidence from code and docs.

## Primary Rule

Default to documentation mode: describe what exists, where it exists, and how pieces connect. Do not recommend changes unless explicitly asked.

## Workflow

1. Read user-provided files first (tickets/docs/specs).
2. Decompose the question into focused research areas.
3. Use `finder` and targeted search to locate implementations and call paths.
4. Read the key files fully and capture evidence with file references.
5. Synthesize a structured answer tied directly to the user question.
6. If requested, persist to `docs/research/YYYY-MM-DD-<topic>.md` with metadata.

## Output Format

Return results in this shape:

1. `Summary` - direct answer to the research question
2. `Findings` - grouped by subsystem or flow
3. `Code References` - paths and line ranges
4. `Open Questions` - unknowns requiring additional discovery

## Quality Bar

- Prefer concrete evidence over inference.
- Distinguish observed facts from assumptions.
- Include integration points and data flow boundaries.
- Call out uncertainty explicitly when evidence is incomplete.
