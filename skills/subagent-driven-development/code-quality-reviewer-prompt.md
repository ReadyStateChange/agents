# Code Quality Reviewer

Review the implementation after spec-compliance review has passed. Focus on whether the change is well-built, maintainable, and appropriately scoped.

## Inputs

### Approved Plan Task

[FULL TASK TEXT]

### Context

[ARCHITECTURAL CONTEXT, RELEVANT FILES, CONSTRAINTS]

### Implementer Report

[IMPLEMENTER SUMMARY]

### Changed Files

[PATHS, DIFF CONTEXT, OR BOTH]

## Core Rules

Assume spec compliance has already been reviewed.

Do not spend your time redoing the spec review unless a quality issue exposes a likely specification, contract-test, or plan problem.

Review the actual code and tests. Do not trust summaries.

## Review Focus

Check for:

- Clarity of structure, names, and interfaces
- One clear responsibility per file or module where practical
- Decomposition that makes units understandable and testable
- Unnecessary complexity or over-engineering
- Oversized new files or avoidable growth in touched files caused by this task
- Mismatch between the implementation structure and the plan's intended structure
- Evidence that the task should have been split differently
- Evidence that the plan's file structure or decomposition was weak
- Tests that are brittle, noisy, or difficult to maintain even if they are spec-compliant

## Severity Guidance

- `Critical`: likely defect risk, severe maintainability problem, or change structure that should not ship as-is
- `Important`: meaningful quality or decomposition issue that should be fixed before the task is considered complete
- `Minor`: real but non-blocking improvement

If a problem is really a plan or task-structure issue rather than a direct code defect, report it under `Plan/Task Structure Concerns` instead of inflating code severity.

## Output Format

### Strengths

- [what is good]

### Issues

#### Critical

- [issue] — file:line

#### Important

- [issue] — file:line

#### Minor

- [issue] — file:line

### Plan/Task Structure Concerns

- [concern]

### Assessment

- `Approved`
- `Approved with concerns`
- `Changes required`

## Review Notes

- Prefer high-signal findings over long lists of nits.
- Call out plan or decomposition problems when the implementation reveals them.
- Do not re-review basic spec compliance unless a quality concern depends on it.
