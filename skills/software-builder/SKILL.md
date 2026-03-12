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
- The functional spec, technical spec, and implementation plan already exist and only execution is needed
- The user explicitly asks for a different lifecycle

## Lifecycle Controller

Run stages in this order unless a later stage exposes a defect in earlier truth.

1. Frame the problem with `framing-problems`
2. Shape requirements and fit using `conversational-shaping` by default (`shaping` only when the user explicitly prefers non-conversational shaping)
3. Breadboard selected shape with `breadboarding`
4. Translate shape into draft spec with `translating-shape-to-spec`
5. Define vertical, demoable increments with `slicing-work`
6. Finalize functional behavior contract with `writing-functional-specs` after a `brainstorming` conversation with the human
7. Finalize technical design with `designing-clean-architecture` and write code-level contracts with `writing-specifications` after a `brainstorming` conversation with the human
8. Draft a slice-by-slice execution plan with `creating-implementations-plans` using the functional spec, technical spec, and slices
9. Refine and lock the plan with `iterating-plans` after human review
10. Implement one slice at a time with `subagent-driven-development` (which enforces `specification-driven-tdd`)
11. Verify each slice and final feature with `verifying-feature-quality`
12. Keep artifacts aligned with `maintaining-artifact-consistency`

## Required Stage Documents

Every stage must produce or refresh a reviewable document artifact. Keep a stage document register that links all current artifact paths.

1. Stage 1 (`framing-problems`): Frame document (problem, outcome, constraints, teach-back record)
2. Stage 2 (`conversational-shaping` or `shaping`): Shaping document (requirements, selected shape, risks, out-of-bounds, teach-back record)
3. Stage 3 (`breadboarding`): Breadboard document (affordance tables and wiring)
4. Stage 4 (`translating-shape-to-spec`): Draft functional spec document
5. Stage 5 (`slicing-work`): Slices document with dependency map
6. Stage 6 (`writing-functional-specs`): Final functional spec document
7. Stage 7 (`designing-clean-architecture` + `writing-specifications`): Technical spec document with architecture decisions and code contracts (signatures, effects, data types)
8. Stage 8 (`creating-implementations-plans`): Draft implementation plan document
9. Stage 9 (`iterating-plans`): Finalized implementation plan document (or explicit revision of Stage 8 document)
10. Stage 10 (`subagent-driven-development`): Implementation execution log per slice (what was built, test loops run, and verification evidence)
11. Stage 11 (`verifying-feature-quality`): QA verification report tied to acceptance criteria
12. Stage 12 (`maintaining-artifact-consistency`): Artifact consistency report documenting ripple updates and final alignment status

If a stage updates an existing artifact instead of creating a new file, record the update in the stage document register with the current path and revision context.

## Stage Version Control Hygiene (Jujutsu)

Every stage is a checkpoint. Stages start clean, end with an explicit JJ stage commit message, then hand off in a fresh working copy.

1. Before starting a stage, run `jj status` and confirm the working copy is clean
2. If the working copy is not clean, do not start the stage; either finish the current stage first or run `jj new` to begin a fresh stage commit
3. Complete the stage and update the stage document register with artifact paths
4. Run `jj describe -m "stage [N]: [stage name] - [artifact/result summary]"`
5. Run `jj new -m "stage [N+1]: start"` before beginning the next stage

Use this checkpoint loop for all Stage 1 through Stage 12 transitions.

## Framing Conversation Gate

Stage 1 is a human-in-the-loop conversation, not a one-shot document pass.

1. Ask framing questions one at a time until problem and desired outcome are concrete
2. Require the human to state the problem and desired outcome back in their own words
3. Compare the teach-back statement with the draft framing and resolve mismatches
4. Repeat teach-back until it is explicit and aligned
5. After teach-back passes, summarize the agreed framing in plain language and proceed to Stage 2

This gate is hard: no pre-teach-back summary and no shaping before explicit human teach-back.

## Teach-Back Ordering Rule

Apply this ordering to every teach-back in this lifecycle (including delegated skills):

1. Request the human's teach-back first
2. Validate and iterate until teach-back passes
3. Only after a pass, provide a confirmation summary of what was agreed

Do not provide answer-revealing summaries before or between teach-back attempts.

## Spec And Technical Design Conversation Gates

Before finalizing Stage 6 and Stage 7 artifacts, run conversational back-and-forth using `brainstorming`.

1. Use `brainstorming` to explore ambiguities, trade-offs, and edge cases with the human
2. Present the proposed functional spec or technical spec sections
3. For Stage 7, invoke `writing-specifications` to draft code contracts in the technical spec, including function/module signatures, effects (outputs, side effects, and errors), and data type definitions/invariants
4. Get explicit human approval of the proposed sections and contract set
5. Only then finalize the corresponding artifact

Default behavior: Stage 6 and Stage 7 use `brainstorming` unless the user explicitly opts out.

## Slice-First Planning And Iteration Gates

Before implementation starts, Stage 8 and Stage 9 must produce a human-reviewed implementation plan from Stage 5, Stage 6, and Stage 7 artifacts.

1. Invoke `creating-implementations-plans` to draft the initial slice-by-slice plan
2. Invoke `brainstorming` to walk through the draft plan with the human and collect refinement feedback
3. Invoke `iterating-plans` to apply refinements surgically to the draft
4. Invoke `brainstorming` again to walk through the revised plan and secure explicit approval
5. Use the slices as the execution backbone
6. Map each slice to functional behavior and technical contracts
7. Order slices by dependency so unblocked slices can be executed first
8. Maximize safe parallelization by identifying slices that can run concurrently once prerequisites are satisfied
9. Define workspace orchestration for parallel chunks, using `using-jj-workspaces` by default unless a shared workspace is explicitly justified
10. Require a dependency and third-party delta inventory in the plan (new packages, package version bumps, test-runtime dependencies like `jsdom`, new external APIs, and new hosted services)
11. Assign each dependency/service delta to the earliest slice that needs it; allow a dedicated enablement slice only when the dependency is shared by multiple later slices
12. Require per-slice verification expectations before Stage 10

No Stage 10 work begins until this plan exists, is refined, and is explicitly approved.

## Slice-First Delivery Loop

After Stage 9, execute this loop until all slices are accepted:

1. Select the next unblocked slice from the finalized implementation plan
2. Confirm the slice has explicit promised behavior and acceptance criteria
3. Confirm the slice's declared dependency/service deltas are explicit and unblocked
4. Run `jj status` and confirm the working copy is clean before implementation starts; if not, stop and restore stage hygiene first
5. Delegate implementation for only that slice via `subagent-driven-development`
6. Run QA for that slice via `verifying-feature-quality`
7. If QA passes, mark slice accepted and continue
8. If QA fails, send rework to the highest artifact that must change, then rerun downstream stages
9. Run `maintaining-artifact-consistency` whenever truth changes

Do not batch all slices into one implementation wave.

## Stage Gate Checks

Before each handoff, verify:

- Inputs for the next stage exist
- Outputs from the current stage are explicit and reviewable
- The current stage has a produced or refreshed document artifact linked in the stage document register
- The stage started from a clean working copy (`jj status`)
- The stage ended with `jj describe` and handed off via `jj new`
- No major cross-artifact conflict is unresolved
- Open questions are visible, not buried
- For Stage 1 -> Stage 2, human teach-back of both problem and desired outcome is captured and aligned
- For Stage 5 -> Stage 6, brainstorming-based human review of functional spec sections is complete
- For Stage 6 -> Stage 7, brainstorming-based human review of technical design sections is complete and `writing-specifications` contracts are present (signatures, effects, data types)
- For Stage 7 -> Stage 8, technical design and code contracts are explicit and approved
- For Stage 8 -> Stage 9, the draft implementation plan exists and has completed a brainstorming walkthrough with captured human feedback
- For Stage 9 -> Stage 10, the iterated plan is explicitly approved through brainstorming and maps each slice to functional and technical contracts, identifies parallelizable slices/chunks, defines a `using-jj-workspaces` strategy for parallel work, and includes a dependency/service delta map with explicit per-slice ownership and verification commands

Stop forward progress when artifacts disagree.

## Non-Negotiable Rules

- Do not call work high quality without both proofs
- Do not proceed from framing to shaping without human teach-back of problem and desired outcome
- Do not summarize expected answers before any teach-back; summarize only after teach-back passes
- Do not complete any stage without a produced or refreshed document artifact for that stage
- Do not start any stage from a dirty working copy; enforce `jj status` cleanliness first
- Do not move to the next stage without a stage checkpoint message (`jj describe`) and a fresh next-stage working copy (`jj new`)
- Do not finalize functional spec or technical design without brainstorming-based human back-and-forth and approval
- Do not finalize Stage 7 without `writing-specifications`-style code contracts (function/module signatures, effects, and data type definitions)
- Do not finalize Stage 8 or Stage 9 without brainstorming-based human walkthrough and explicit approval
- Do not start implementation without an iterated slice-by-slice implementation plan that traces to functional and technical specs
- Do not start implementation when dependency or third-party deltas are implied but not declared in the plan
- Do not add new dependencies or third-party services in a slice unless that slice (or an explicitly justified shared enablement slice) owns the change and its verification
- Do not default to serial execution when independent slices can be run in parallel safely
- Do not execute parallel chunks in one shared working copy by default; use `using-jj-workspaces` unless there is a documented reason not to
- Do not let requirements disappear between shaping and spec
- Do not allow implementation to invent behavior outside the functional spec
- Do not accept slices without QA evidence tied to acceptance criteria
- Do not allow artifact drift; apply ripple updates both upward and downward

## Integration Map

Use these existing skills as the default delegates:

- `conversational-shaping` (default)
- `shaping` (fallback when a non-conversational shaping mode is explicitly requested)
- `brainstorming` (default for Stage 6 through Stage 9 collaborative review)
- `breadboarding`
- `designing-clean-architecture`
- `writing-specifications`
- `creating-implementations-plans`
- `iterating-plans`
- `using-jj-workspaces`
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
