---
name: conversational-shaping
description: "Facilitates a human-driven shaping conversation using Shape Up chapters 2-5 and shaping notation. Use when the human should drive the shaping and the agent should ask focused questions, one at a time, until teach-back is successful."
---

# Conversational Shaping

Guides a shaping conversation where the human leads decisions and the agent advances the work by asking focused questions.

## Outcome

Produce the same core shaping outcome as the `shaping` skill:
- A bounded problem with explicit appetite
- Requirements (R)
- Competing shapes (S) and a fit check
- A selected shape with clear parts/mechanisms
- Risks/rabbit holes addressed and out-of-bounds declared

And add one mandatory gate:
- The human can describe the shaped work back in their own words

This skill stops before breadboarding and slicing.

<HARD-GATE>
Do not call `/breadboarding` and do not produce breadboard artifacts in this skill.
</HARD-GATE>

<HARD-GATE>
Shaping is not complete until teach-back passes (see "Teach-Back Gate").
</HARD-GATE>

## When To Use

Use when:
- The user wants shaping to happen through an interview-style conversation
- The user wants to think through ambiguity with guided questions
- The team needs the human to own and explain the final shape

Do not use when:
- The user already has a shaped solution and only needs implementation planning
- The user wants breadboarding now (use `/breadboarding` separately)

## Core Principles

1. Human-led: The human makes decisions; the agent facilitates.
2. One question at a time: Ask a single focused question per turn.
3. Fixed time, variable scope: Set appetite first, then shape inside it.
4. Right abstraction: Be rough, solved, and bounded (not wireframes, not vague slogans).
5. De-risk before commitment: Patch rabbit holes and fence out non-core work.
6. Verify understanding: Require teach-back before declaring completion.

## Required Conversation Behavior

1. Ask one question per message.
2. Prefer multiple-choice prompts when useful, with an "Other" option.
3. After each answer, briefly restate what changed before the next question.
4. Keep ownership with the human: do not auto-decide unresolved trade-offs.
5. When showing requirements or shapes, show full tables (no partial summaries).
6. Mark added/changed table cells with 🟡 when re-rendering updated tables.

## Workflow

Create tasks for each step and complete in order.

1. Set boundaries (Shape Up chapter 3)
2. Rough out elements at the right abstraction (Shape Up chapters 2 and 4)
3. Stress-test for risks and rabbit holes (Shape Up chapter 5)
4. Select shape and document boundaries
5. Run teach-back gate

### 1) Set Boundaries

Start from the user's raw idea and establish:
- Appetite (for example: 1-2 weeks or 6 weeks)
- Baseline (current behavior without this change)
- Narrow problem/use case (specific moment where workflow breaks)

Watch for grab-bag framing (e.g., "X 2.0", "redesign all of Y"). If present, ask questions to narrow to one concrete problem.

Minimum output after this step:

```markdown
## Boundaries

- Appetite: ...
- Baseline: ...
- Problem: ...
- Not this: ...
```

### 2) Rough Out Elements

Define requirements and candidate shapes without over-specifying UI details.

- Use shaping notation from `shaping`: R0/R1..., A/B/C..., parts like B1/B2...
- Keep requirements standalone and solution-independent
- Keep top-level requirements to 9 or fewer (chunk if needed)
- Ensure shape parts are mechanisms (how), not restatements of requirements (what)

Maintain a fit check matrix while iterating.

```markdown
## Fit Check

| Req | Requirement | Status | A | B | C |
|-----|-------------|--------|---|---|---|
| R0 | ... | Core goal | ✅ | ❌ | ✅ |
```

Use only ✅/❌ in fit check cells; put explanations in notes.

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
| ... | ... | ... |

## Out Of Bounds

- ...
```

### 4) Select And Freeze The Shape

A shape can be selected when:
- It passes required fit checks
- Appetite and boundaries are still intact
- Rabbit holes are patched, fenced, or explicitly deferred

If no shape qualifies, return to boundaries or requirements and continue questioning.

### 5) Teach-Back Gate (Mandatory)

Ask the human to explain the shaped work back in their own words, without copy-pasting your summary.

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
2. Requirements and candidate shapes are documented.
3. Fit check has been used to compare options.
4. Selected shape is clear and bounded.
5. Risks/rabbit holes are patched or fenced.
6. Out-of-bounds is explicit.
7. Teach-back gate has passed.

## Deliverable Template

Use this structure for the final artifact:

```markdown
---
shaping: true
---

# [Topic] — Human-Led Shaping

## Boundaries
- Appetite: ...
- Baseline: ...
- Problem: ...

## Requirements (R)
| ID | Requirement | Status |
|----|-------------|--------|

## Shapes (S)
## A: ...
| Part | Mechanism | Flag |
|------|-----------|------|

## Fit Check
| Req | Requirement | Status | A | B | C |
|-----|-------------|--------|---|---|---|

## Selected Shape
- ...

## Risks And Rabbit Holes
| Risk | Why it matters | Patch / Decision |
|------|----------------|------------------|

## Out Of Bounds
- ...

## Teach-Back Record
- Date:
- Result: Pass/Retry
- Notes:
```

## Notes On Related Skills

- Use `shaping` when you need the full shaping methodology directly.
- Use `conversational-shaping` when you specifically want the human to drive through Q&A.
- After completion, use `/breadboarding` separately if you want affordance-level mapping.
