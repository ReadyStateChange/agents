---
name: revising-prose
description: "Revises prose for clarity and concision using the Paramedic Method. Use when writing feels wordy, passive, repetitive, or hard to follow and needs tighter, more direct sentences."
allowed-tools:
  - Read
  - Grep
  - glob
argument-hint: "Paste the text to revise and any constraints (tone, audience, must-keep terms, or word-count target)."
---

# Revising Prose

Tighten and clarify writing by applying Richard Lanham's Paramedic Method sentence by sentence.

## Use Cases

Apply this skill when the user asks for things like:

- "Make this less wordy"
- "Tighten this paragraph"
- "Rewrite for clarity"
- "Cut passive voice"
- "Make this direct"
- "Revise this prose"

## Core Method: Paramedic Pass

For each sentence, run these steps in order:

1. Underline prepositions to expose heavy phrasing (`of`, `in`, `for`, `through`, `with`, etc.).
2. Mark "to be" verbs (`is`, `are`, `was`, `were`, `be`, `been`, `being`) and test whether a stronger verb can replace them.
3. Ask "Where is the action?" Convert nominalizations into verbs (`intention` -> `intend`, `elimination` -> `eliminate`).
4. Identify the real subject and move it closer to the main action.
5. Remove slow wind-ups and throat-clearing intros.
6. Delete redundancies and repeated meaning.

If a sentence still feels heavy, run a second pass.

## Workflow

1. Confirm constraints: audience, tone, and must-preserve terminology.
2. Diagnose the draft: wordiness, passive voice, nominalizations, and redundant phrases.
3. Revise line by line using the Paramedic Pass.
4. Check for meaning drift and restore any lost nuance.
5. Return the revision plus a compact change summary.

## Output Modes

### Default: Revised Text + Change Notes

Return:

1. Full revised text
2. `### What Changed` section with concise bullets (no more than 8)

### Teaching Mode (When Asked)

If the user asks to learn the method, include:

1. 3-8 representative before/after sentence pairs
2. The exact Paramedic step(s) applied to each pair
3. A final one-paragraph version that integrates all sentence edits

## Priorities

When trade-offs appear, prioritize in this order:

1. Preserve meaning and factual accuracy
2. Improve clarity and directness
3. Reduce word count
4. Preserve preferred voice/tone

## Guardrails

- Do not change claims, data, names, or citations unless asked.
- Do not over-compress technical writing until it becomes vague.
- Do not force casual tone when the source is formal.
- Prefer concrete verbs over adjective/adverb stacking.
- Keep domain terms that the reader needs.

## Quick Example

Before:

> The author's intention of the article is to argue for the elimination of the passivity of the learner in college through using recent studies that show the value of collaborative learning in the classroom environment.

After:

> The author cites recent research and argues that collaborative learning reduces passivity and increases active classroom learning.

See [references/paramedic-method.md](references/paramedic-method.md) for the method checklist and additional examples.

## Reference

- Richard Lanham, *Revising Prose* (5th ed.)
