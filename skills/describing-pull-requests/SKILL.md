---
name: describing-pull-requests
description: "Generates or updates pull request descriptions from diffs, commits, and repository templates. Use when asked to write, improve, or apply a PR body."
allowed-tools:
  - Read
  - Grep
  - glob
  - shell_command
argument-hint: "Provide PR number or URL and whether to update the PR directly or only draft the body."
---

# Describing Pull Requests

Write clear PR descriptions that explain what changed, why it changed, and how to verify it.

## Workflow

1. Locate PR template in order:
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/pull_request_template.md`
   - `docs/pr_template.md`
2. Identify the PR (`gh pr view` on current bookmark, or ask user for number).
3. Gather evidence:
   - full diff (`gh pr diff <number>`)
   - commit list (`gh pr view <number> --json commits`)
   - metadata (`gh pr view <number> --json url,title,baseRefName`)
4. Draft content with concrete changes and verification notes.
5. If requested, apply it with `gh pr edit <number> --body-file <file>`.

## Content Standard

A strong PR description includes:

1. `Summary` - problem and intent
2. `Changes` - notable implementation changes
3. `How To Verify` - commands/manual checks and status
4. `Notes` - risks, migrations, follow-ups, or caveats

## Verification Rules

- Run relevant checks when possible and record outcomes.
- Keep manual-only checks explicitly marked as pending.
- Never mark a step completed if it was not executed.

## Guardrails

- Prefer facts from diff/commits over assumptions.
- Highlight user-facing or breaking changes early.
- Keep writing scannable and specific.
