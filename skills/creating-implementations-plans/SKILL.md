---
name: creating-implementations-plans
description: "Creates detailed specification-first implementation plans through interactive research and iteration. Consolidates creating-plans and creating-implementation-plans into one canonical skill. Use when you say: 'plan this feature', 'create a plan', 'write an implementation spec', 'design doc for...', 'technical spec', or 'plan the rollout for...'."
---

# Creating Implementations Plans

Create detailed implementation plans through interactive, iterative research. Be skeptical, thorough, and collaborative. The specification is the source of truth: phases, tests, and verification must all trace back to explicit contracts.

## Getting Started

1. **If functional spec, technical spec, and slices are provided together**: run in slice-first mode and plan one implementation phase per slice (or explicitly justified coupled slices)
2. **If a file path, ticket, or specification was provided**: read it fully and begin research
3. **Identify the contracts that will change**:
   - If an implementation-independent specification already exists, use it
   - If the task changes behavior and no specification exists yet, invoke `writing-specifications` before designing phases
   - If the intended behavior is ambiguous, resolve that ambiguity before planning
4. **If no input provided**, ask:
   - The task/ticket description or reference
   - Any relevant context, constraints, or requirements
   - Links to related specifications, research, or previous implementations
5. **Before finalizing any plan draft**, invoke `brainstorming` to walk through the plan with the human and gather explicit refinement feedback

## Workflow

### Step 1: Context Gathering

1. **Read all mentioned files fully** (tickets, research docs, related plans)
2. **Research the codebase**:
   - Use `finder` to locate all files related to the task
   - Use `Read` to understand current implementations
   - Search for existing research, plan, or specification documents in the project's docs directory
3. **Read all files identified by research** into main context
4. **Present informed understanding** with file:line references and ask only questions that research couldn't answer

### Step 2: Establish the Specification

Before designing phases:

1. Identify each new or changed contract the work will touch
2. Link the existing specification sections that govern those contracts, or write/refine them with `writing-specifications`
3. If a contract introduces a new domain type, include its type definition in the specification and make illegal states unrepresentable; prefer branded or opaque types over raw primitives
4. Separate **contract changes** from **implementation changes**
5. Reject plans that would change behavior without an explicit specification delta

### Step 3: Research & Discovery

After the specification is clear:

1. If the user corrects a misunderstanding, **verify with new research** — don't blindly accept
2. Investigate further as needed:
   - Find similar features and patterns to model after
   - Understand integration points and dependencies
   - Inventory dependency and third-party deltas (new packages, package upgrades, test-runtime dependencies such as `jsdom`, new external APIs, and new hosted services)
   - Extract insights from existing research or decision documents
   - Determine whether existing untested code will need delete-and-rebuild treatment under `specification-driven-tdd`
3. Present findings, design options with pros/cons, and open questions

### Step 4: Plan Structure

Present the proposed phase structure and get feedback before writing details. Every phase must map to a specific specification slice and its contract tests. The plan must cover the whole contract for that phase, including outputs, documented errors, mutations, and side effects, while making clear that implementation proceeds one RED-GREEN-REFACTOR test at a time.

Testing strategy cannot be deferred to the end of the plan. Every phase must include its own test strategy and a test checklist with explicit test items that can be checked off as each test turns GREEN.

Each phase must also be self-contained. An agent handed only that phase should have everything needed to execute it independently: governing spec, relevant files, dependencies, constraints, contract-test inventory, execution order, and verification steps.

The plan must also make chunk dependencies explicit. Treat each phase as an execution chunk unless you explicitly split it further. For every chunk, state what it depends on, what it unblocks, and which sibling chunks can run in parallel once prerequisites are satisfied. Parallel execution is the preferred default whenever dependencies allow it, so actively shape the plan to maximize independent chunks. When parallel execution is viable, call out that `using-jj-workspaces` should be used.

The plan must explicitly call out dependency and third-party service deltas. Assign each delta to the earliest phase that needs it. A shared enablement phase is allowed only when the same dependency/service is required by multiple downstream phases.

Use the following outline by default unless the user explicitly requests a different structure. Keep the section order stable.

```
## Review Outcome
## Global Contract Rules
## Overview
## Current State Analysis
### What Exists Today
### Gaps Blocking Implementation
## Desired End State
## End-State Verification
## Locked Decisions
## What We Are Not Doing
## Version Control Workflow (Jujutsu)
## Parallel Execution Strategy
### Chunk Dependency Map
#### Chunk N: [Descriptive Name]

## Dependency and Third-Party Delta
### New or Changed Dependencies
### New External APIs and Hosted Services
### Per-Phase Ownership and Earliest Introduction Point
### Installation/Provisioning and Verification Commands

## Phase N: [Descriptive Name]
### Goal
### Phase Execution Rules
### Specifications / Workflow Specification / Workflow Specifications
#### Contract N.1: ...
### Step Specifications
#### Contract N.X: ...
### Contract Coverage Checklist
#### Contract N.1 checklist
### Specification-Driven TDD Workflow
### Phase Test Strategy
### Phase Test Checklist (Mark Green During Implementation)
### Files
### Phase Gate

## Cross-Phase Test Notes (Optional, Does Not Replace Phase Test Strategy)
### Unit Contracts
### Integration Contracts
### E2E Contracts

## Migration Notes
## Security Review
## References
```

### Step 4b: Security Review

After the plan structure is confirmed, invoke `security-checklist` (plan review mode) against the proposed plan. Add the `## Security Review` section to the plan output, before `## References`.

### Step 5: Brainstorming Plan Walkthrough (Required)

Before writing the final plan artifact:

1. Invoke `brainstorming`
2. Walk through the proposed plan sections with the human (scope, sequencing, dependencies, and tests)
3. Capture requested refinements and confirm decisions explicitly
4. Do not finalize the plan until the human confirms the walkthrough outcome

### Step 6: Write the Plan

Before writing the final artifact:

1. Run via Bash: `jj status` and confirm the working copy is clean
2. If the working copy is not clean, describe the existing changes to the user, then run via Bash: `jj new` to start from a clean working copy

Then write the plan artifact:

Save to the project's plans directory as `YYYY-MM-DD-description.md` (e.g., `docs/plans/`). Add a ticket ID prefix if one exists.

Use this template:

````markdown
# [Feature/Task Name] Implementation Plan

## Review Outcome
[Short statement of the current review state, recommendation, and whether the plan is ready to implement]

## Global Contract Rules
- [Rule that applies across all phases]
- [Include one-test-at-a-time RED-GREEN-REFACTOR execution here]
- [Include spec-first and observable-contract-only test rules here]
- [When a contract introduces a new type, include a type definition that makes illegal states unrepresentable and use branded/opaque domain types by default]

## Overview
[Brief description of what we're implementing and why]

## Current State Analysis
### What Exists Today
- [Current behavior or system capability]
- [Relevant file:line references]

### Gaps Blocking Implementation
- [Missing invariant, workflow, schema, command, or UX behavior]
- [Why the gap matters]

## Desired End State
[Specification of the desired end state]

## End-State Verification
- [Observable outcome that must be true at the end]
- [Release or verification command]

## Locked Decisions
- [Decision already made and not reopened by this plan]

## What We Are Not Doing
[Explicitly list out-of-scope items]

## Version Control Workflow (Jujutsu)
- Before writing the plan, check for a clean working copy with `jj status`
- If the working copy is not clean, describe the existing changes, then run `jj new` to start from a clean working copy before editing the plan
- After writing the plan, run `jj describe` with a message describing what the plan covers
- During implementation, require each phase to start from a clean working copy (`jj status` clean); if dirty, run `jj new` before phase work begins
- [Any additional bookmark or review rule]

## Parallel Execution Strategy
### Chunk Dependency Map
Use this section to make parallel work the default execution model whenever dependencies allow it.
#### Chunk 1: [Descriptive Name]
- Depends on: [`none` or earlier chunk IDs / completed prerequisites]
- Unblocks: [later chunk IDs or `none`]
- Parallelizable with: [chunk IDs that can proceed at the same time once dependencies are satisfied, or `none`]
- Workspace strategy: [whether `using-jj-workspaces` should be used for this chunk]

#### Chunk 2: [Descriptive Name]
- Depends on: [earlier chunk IDs / completed prerequisites]
- Unblocks: [later chunk IDs or `none`]
- Parallelizable with: [chunk IDs or `none`]
- Workspace strategy: [whether `using-jj-workspaces` should be used for this chunk]

## Dependency and Third-Party Delta

### New or Changed Dependencies
- [Dependency name and version/range]
- [Why it is needed and what contract/slice requires it]

### New External APIs and Hosted Services
- [Service/API name]
- [Auth/secrets, rate limits, and operational constraints]

### Per-Phase Ownership and Earliest Introduction Point
- [Phase N owns introducing dependency/service X]
- [Use a dedicated shared enablement phase only when multiple downstream phases depend on the same delta]

### Installation/Provisioning and Verification Commands
- Install/provision command: `[command]`
- Verification command: `[command]`
- Rollback/removal note: [how to back out if the phase is reverted]

---

## Phase 1: [Descriptive Name]

### Goal
[One-paragraph statement of what this phase achieves]

### Phase Execution Rules
- Governing specifications: `[path/to/spec]`
- Required context: [ticket, research finding, or business rule needed to execute this phase]
- Dependencies / prerequisites: [earlier phase output, migration, feature flag, fixture, env var, or `none`]
- Dependency/service deltas introduced in this phase: [new package additions/upgrades, test runtime requirements, third-party services, or `none`]
- Chunk dependencies: [chunk IDs or phase names that must be complete before this work starts]
- Unblocks: [chunk IDs or phase names that become available after this phase passes]
- Parallelization note: [which chunks can run in parallel after dependencies are met, and when `using-jj-workspaces` should be used]
- Phase start hygiene: [run `jj status` before phase work; if dirty, stop and run `jj new` before changes]
- Relevant existing files: `[path/to/file]` - [why this file matters]
- Constraints / non-goals: [phase-local limits]
- Execution order: [run one RED-GREEN-REFACTOR loop per new contract test; do not batch tests]
- Testing strategy source of truth: [this phase's `Phase Test Strategy` and `Phase Test Checklist`; do not defer testing detail to a later section]
- Agent handoff note: [what another agent needs to know if given only this phase]

### Specifications
#### Contract 1.1: [Contract title]
[Implementation-independent contract]
[If this contract introduces a new domain type, include its type definition here using branded/opaque types or another representation that makes illegal states unrepresentable]

#### Contract 1.2: [Contract title]
[Implementation-independent contract]

### Step Specifications
#### Contract 1.X: [Step-level contract title]
[Step-level contract if the phase contains a workflow; omit this section when not needed]

### Contract Coverage Checklist
#### Contract 1.1 checklist
- [ ] [Observable output]
- [ ] [Documented error]
- [ ] [Documented mutation or side effect]

#### Contract 1.2 checklist
- [ ] [Observable output]

### Specification-Driven TDD Workflow
- First test to write: [failing contract test derived from Contract 1.1]
- Remaining contract-test inventory: [ordered list for the rest of the phase]
- Execution rule: [complete each test through RED, GREEN, and REFACTOR before adding the next]
- Delete-and-rebuild note: [when existing untested code must be replaced instead of adapted]
- Commands: `[targeted test command]`, `[typecheck/lint/test commands]`

### Phase Test Strategy
- Contract-to-test mapping: [map each contract and checklist item to at least one concrete test]
- Test levels in this phase: [unit/integration/e2e as applicable]
- Execution order: [risk-first sequence and why]
- Evidence capture: [where passing output/log references are recorded]

### Phase Test Checklist (Mark Green During Implementation)
- [ ] `T1` [contract test name] — covers [Contract 1.X], command: `[command]`
- [ ] `T2` [contract test name] — covers [Contract 1.Y], command: `[command]`
- [ ] `T3` [integration/e2e test name if applicable], command: `[command]`

### Files
- `[path/to/file]` - [change required]
- `[path/to/file]` - [change required]

### Phase Gate
#### Automated Verification
- [ ] Phase started from a clean working copy (`jj status` clean before first code change)
- [ ] Specification exists or has been updated before code changes
- [ ] Contract coverage checklist covers all outputs, errors, mutations, and side effects in scope
- [ ] Contract tests are executed one at a time and each fails for the expected reason before code is written
- [ ] Each targeted contract test passes before the next new contract test is added
- [ ] All `Phase Test Checklist` items for this phase are checked `[x]` after turning GREEN
- [ ] Declared dependency/service deltas for this phase are installed or provisioned and verified with explicit commands
- [ ] Phase-specific commands pass

#### Manual Verification
- [ ] [Manual check for this phase]
- [ ] [Regression check for this phase]

---

## Phase 2: [Descriptive Name]
[Repeat the same phase structure, adjusting `Specifications`, `Workflow Specification`, `Workflow Specifications`, and `Step Specifications` as needed for the phase]

## Cross-Phase Test Notes (Optional, Does Not Replace Phase Test Strategy)

### Unit Contracts
- [Cross-phase unit coverage]

### Integration Contracts
- [Cross-phase integration coverage]

### E2E Contracts
- [Cross-phase end-to-end coverage]

## Migration Notes
- [Migration, repair, rollout, or legacy-data considerations]

## Security Review

**Status:** [Clean | Concerns Noted | Blockers Found]
**Reviewed:** [Date]

### Findings
[Output from `security-checklist` plan review mode]

### Checklist Coverage
[Which categories were applicable vs not relevant]

## References
- Original ticket: [link or path]
- Governing specifications: `[path/to/spec]`
- Related research: [link or path]
- Similar implementation: `[file:line]`
````

### Step 7: Commit and Review

1. Run via Bash: `jj describe -m "plan: [summary of what the plan covers]"` to describe the change containing the new plan
2. Present the draft plan location and ask for review
3. Continue refining until satisfied
4. Only create a bookmark/branch if explicitly asked to

## Guidelines

- **Be skeptical**: Question vague requirements, verify with code, don't assume
- **Be interactive**: Get buy-in at each step, don't write the full plan in one shot
- **Be thorough**: Include file paths, line numbers, measurable success criteria
- **Be practical**: Incremental testable changes, consider edge cases
- **Use brainstorming for human-in-the-loop planning**: Walk through the plan with `brainstorming` and collect explicit human feedback before finalizing
- **Spec-first always**: No implementation phase without a linked specification and a planned failing contract test
- **Plan full coverage, execute sequentially**: The plan must enumerate contract-test coverage for the full specification slice, but implementation must still run one RED-GREEN-REFACTOR loop per test
- **Require per-phase testing plans**: Every phase must contain `Phase Test Strategy` and `Phase Test Checklist`; do not defer testing strategy to the end
- **Track GREEN status explicitly**: Phase test checklist items must start unchecked and be designed to be checked off as tests pass
- **Use the canonical outline**: Produce plans in the exact section order above unless the user explicitly asks for a different structure
- **Match phase anatomy to the work**: Use `Specifications`, `Workflow Specification`, `Workflow Specifications`, and `Step Specifications` intentionally based on whether the phase defines invariants, a single workflow, multiple workflows, or workflow steps
- **Expose chunk dependencies**: Make blocked-by, unblocks, and parallelizable relationships explicit so another agent can see what can run concurrently without rereading the whole plan
- **Make phases self-contained**: A phase should be executable by another agent without reconstructing missing context from the rest of the plan
- **Make dependency/service deltas explicit**: Add a dedicated dependency delta section and assign each delta to the earliest owning phase (or an explicitly justified shared enablement phase)
- **Prefer parallel execution**: Default to splitting work into independent chunks whenever the contract and dependency graph allow it
- **Plan parallel execution intentionally**: When chunks are independent, say so explicitly and note that `using-jj-workspaces` is the default isolation strategy
- **Maintain contract numbering symmetry**: Every `Contract N.X` section should have a matching checklist subsection in the same phase
- **Type new domains explicitly**: If a contract introduces a new type, include a type definition in the specification that makes illegal states unrepresentable and prefer branded/opaque types over primitive aliases
- **Start clean**: Before creating a plan, ensure the working copy is clean; if not, describe the existing changes and use `jj new` before editing
- **Start each implementation phase clean**: The plan must require `jj status` cleanliness at phase start and include what to do when the working copy is dirty
- **No open questions in final plan**: Research or ask for clarification immediately — every decision must be made before finalizing
- **Separate contract from code**: Call out contract-preserving edits vs explicit specification deltas
- **Separate success criteria**: Always distinguish automated (commands to run) from manual (human testing)
