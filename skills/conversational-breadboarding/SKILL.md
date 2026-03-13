---
name: conversational-breadboarding
description: "Facilitates a human-in-the-loop breadboarding conversation using brainstorming to clarify affordances and wiring before finalizing tables. Use when you want breadboard rigor with iterative Q&A and explicit human approval."
---

# Conversational Breadboarding

Guides breadboarding through a structured conversation so the human and agent co-build the affordance model before it is finalized.

## Outcome

Produce the same core artifact as `breadboarding`:
- Places table
- UI Affordances table
- Code Affordances table
- Data Stores table (when state is relevant)
- Optional Mermaid visualization

And add conversational proof:
- Human-reviewed decisions captured during iteration
- Explicit approval gate before finalizing the breadboard artifact
- Open questions list (blocking vs non-blocking)

<HARD-GATE>
Do not finalize the breadboard artifact without a `brainstorming` conversation and explicit human approval.
</HARD-GATE>

<HARD-GATE>
Do not replace affordance tables with prose summaries. Tables remain the source of truth.
</HARD-GATE>

## When To Use

Use when:
- The workflow is ambiguous and needs guided clarification
- You want the human to validate affordance boundaries, wiring, and assumptions as you go
- Breadboarding is part of a larger stage-gated lifecycle and needs an approval checkpoint

Do not use when:
- The user explicitly requests a fast, non-conversational breadboard (use `breadboarding`)
- Breadboard artifacts already exist and only minor mechanical edits are needed

## Core Principles

1. Preserve breadboarding rigor: model Places, Us, Ns, stores, and wiring explicitly.
2. Keep the human in the loop: clarify uncertain edges before locking tables.
3. One focused question at a time when ambiguity exists.
4. Distinguish control flow (`Wires Out`) from data flow (`Returns To`).
5. Prefer real affordance names from code when mapping existing systems.

## Required Conversation Behavior

1. Invoke `brainstorming` before finalizing tables.
2. Ask one focused question per turn when resolving ambiguity.
3. After each answer, restate what changed in the draft model.
4. Re-render full affected tables after meaningful updates.
5. Mark changed table cells with 🟡 during iterative review.

## Workflow

Create tasks for each step and complete in order.

1. Frame the workflow and scope
2. Run a `brainstorming` loop to resolve affordance ambiguity
3. Build draft affordance tables incrementally
4. Run breadboarding integrity checks
5. Secure human approval
6. Finalize artifact and handoff context

### 1) Frame The Workflow And Scope

Establish:
- Operator goal (what effect they are trying to cause)
- Entry point and expected outcome
- System boundaries (single system vs multi-system)

Minimum output:

```markdown
## Breadboard Scope

- Workflow: ...
- Entry point: ...
- Expected outcome: ...
- Boundaries: ...
```

### 2) Run Brainstorming Loop

Use `brainstorming` to clarify:
- Place boundaries (blocking test)
- Which affordances are actionable vs mechanisms
- Ambiguous wiring or missing data sources

Keep questions pointed and sequential. If multiple ambiguities exist, resolve them one at a time.

### 3) Build Draft Tables Incrementally

Construct in this order:
1. Places table
2. UI affordances table
3. Code affordances table
4. Data stores table (if state handoff/read-write exists)

For each table revision:
- Re-render the full affected table(s)
- Keep IDs stable where possible
- Use 🟡 on changed cells

### 4) Run Breadboarding Integrity Checks

Before approval, verify:
- Every display U has an incoming data source
- Every N has `Wires Out`, `Returns To`, or both
- Navigation wires target Places directly
- Stores are placed where behavior is enabled
- Mechanism-only steps are collapsed to meaningful affordances

### 5) Secure Human Approval

Present:
- Final draft tables
- Optional Mermaid diagram
- Open questions with blocking status

Request explicit approval:

```markdown
Approve this breadboard as the Stage 3 source of truth?
- Yes, approve
- Revise (specify what to change)
```

If revision is requested, return to Step 2.

### 6) Finalize Artifact And Handoff Context

Finalize the breadboard artifact with:
- Complete affordance tables
- Optional Mermaid visualization
- Decision log from conversation
- Open questions list with blocking labels

Then hand off to downstream skills (`translating-shape-to-spec`, `slicing-work`, or lifecycle controller).

## Completion Checklist

Do not complete this skill until all are true:

1. Workflow scope is explicit.
2. `brainstorming` conversation resolved key ambiguities.
3. Places, UI, Code, and Stores are modeled where relevant.
4. Integrity checks pass.
5. Human approval is explicitly captured.
6. Open questions are visible and labeled blocking/non-blocking.

## Deliverable Template

Use this structure for the final artifact:

```markdown
---
breadboarding: true
conversational: true
---

# [Topic] — Conversational Breadboard

## Breadboard Scope
- Workflow: ...
- Entry point: ...
- Expected outcome: ...
- Boundaries: ...

## Places
| # | Place | Description |
|---|-------|-------------|

## UI Affordances
| # | Place | Component | Affordance | Control | Wires Out | Returns To |
|---|-------|-----------|------------|---------|-----------|------------|

## Code Affordances
| # | Place | Component | Affordance | Control | Wires Out | Returns To |
|---|-------|-----------|------------|---------|-----------|------------|

## Data Stores
| # | Place | Store | Description |
|---|-------|-------|-------------|

## Decision Log
- ...

## Open Questions
| Question | Blocking? | Owner |
|----------|-----------|-------|

## Approval Record
- Reviewer:
- Result: Approved / Revisions requested
- Notes:
```

## Notes On Related Skills

- Use `breadboarding` for non-conversational affordance mapping.
- Use `conversational-breadboarding` when you need an explicit human-in-the-loop gate.
- Use `translating-shape-to-spec` and `slicing-work` after approval.
