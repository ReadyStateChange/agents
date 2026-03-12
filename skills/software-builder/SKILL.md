---
name: software-builder
description: "Orchestrates end-to-end software delivery from rough idea through shaping, spec, technical design, slice-by-slice implementation, QA verification, and artifact consistency. Use when you want one controller to drive both usefulness proof and correctness proof."
argument-hint: "Provide the rough idea, target users, constraints, and known context."
---

# Software Builder

Run the full quality lifecycle from rough idea to accepted slices while preserving two linked proofs: usefulness and correctness.

## Use This Skill When

- You have a rough feature or product idea and need to turn it into executable slices
- You want stage-gated handoffs instead of ad-hoc implementation
- You want implementation delegated through `subagent-driven-development`
- You want QA verification before acceptance of each slice and the full feature

## Do Not Use This Skill When

- The request is only a small code edit in an existing, already-shaped plan
- The functional spec and technical design already exist and only execution is needed
- The user explicitly asks for a different lifecycle

## Lifecycle Controller

Run stages in this order unless a later stage exposes a defect in earlier truth.

1. Frame the problem with `framing-problems`
2. Shape requirements and fit using `conversational-shaping` by default (`shaping` only when the user explicitly prefers non-conversational shaping)
3. Breadboard selected shape with `breadboarding`
4. Translate shape into draft spec with `translating-shape-to-spec`
5. Define vertical, demoable increments with `slicing-work`
6. Finalize functional behavior contract with `writing-functional-specs` after a `brainstorming` conversation with the human
7. Design component boundaries and layer placement with `designing-clean-architecture` after a `brainstorming` conversation with the human
8. Implement one slice at a time with `subagent-driven-development` (which enforces `specification-driven-tdd`)
9. Verify each slice and final feature with `verifying-feature-quality`
10. Keep artifacts aligned with `maintaining-artifact-consistency`

## Framing Conversation Gate

Stage 1 is a human-in-the-loop conversation, not a one-shot document pass.

1. Ask framing questions one at a time until problem and desired outcome are concrete
2. Summarize the draft framing in plain language
3. Require the human to state the problem and desired outcome back in their own words
4. Compare the teach-back statement with the draft framing and resolve mismatches
5. Only proceed to Stage 2 when the teach-back is explicit and aligned

This gate is hard: no shaping before explicit human teach-back.

## Spec And Technical Design Conversation Gates

Before finalizing Stage 6 and Stage 7 artifacts, run conversational back-and-forth using `brainstorming`.

1. Use `brainstorming` to explore ambiguities, trade-offs, and edge cases with the human
2. Present the proposed functional spec or technical spec sections
3. Get explicit human approval of the proposed sections
4. Only then finalize the corresponding artifact

Default behavior: Stage 6 and Stage 7 use `brainstorming` unless the user explicitly opts out.

## Slice-First Delivery Loop

After Stage 7, execute this loop until all slices are accepted:

1. Select the next unblocked slice
2. Confirm the slice has explicit promised behavior and acceptance criteria
3. Delegate implementation for only that slice via `subagent-driven-development`
4. Run QA for that slice via `verifying-feature-quality`
5. If QA passes, mark slice accepted and continue
6. If QA fails, send rework to the highest artifact that must change, then rerun downstream stages
7. Run `maintaining-artifact-consistency` whenever truth changes

Do not batch all slices into one implementation wave.

## Stage Gate Checks

Before each handoff, verify:

- Inputs for the next stage exist
- Outputs from the current stage are explicit and reviewable
- No major cross-artifact conflict is unresolved
- Open questions are visible, not buried
- For Stage 1 -> Stage 2, human teach-back of both problem and desired outcome is captured and aligned
- For Stage 5 -> Stage 6, brainstorming-based human review of functional spec sections is complete
- For Stage 6 -> Stage 7 and Stage 7 -> Stage 8, brainstorming-based human review of technical design sections is complete

Stop forward progress when artifacts disagree.

## Non-Negotiable Rules

- Do not call work high quality without both proofs
- Do not proceed from framing to shaping without human teach-back of problem and desired outcome
- Do not finalize functional spec or technical design without brainstorming-based human back-and-forth and approval
- Do not let requirements disappear between shaping and spec
- Do not allow implementation to invent behavior outside the functional spec
- Do not accept slices without QA evidence tied to acceptance criteria
- Do not allow artifact drift; apply ripple updates both upward and downward

## Integration Map

Use these existing skills as the default delegates:

- `conversational-shaping` (default)
- `shaping` (fallback when a non-conversational shaping mode is explicitly requested)
- `brainstorming` (default for Stage 6 and Stage 7 collaborative review)
- `breadboarding`
- `designing-clean-architecture`
- `subagent-driven-development`
- `specification-driven-tdd`
- `verification-before-completion`

Use these companion skills for missing playbooks:

- `framing-problems`
- `translating-shape-to-spec`
- `slicing-work`
- `writing-functional-specs`
- `verifying-feature-quality`
- `maintaining-artifact-consistency`
