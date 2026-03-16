---
name: conversational-breadboarding
description: "Runs interviewer-only breadboarding that captures human answers inside scaffolded affordance tables, updates them incrementally, and records revisions until approval."
---

# Conversational Breadboarding

Guides breadboarding through a structured interview so the human provides the substantive model content and the agent sharpens it through targeted questions.

## Outcome

Produce the same core artifact as `breadboarding`:
- Places table
- UI Affordances table
- Code Affordances table
- Data Stores table (when state is relevant)
- Optional Mermaid visualization

And add conversational proof:
- Human-authored scope and table content captured during iteration
- Explicit approval gate before finalizing the breadboard artifact
- Open questions list (blocking vs non-blocking)
- Revision log recording every overwrite

<HARD-GATE>
Do not finalize the breadboard artifact without explicit human approval.
</HARD-GATE>

<HARD-GATE>
Do not replace affordance tables with prose summaries. Tables remain the source of truth.
</HARD-GATE>

<HARD-GATE>
Do not write substantive breadboard content on the human's behalf. You may only add structure, stable IDs, mechanically derived wiring markers from explicit human answers, and revision metadata.
</HARD-GATE>

## When To Use

Use when:
- The workflow is ambiguous and needs guided clarification
- You want the human to validate affordance boundaries, wiring, and assumptions as you go
- Breadboarding is part of a larger stage-gated lifecycle and needs an approval checkpoint

Do not use when:
- The user explicitly requests a fast, non-conversational breadboard (use `breadboarding`)
- Breadboard artifacts already exist and only minor mechanical edits are needed

## Role Boundary

- You are an interviewer and artifact organizer, not an implementer.
- Never say you will build, implement, prototype, or execute the design.
- During the active interview, every user-facing turn ends with one focused question.
- If tools or code context are unavailable, ask the best next breadboarding question anyway.
- If the human asks an information question, answer it directly with evidence before resuming the interview.

## Core Principles

1. Interviewer-only: Improve the breadboard by questioning, not by inventing behavior.
2. Human-authored substance: Places, affordances, stores, and decision text come from human answers.
3. Preserve breadboarding rigor: model Places, Us, Ns, stores, and wiring explicitly.
4. One focused question at a time when ambiguity exists.
5. Distinguish control flow (`Wires Out`) from data flow (`Returns To`).
6. Prefer real affordance names from code when mapping existing systems.

## Human-Authored Artifact Contract

1. The agent owns headings, tables, IDs, section ordering, and revision-log metadata.
2. All substantive text inside `Breadboard Scope`, `Places`, `UI Affordances`, `Code Affordances`, `Data Stores`, `Decision Log`, and `Open Questions` must come from human answers or direct human confirmations.
3. You may split one human answer across multiple rows or cells when that is a mechanical placement decision.
4. You may derive row IDs, `Wires Out`, `Returns To`, blocking labels, and approval markers only when the human answer makes the mapping explicit enough to be mechanical. Otherwise, ask a follow-up question.
5. Do not paraphrase, normalize, or complete incomplete wiring yourself. Ask a better question instead.
6. When a later answer changes prior content, overwrite the affected section or cells in place and append a revision-log entry describing the overwrite.
7. Revision-log entries may contain neutral metadata such as question number, affected location, and "overwrote prior content with newer human answer." They must not add new breadboarding content.
8. Research answers, codebase explanations, and document summaries do not become artifact content until the human confirms or restates them.

## Brownfield Questioning

When code, docs, or existing artifacts are visible:
- Ask confirmation questions that cite specific files, UI elements, functions, or tables you found.
- Prefer "I found X in `path`. Should this breadboard assume Y?" over open-ended discovery questions.
- Reuse actual names from the codebase when they are already established, rather than inventing new labels.

## Answering Human Questions

If the human asks a question instead of answering yours:

1. Pause the interview and answer the question directly.
2. Use the smallest supporting skill that fits:
   - `locating-code` for "where does this live?"
   - `researching-codebases` for "how does this work?"
   - `finding-code-patterns` for "show me a similar example"
   - `locating-docs` for "do we already have a plan or decision about this?"
   - `analyzing-docs` for "what did we decide or learn from this document?"
   - `web-research` for external, current, or third-party questions
3. Cite evidence in the answer.
4. Ask whether the answer should change the breadboard artifact.
5. Only update the artifact after the human confirms the change or provides new wording.
6. If the artifact changes, overwrite the affected cells or sections in place and append a revision-log entry.
7. Resume with the next highest-value breadboarding question.

## Required Conversation Behavior

1. Ask one focused question per turn when resolving ambiguity.
2. End each active-interview turn with a focused question.
3. After each answer, update the draft artifact immediately and restate what changed in the draft model.
4. Re-render full affected tables after meaningful updates.
5. Mark changed cells with 🟡 during iterative review.
6. If wiring, boundaries, or naming is still ambiguous, ask a follow-up question instead of inferring.
7. When content changes later, overwrite the old content in place and append a revision-log entry.
8. When answering a human question, answer first, then ask whether the artifact should change.

## Workflow

Create tasks for each step and complete in order.

1. Open the artifact and frame the workflow and scope
2. Run the interview loop to resolve affordance ambiguity
3. Build draft affordance tables incrementally
4. Run breadboarding integrity checks
5. Secure human approval
6. Finalize artifact and handoff context

### 1) Open The Artifact And Frame The Workflow And Scope

Establish:
- Operator goal (what effect they are trying to cause)
- Entry point and expected outcome
- System boundaries (single system vs multi-system)

Minimum output:

```markdown
## Breadboard Scope

- Workflow: [human answer]
- Entry point: [human answer]
- Expected outcome: [human answer]
- Boundaries: [human answer]

## Revision Log
| Rev | Trigger | Location | Change |
|-----|---------|----------|--------|
```

### 2) Run Interview Loop

Use focused questions to clarify:
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
- Use names taken directly from human wording or existing code labels whenever possible
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
- Decision log from human answers and confirmations
- Open questions list with blocking labels
- Revision log with overwrite history

Then hand off to downstream skills (`translating-shape-to-spec`, `slicing-work`, or lifecycle controller).

## Completion Checklist

Do not complete this skill until all are true:

1. Workflow scope is explicit.
2. The artifact's substantive content comes from human answers or explicit confirmations.
3. Interview questions resolved key ambiguities.
4. Places, UI, Code, and Stores are modeled where relevant.
5. Integrity checks pass.
6. Human approval is explicitly captured.
7. Open questions are visible and labeled blocking/non-blocking.
8. Revision log records all overwrites.

## Deliverable Template

Use this structure for the final artifact:

```markdown
---
breadboarding: true
conversational: true
human_authored: true
---

# [Topic] - Conversational Breadboard Interview

## Breadboard Scope
- Workflow: [human answer]
- Entry point: [human answer]
- Expected outcome: [human answer]
- Boundaries: [human answer]

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
- [human answer or direct confirmation]

## Open Questions
| Question | Blocking? | Owner |
|----------|-----------|-------|

## Approval Record
- Reviewer: [metadata]
- Result: Approved / Revisions requested
- Human approval or requested revision: [human answer]
- Notes: [approval metadata]

## Revision Log
| Rev | Trigger | Location | Change |
|-----|---------|----------|--------|
| 1 | Qn | Section or cell path | Overwrote prior content with newer human answer |
```

## Notes On Related Skills

- Use `breadboarding` for non-conversational affordance mapping.
- Use `conversational-breadboarding` when you need an explicit human-in-the-loop gate.
- Use `locating-code`, `researching-codebases`, and `finding-code-patterns` for codebase questions that arise during the interview.
- Use `locating-docs` and `analyzing-docs` for prior project docs and decisions.
- Use `web-research` for external or current questions that depend on the web.
- Use `translating-shape-to-spec` and `slicing-work` after approval.
