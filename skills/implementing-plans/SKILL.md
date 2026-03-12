---
name: implementing-plans
description: "Implements approved specification-first plans phase by phase with verification. Use when you say: 'implement this plan', 'execute the plan', 'build from this plan', 'implement phase 1', 'follow the plan step-by-step'."
---

# Implementing Plans

Implement approved technical plans with phase-by-phase verification. The plan organizes the work, but the specification governs the behavior. Follow `specification-driven-tdd` within each phase.

## Getting Started

When given a plan path:

1. Read the plan completely — check for existing checkmarks (`- [x]`)
2. Read the governing specification(s), original ticket, and all files mentioned in the plan
3. Read files fully — never partially
4. For the first unchecked phase, confirm the plan identifies:
   - The governing specification
   - The behavior being introduced or changed
   - The contract tests that must be written first
   - A `Phase Test Strategy` and `Phase Test Checklist` for that phase
   - Its chunk dependencies, what it unblocks, and whether it can run in parallel with other work
5. If any of those are missing, stop and repair the plan/specification before writing production code
6. Start with the earliest unchecked phase whose dependencies are satisfied, but if multiple chunks are unblocked, prefer executing them in parallel rather than serially

If no plan path provided, ask for one.

## Workspace Strategy

- Read the plan's `Parallel Execution Strategy` before choosing where to work.
- If multiple independent chunks are unblocked, treat parallel execution as the default and use `using-jj-workspaces` to create one isolated JJ workspace per active chunk.
- If only one chunk is ready, the current workspace is fine unless the user asked for isolation.
- Never start a chunk whose listed dependencies are incomplete.
- When a chunk unblocks parallel follow-up work, stop and reassess immediately; default to separate JJ workspaces rather than continuing serially unless a dependency or resource constraint prevents it.

## Bookmark Strategy

Each independently executable phase or chunk gets its own bookmark that builds on the required prerequisites. Before starting Phase 1, create the bookmark:

```bash
jj bookmark create <plan-name>/phase-1
jj bookmark track <plan-name>/phase-1 --remote origin
```

After completing and verifying each phase, write a commit message that summarizes what you **actually** changed — not what the plan said to change. Describe the real files modified, functions added, bugs fixed, etc.

```bash
jj new -m "implement: [plan name] phase [N]: [what was actually done, not the plan's description]"
jj bookmark set <plan-name>/phase-N --to @-
jj git push -b <plan-name>/phase-N
```

Then create a PR using `gh`. The PR description should summarize what was **actually** done (not copy the plan). Always append three review request lines at the end of the body:

```bash
gh pr create \
  --head <plan-name>/phase-N \
  --title "implement: [plan name] phase [N]: [short summary]" \
  --body "[Description of actual changes made]

@claude review
@codex review
@copilot review"
```

Then create the next phase's bookmark on top:

```bash
jj bookmark create <plan-name>/phase-[N+1]
jj bookmark track <plan-name>/phase-[N+1] --remote origin
```

## Implementation Philosophy

- The specification is the source of truth, not the current implementation
- Follow the plan's intent while adapting to what you find in the codebase
- Implement each phase fully before moving to the next
- Respect the plan's chunk dependencies; do not start blocked work early
- Prefer parallel execution whenever the plan shows multiple unblocked chunks
- Use `using-jj-workspaces` when the plan says independent chunks can proceed in parallel
- Write or refine the contract before writing or changing code
- If the contract introduces a new domain type, define it in the specification so illegal states are unrepresentable and prefer branded/opaque types over primitive aliases
- Write exactly one failing contract test before each production change
- Do not batch multiple RED tests before returning to GREEN
- Verify your work makes sense in the broader context
- Update plan checkboxes continuously, checking off each test checklist item as soon as it turns GREEN

## Per-Phase Execution Order

For each phase:

1. Confirm the phase's dependencies are satisfied and that the plan still marks it as unblocked. If not, stop and resolve the dependency mismatch first.
2. If the plan marks sibling chunks as parallelizable and more than one is ready, default to moving this phase into its own JJ workspace via `using-jj-workspaces` before writing code.
3. Confirm the phase's governing specification. If it is missing or wrong, stop and fix the plan/spec first.
4. Confirm the phase includes a `Phase Test Strategy` and `Phase Test Checklist`. If missing, stop and repair the plan before implementing.
5. If the phase changes behavior, write or refine the specification with `writing-specifications` before touching production code.
6. If that specification introduces a new type, add the type definition to the specification using branded/opaque domain types or another form that makes illegal states unrepresentable.
7. Pick the next unchecked test item from the phase's `Phase Test Checklist`.
8. Write exactly one minimal failing contract test derived directly from that specification and checklist item.
9. Run the targeted test and verify RED:
   - It fails, not errors
   - It fails for the expected contract reason
   - No additional new contract tests are written until this test is GREEN
10. If the affected behavior already exists without a prior failing contract test, follow `specification-driven-tdd`: delete the affected implementation and rebuild it from the specification instead of adapting incidental behavior.
11. Write the minimal production code needed to satisfy the contract.
12. Run the targeted contract test again, then the broader automated checks for the phase.
13. Refactor only after GREEN, while preserving the contract.
14. As soon as the test is GREEN, check off the matching item in `Phase Test Checklist`.
15. Repeat the cycle one test item at a time until the phase's `Phase Test Checklist` is fully checked.
16. Update remaining phase-level checkboxes only after the phase is actually verified.

## When Things Don't Match

If the codebase, plan, and specification do not agree:

```
Issue in Phase [N]:
Expected contract: [what the specification says]
Planned work: [what the plan says]
Found: [actual situation]
Why this matters: [explanation]

How should I proceed?
```

## Verification After Each Phase

0. **If the phase has no linked specification or no contract tests to write first**, **STOP** and fix the plan before implementing that phase.
1. **If the phase has no `Phase Test Strategy` or no `Phase Test Checklist`**, **STOP** and fix the plan before implementing that phase.
2. **If the phase has no automated verification steps** (typecheck, lint, tests, etc.), **STOP** and ask the human for explicit permission before implementing that phase. Do not proceed without approval.
3. Verify that each contract test was written before production code and failed for the expected reason. If a test passed immediately, repair the test or remove the prewritten implementation and restart that test item.
4. Verify that only one new contract test was introduced for each active RED-GREEN-REFACTOR loop. If multiple new tests were added up front, collapse back to a single test and resume one test item at a time.
5. Verify that every `Phase Test Checklist` item is checked `[x]` only after its corresponding test is GREEN.
6. Run the automated success criteria checks (targeted contract tests first, then broader checks such as typecheck, lint, and full test suites).
7. Fix any issues before proceeding.
8. Check off completed items in the plan file using edit_file.
9. **If the plan includes manual verification steps for this phase**, pause for human verification:

```
Phase [N] Complete - Ready for Manual Verification

Automated verification passed:
- [List automated checks that passed]

Please perform the manual verification steps listed in the plan:
- [List manual verification items from the plan]

Let me know when manual testing is complete so I can proceed to Phase [N+1].
```

If instructed to execute multiple phases consecutively, skip the pause until the last phase.

Do NOT check off manual testing items until confirmed by the user.

10. **If the plan has no manual verification for this phase**, proceed directly to the next phase after automated checks pass.

After completing each phase, commit, set the bookmark, and push as described in the **Bookmark Strategy** section above.

## Resuming Work

If the plan has existing checkmarks:

- Trust that completed work is done
- Pick up from the first unchecked item
- Re-read the governing specification for the next phase before resuming
- Verify previous work only if something seems off

## Guidelines

- **Do not implement from vibes**: If the intended behavior is not explicit in a specification, stop and write/refine one first
- **Contract tests only**: Tests should assert observable behavior, not helpers, mocks, or private state
- **One test at a time**: Never write a batch of new tests and then implement them together; complete RED-GREEN-REFACTOR for each test before adding the next
- **Use the phase test plan, not improvisation**: Execute tests in the phase's `Phase Test Strategy`/`Phase Test Checklist` order unless explicitly revised
- **Check off tests when GREEN**: Update checklist items immediately when each mapped test passes; do not batch-check at phase end
- **Honor chunk dependencies**: Only pick work that the plan marks as unblocked, and reassess when a completed chunk unlocks parallel follow-up work
- **Prefer parallel execution**: When more than one chunk is unblocked, treat serial execution as the exception and parallel JJ workspaces as the default
- **Use JJ workspaces for parallel chunks**: When the plan identifies independent work, default to `using-jj-workspaces` instead of mixing chunks in one working copy
- **Type new domains in the contract**: When a specification introduces a new type, define it so illegal states are unrepresentable and use branded/opaque domain types by default
- **No silent widening**: Any behavior change requires an explicit specification change
- **No grandfathering untested code**: Existing code without prior failing contract tests is not exempt from the spec-first workflow
- You're implementing a solution, not just checking boxes — keep the end goal in mind
- Use available search tools to debug or explore unfamiliar code as needed
- Read and understand all relevant code before making changes
- Maintain forward momentum
