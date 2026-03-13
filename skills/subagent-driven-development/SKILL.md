---
name: subagent-driven-development
description: "Execute an approved implementation plan in the current session by dispatching a fresh implementer subagent per task or chunk, then running spec-compliance review before code-quality review. Use when you say: 'execute this plan with subagents', 'drive this implementation task-by-task', 'use implementer and reviewer agents', or when an approved plan has independent chunks that benefit from same-session orchestration with `implementing-plans`, `using-jj-workspaces`, and `specification-driven-tdd`."
---

# Subagent-Driven Development

Execute an approved plan by acting as the controller. Keep the work in the current session, dispatch a fresh implementer subagent per task, and enforce two review gates in order: spec compliance first, code quality second.

This skill is an execution mode on top of the existing plan workflow in this repo. Reuse the repo's plan, JJ workspace, and specification-first rules instead of restating them.

## Use This Skill When

- The plan is already approved
- The next chunk or task is independent enough to hand to a fresh subagent
- The user wants same-session orchestration instead of a separate handoff
- The work benefits from explicit review loops after each task

## Do Not Use This Skill When

- No approved plan exists yet
- The plan is missing governing specifications or verification steps
- The next work items are tightly coupled and should be done manually in one thread
- The user wants a different execution workflow than the repo's existing plan-first, spec-first approach

## Nested Delegation Boundary

This skill is the only Stage 10 nested orchestrator allowed by `software-builder` Option 2.

- Allowed child delegates: `implementer`, `spec-reviewer`, `code-quality-reviewer`
- Child delegates are leaves and may not spawn subagents
- Maximum depth inside this skill is one child hop

If deeper delegation is proposed, stop and return `BLOCKED` to the caller.

## Controller Workflow

1. Read the full approved plan, governing specifications, and the files required to understand the next unblocked task.
2. Reuse the chunking and dependency rules from `implementing-plans`. Do not start blocked work.
3. If the plan marks sibling chunks as independent or the current workspace should stay clean, invoke `using-jj-workspaces` before implementation.
4. For the active task, prepare a complete subagent brief:
   - Full task text
   - Governing specification
   - Dependency context and where the task fits in the plan
   - Relevant files and constraints
   - Required automated verification
   - Parent trace metadata (`run_id`, `parent_run_id`, `stage_id`, `depth`, `correlation_id`)
   - Budget envelope and remaining budget
5. Dispatch a fresh implementer subagent with `implementer-prompt.md`. Do not make the subagent rediscover the whole plan when the controller can provide the relevant context directly.
6. For every subagent return (including retries, `BLOCKED`, and `NEEDS_CONTEXT`), append an entry to `stage-10-subagent-returns.md` before deciding what to do next.
7. Require the implementer to follow `specification-driven-tdd` and the active phase rules from `implementing-plans`.
8. When implementation returns, run spec-compliance review with `spec-reviewer-prompt.md`.
9. If spec review finds issues, send the task back to the implementer, then rerun spec review until it passes.
10. Only after spec review passes, run code-quality review with `code-quality-reviewer-prompt.md`.
11. If code-quality review finds issues, send the task back to the implementer, then rerun code-quality review until it passes.
12. Mark the task complete only when both reviews pass and the required checks are green.
13. Only after the task is complete, the controller updates plan state and performs commit or bookmark actions.
14. Reassess the plan after each completed task. If new chunks are now unblocked, decide whether to continue in the current workspace or create another isolated JJ workspace.
15. After all planned tasks are complete, run one final integration review across the whole implementation.
16. The **stage-10 execution log** (`stage-10-execution-log.md`) in the plan directory is a living document. The implementer subagent appends its slice entry on every `DONE` or `DONE_WITH_CONCERNS` return, so progress is captured incrementally. If work is stopped and resumed later, the log shows exactly where things left off.
17. **Gate check**: Before signaling completion to the caller, verify both `stage-10-execution-log.md` and `stage-10-subagent-returns.md` exist at the expected plan directory path and include all completed slices plus all subagent dispatch returns. If either is missing or incomplete, write or repair it before exiting.

## Controller Responsibilities

The controller owns workflow state across the whole task loop.

- Select the next unblocked task from the approved plan
- Prepare the subagent brief and choose the correct companion prompt
- Enforce bounded nested delegation (`implementer`, `spec-reviewer`, `code-quality-reviewer` only)
- Keep review order strict: spec compliance before code quality
- Decide whether to redispatch, split work further, or repair the plan/specification
- Persist every subagent return to `stage-10-subagent-returns.md` with budget + trace metadata
- Update plan checkboxes only after the task is actually complete
- Create commits and move bookmarks only after the implementation and both reviews pass

## Per-Task Dispatch Loop

Use the companion prompts in this order for every task:

1. `implementer-prompt.md`
   Provide the task text, governing specification, context, constraints, and required verification.
2. `spec-reviewer-prompt.md`
   Provide the approved plan task, governing specification, relevant tests, and implementer output.
3. `code-quality-reviewer-prompt.md`
   Provide the approved task, changed files or diff context, and enough architectural context to judge maintainability and decomposition.
4. Append each return to `stage-10-subagent-returns.md` using the required budget + trace fields before deciding whether to redispatch or proceed.

Do not skip or reorder this loop.

## Subagent Return Ledger (Markdown)

`stage-10-subagent-returns.md` is an append-only artifact in the plan directory.

Each entry must include:

- Timestamp, active task/slice, and delegate role
- Status and concise summary
- Budget snapshot (`input_tokens`, `output_tokens`, `total_tokens`, `requests`, `tool_calls`; `unknown` allowed with reason)
- Trace metadata (`run_id`, `parent_run_id`, `stage_id`, `depth`, `correlation_id`, `started_at`, `ended_at`, `duration_ms`)
- Artifact paths and verification references
- Redispatch or handoff decision

The controller writes this file. Subagents provide data; they do not own lifecycle artifact persistence.

## Implementer Outcomes

Handle implementer status explicitly. Do not ignore escalations.

- `DONE`: move to spec-compliance review
- `DONE_WITH_CONCERNS`: read the concerns before review; resolve scope or correctness concerns first
- `NEEDS_CONTEXT`: provide the missing context and redispatch
- `BLOCKED`: change something before retrying

When an implementer is blocked:

1. If context is missing, provide it and redispatch.
2. If the task needs broader reasoning, use a more capable subagent.
3. If the task is too large, split it into smaller tasks that still respect the plan.
4. If the plan or specification is wrong, stop and repair it before continuing.

## Review Order

Review order is fixed:

1. Spec-compliance review
2. Code-quality review

Never start code-quality review before spec-compliance review passes. A clean implementation of the wrong behavior is still wrong.

## Non-Negotiable Rules

- Do not start implementation without an approved plan.
- Do not bypass the governing specification.
- Do not skip `specification-driven-tdd`.
- Do not ask the implementer to read the entire plan if the controller can provide the relevant excerpt and context.
- Do not continue past unresolved review findings.
- Do not treat implementer self-review as a substitute for spec review or code-quality review.
- Do not let subagents create commits, move bookmarks, or update the plan. (Exception: the implementer appends to the stage-10 execution log.)
- Do not let child delegates spawn additional subagents or orchestrators.
- Do not process a subagent result until it is persisted to `stage-10-subagent-returns.md`.
- Do not start a blocked chunk because it "looks small".
- Do not serialize clearly independent work without a reason; prefer the plan's parallelization guidance and `using-jj-workspaces`.
- Do not signal completion without both `stage-10-execution-log.md` and `stage-10-subagent-returns.md` on disk in the plan directory.

## Integration

Use this skill alongside the existing repo skills:

- `implementing-plans` for phase ordering, dependency handling, and verification expectations
- `using-jj-workspaces` when isolated JJ workspaces are the safer execution path
- `specification-driven-tdd` for the implementation loop inside each task
- `writing-technical-specifications` when the governing contract is missing or incomplete

## Companion Resources

Companion prompt resources live alongside this skill and should stay narrowly scoped to one role each.

- `implementer-prompt.md` is the execution prompt for implementing one plan task under controller supervision without owning commits, bookmarks, or plan updates
- `spec-reviewer-prompt.md` is the spec-compliance review prompt for checking plan scope, governing specifications, and contract-test alignment
- `code-quality-reviewer-prompt.md` is the post-spec-review quality prompt for maintainability, decomposition, and plan-structure concerns
