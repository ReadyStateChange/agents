---
name: creating-handoffs
description: "Creates concise handoff documents with status, decisions, artifacts, and next actions. Use when ending a session or transferring active work to another agent/thread."
allowed-tools:
  - Read
  - Grep
  - glob
  - shell_command
argument-hint: "Provide the handoff topic and any required destination path if different from docs/handoffs/."
---

# Creating Handoffs

Capture enough context for another agent to continue work without re-discovery.

## Workflow

1. Determine docs location from project guidance; default to `docs/handoffs/`.
2. Build filename as `YYYY-MM-DD_HH-MM-SS_<topic>.md` (kebab-case topic).
3. Collect metadata:
   - current datetime (ISO)
   - `jj` commit (`jj log -r @ --no-graph -T 'commit_id.short()'`)
   - current bookmark (`jj log -r @ --no-graph -T 'bookmarks'`)
   - repository name (`package.json` name or root directory name)
4. Write the handoff with concrete file references and statuses.
5. Return the saved path.

## Required Sections

Include these sections in every handoff:

1. `Task Status` (done / in progress / blocked)
2. `Critical Context` (constraints, decisions, gotchas)
3. `Artifacts` (files edited, docs produced, commands run)
4. `Next Actions` (ordered, actionable items)

## Template

```markdown
---
date: 2026-03-08T10:11:12-07:00
author: amp
jj_commit: abc123ef
bookmark: feature/my-work
repository: my-repo
topic: "tighten-auth-flow"
type: handoff
status: complete
last_updated: 2026-03-08
---

# Handoff: Tighten Auth Flow

## Task Status
- Completed:
- In Progress:
- Blocked:

## Critical Context
-

## Artifacts
- `path/to/file.ts:10-40` - what changed

## Next Actions
1. First concrete next step.
2. Second concrete next step.
```

## Guardrails

- Prefer concrete facts over narrative.
- Use file paths and line ranges instead of large code snippets.
- Do not omit blockers, assumptions, or unverified areas.
