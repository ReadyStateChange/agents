---
name: requesting-code-review
description: "Use when completing tasks, implementing major features, or before merging to verify work meets requirements. Dispatches a code-reviewer subagent to catch issues before they cascade."
---

# Requesting Code Review

Dispatch a code-reviewer subagent to catch issues before they cascade.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing a major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing a complex bug

## How to Request

**1. Identify the change range:**
```bash
# Review the current change
jj log -r @ --no-graph -T 'change_id.short() ++ "\n"'

# Or find the range of changes since a bookmark
jj log --no-graph -r 'roots(::@ ~ ::main)::@' -T 'change_id.short() ++ " " ++ description.first_line() ++ "\n"'
```

**2. Dispatch the code-reviewer subagent:**

Use the Task tool and fill the template at `code-reviewer.md` with these placeholders:

- `{WHAT_WAS_IMPLEMENTED}` — What you just built
- `{PLAN_OR_REQUIREMENTS}` — What it should do (plan task, spec, or requirements)
- `{FROM_REV}` — Starting revision (e.g., `main`, parent change ID)
- `{TO_REV}` — Ending revision (e.g., `@` or a change ID)
- `{DESCRIPTION}` — Brief summary of the change

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if the reviewer is wrong (with reasoning)

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

jj log --no-graph -r 'roots(::@ ~ ::main)::@' -T 'change_id.short() ++ " " ++ description.first_line() ++ "\n"'

[Dispatch code-reviewer subagent]
  WHAT_WAS_IMPLEMENTED: Verification and repair functions for conversation index
  PLAN_OR_REQUIREMENTS: Task 2 from docs/plans/deployment-plan.md
  FROM_REV: main
  TO_REV: @
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators]
[Continue to Task 3]
```

## Security Review Integration

When changes touch authentication, authorization, data handling, external APIs, or secrets, dispatch the `security-checklist` security-reviewer subagent in parallel with the code-reviewer. Both use the same revision range. Merge findings into the review feedback.

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task

**Implementing Plans:**
- Review after each batch (3 tasks)
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If the reviewer is wrong:**
- Push back with technical reasoning
- Show code or tests that prove it works
- Request clarification
