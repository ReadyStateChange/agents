---
name: conversational-shaping
description: "Runs interviewer-only shaping that captures human answers inside scaffolded shaping docs, updates them incrementally, and records revisions until teach-back passes."
---

# Conversational Shaping

Guides a shaping conversation where the human supplies the substantive content and the agent improves answer quality through focused questions.

## Outcome

Produce the same core shaping outcome as the `shaping` skill:
- A bounded problem with explicit appetite
- Requirements (R)
- Competing shapes (S) and a fit check
- A selected shape with clear parts/mechanisms
- Risks/rabbit holes addressed and out-of-bounds declared

And add these mandatory properties:
- The shaping artifact is scaffolded by the agent but substantively written from human answers
- Later answers overwrite earlier cells/sections in place
- A revision log records every overwrite
- The human can describe the shaped work back in their own words

This skill stops before breadboarding and slicing.

<HARD-GATE>
Do not call `/breadboarding` and do not produce breadboard artifacts in this skill.
</HARD-GATE>

<HARD-GATE>
Shaping is not complete until teach-back passes (see "Teach-Back Gate").
</HARD-GATE>

<HARD-GATE>
Do not write substantive shaping content on the human's behalf. You may only add structure, stable IDs, mechanically derived markers from explicit human answers, and revision metadata.
</HARD-GATE>

## When To Use

Use when:
- The user wants shaping to happen through an interview-style conversation
- The user wants to think through ambiguity with guided questions
- The team needs the human to own and explain the final shape

Do not use when:
- The user already has a shaped solution and only needs implementation planning
- The user wants breadboarding now (use `/breadboarding` separately)

## Role Boundary

- You are an interviewer and artifact organizer, not an implementer.
- Never say you will build, implement, prototype, or execute the shaped work.
- During the active interview, every user-facing turn ends with one focused question.
- If tools or code context are unavailable, ask the best next shaping question anyway.
- If the human asks an information question, answer it directly with evidence before resuming the interview.

## Core Principles

1. Interviewer-only: The agent improves the artifact by questioning, not by authoring solutions.
2. Human-authored substance: Requirements, shape descriptions, risks, and boundaries come from human answers.
3. One question at a time: Ask a single focused question per turn.
4. Fixed time, variable scope: Set appetite first, then shape inside it.
5. Right abstraction: Be rough, solved, and bounded (not wireframes, not vague slogans).
6. De-risk before commitment: Patch rabbit holes and fence out non-core work.
7. Verify understanding: Require teach-back before declaring completion.

## Human-Authored Artifact Contract

1. The agent owns headings, tables, IDs, section ordering, and revision-log metadata.
2. All substantive text inside `Boundaries`, `Requirements`, `Shapes`, `Risks`, `Out Of Bounds`, and `Teach-Back` must come from human answers.
3. You may split one human answer across multiple rows or cells when that is a mechanical placement decision.
4. You may derive status labels, selected-shape markers, and fit-check `✅` / `❌` cells only when the human answer makes the mapping explicit enough to be mechanical. Otherwise, ask a follow-up question.
5. Do not paraphrase, normalize, or "clean up" a weak answer into new shaping prose. Ask a better question instead.
6. When a later answer changes prior content, overwrite the affected section or cells in place and append a revision-log entry describing the overwrite.
7. Revision-log entries may contain neutral metadata such as question number, affected location, and "overwrote prior content with newer human answer." They must not add new shaping content.
8. Research answers, codebase explanations, and document summaries do not become artifact content until the human confirms or restates them.

## Brownfield Questioning

When code, docs, or existing artifacts are visible:
- Ask confirmation questions that cite specific files, tables, or patterns you found.
- Prefer "I found X in `path`. Should this shaping assume Y?" over open-ended discovery questions.
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
4. Ask whether the answer should change the shaping artifact.
5. Only update the artifact after the human confirms the change or provides new wording.
6. If the artifact changes, overwrite the affected cells or sections in place and append a revision-log entry.
7. Resume with the next highest-value shaping question.

## Required Conversation Behavior

1. Ask one question per message.
2. End each active-interview turn with a focused question.
3. Prefer multiple-choice prompts when useful, with an "Other" option.
4. After each answer, update the draft artifact immediately and briefly restate what changed before the next question.
5. Keep ownership with the human: do not auto-decide unresolved trade-offs.
6. When showing requirements or shapes, show full affected tables (no partial summaries).
7. Mark added or changed table cells with 🟡 when re-rendering updated tables.
8. If the current answer is vague, contradictory, or too broad, ask a follow-up question instead of filling the gap yourself.
9. When content changes later, overwrite the old content in place and append a revision-log entry.
10. When answering a human question, answer first, then ask whether the artifact should change.

## Workflow

Create tasks for each step and complete in order.

1. Open the artifact and set boundaries (Shape Up chapter 3)
2. Rough out requirements and candidate shapes at the right abstraction (Shape Up chapters 2 and 4)
3. Stress-test risks and rabbit holes (Shape Up chapter 5)
4. Select the shape and document boundaries
5. Run teach-back gate

### 1) Open The Artifact And Set Boundaries

Start from the user's raw idea and establish:
- Appetite (for example: 1-2 weeks or 6 weeks)
- Baseline (current behavior without this change)
- Narrow problem/use case (specific moment where workflow breaks)

Watch for grab-bag framing (e.g., "X 2.0", "redesign all of Y"). If present, ask questions to narrow to one concrete problem.

Minimum output after this step:

```markdown
## Boundaries

- Appetite: [human answer]
- Baseline: [human answer]
- Problem: [human answer]
- Not this: [human answer]

## Revision Log
| Rev | Trigger | Location | Change |
|-----|---------|----------|--------|
```

### 2) Rough Out Requirements And Candidate Shapes

Define requirements and candidate shapes without over-specifying UI details.

- Use shaping notation from `shaping`: R0/R1..., A/B/C..., parts like B1/B2...
- Keep requirements standalone and solution-independent
- Keep top-level requirements to 9 or fewer (chunk if needed)
- Ensure shape parts are mechanisms (how), not restatements of requirements (what)
- Keep shape headings as `A`, `B`, `C` until you can lift a short title directly from the human's own wording

Maintain a fit check matrix while iterating.

```markdown
## Fit Check

| Req | Requirement | Status | A | B | C |
|-----|-------------|--------|---|---|---|
| R0 | ... | Core goal | ✅ | ❌ | ✅ |
```

Use only `✅` / `❌` in fit check cells. These cells must be mechanically derived from explicit human answers or direct confirmation responses. Put explanations in notes sourced from human answers.

### 3) Stress-Test Risks And Rabbit Holes

Slow down and walk the selected direction through the use case.

Ask explicitly:
- Where could this blow the appetite?
- What assumptions are unproven?
- Which edge cases are likely to trap the team?

Then do one of:
- Patch the hole with a concrete simplification
- Cut scope
- Mark it out-of-bounds
- Flag as a separate spike if unresolved

Capture output:

```markdown
## Risks And Rabbit Holes

| Risk | Why it matters | Patch / Decision |
|------|----------------|------------------|
| ... | [human answer] | [human answer] |

## Out Of Bounds

- [human answer]
```

### 4) Select And Freeze The Shape

A shape can be selected when:
- It passes required fit checks
- Appetite and boundaries are still intact
- Rabbit holes are patched, fenced, or explicitly deferred

If no shape qualifies, return to boundaries or requirements and continue questioning.

### 5) Teach-Back Gate (Mandatory)

Ask the human to explain the shaped work back in their own words, without copy-pasting your summary. Record the human's teach-back directly in the artifact.

Prompt template:

```markdown
Please describe the shaped work back to me in your own words:
1. Problem and baseline
2. Appetite
3. Selected shape and its key parts
4. Top risks/rabbit holes and how we patched them
5. What is explicitly out of bounds
6. What success looks like at delivery
```

Pass criteria:
- The human accurately covers all six items
- No major contradiction with the shaping doc
- Any minor drift is corrected and re-confirmed

If teach-back fails, ask targeted follow-up questions and iterate until it passes.

## Completion Checklist

Do not complete the skill until all are true:

1. Boundaries are explicit (appetite, baseline, narrow problem).
2. The artifact's substantive content comes from human answers.
3. Requirements and candidate shapes are documented.
4. Fit check has been used to compare options.
5. Selected shape is clear and bounded.
6. Risks/rabbit holes are patched or fenced.
7. Out-of-bounds is explicit.
8. Teach-back gate has passed.
9. Revision log records all overwrites.

## Deliverable Template

Use this structure for the final artifact:

```markdown
---
shaping: true
conversational: true
human_authored: true
---

# [Topic] - Conversational Shaping Interview

## Boundaries
- Appetite: [human answer]
- Baseline: [human answer]
- Problem: [human answer]
- Not this: [human answer]

## Requirements (R)
| ID | Requirement | Status |
|----|-------------|--------|

## Shapes (S)
## A
| Part | Mechanism | Flag |
|------|-----------|------|

## Fit Check
| Req | Requirement | Status | A | B | C |
|-----|-------------|--------|---|---|---|

## Selected Shape
- Choice: [human answer]

## Risks And Rabbit Holes
| Risk | Why it matters | Patch / Decision |
|------|----------------|------------------|

## Out Of Bounds
- [human answer]

## Teach-Back Record
- Date: [metadata]
- Result: Pass / Retry
- Human teach-back: [human answer]
- Notes: [gate metadata]

## Revision Log
| Rev | Trigger | Location | Change |
|-----|---------|----------|--------|
| 1 | Qn | Section or cell path | Overwrote prior content with newer human answer |
```

## Notes On Related Skills

- Use `shaping` when you need the full shaping methodology directly.
- Use `conversational-shaping` when you specifically want the human to drive through Q&A.
- Use `locating-code`, `researching-codebases`, and `finding-code-patterns` for codebase questions that arise during the interview.
- Use `locating-docs` and `analyzing-docs` for prior project docs and decisions.
- Use `web-research` for external or current questions that depend on the web.
- After completion, use `/breadboarding` separately if you want affordance-level mapping.
