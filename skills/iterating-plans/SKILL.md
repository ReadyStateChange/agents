---
name: iterating-plans
description: "Iterates on existing specification-first implementation plans with research and surgical updates. Use when you say: 'update the plan', 'revise this plan', 'adjust the phases', 'incorporate feedback into the plan', 'update success criteria'."
---

# Iterating Plans

Update existing implementation plans based on user feedback with surgical precision. Preserve the specification as the source of truth; do not let the plan drift away from the contract.

## Getting Started

1. **If plan path AND feedback provided**: proceed immediately
2. **If only plan path provided**: read it and ask what changes to make
3. **If nothing provided**: ask for the plan path
4. Read any linked specification documents before deciding how to update the plan

## Workflow

### Step 1: Read and Understand

1. Read the existing plan file completely
2. Read the linked specification sections completely
3. Check the plan against the canonical outline and note any missing or drifted sections
4. Understand the current structure, phases, scope, and contract boundaries
5. Parse what the user wants to add/modify/remove
6. Classify the request:
   - Contract-preserving plan change
   - Contract-changing plan change
   - Pure sequencing/scope adjustment
7. Determine if changes require codebase research

### Step 2: Research If Needed

**Only research if changes require new technical understanding.** For simple adjustments, skip this step.

If research is needed:

1. Use `finder`, `Grep`, and `Read` to investigate the codebase
2. Check existing research or decision documents for historical context

### Step 3: Confirm Understanding

Before making changes:

```
Based on your feedback, I understand you want to:
- [Change 1]
- [Change 2]

Contract impact:
- [Preserves existing specification / requires specification delta in `[path/to/spec]`]

My research found:
- [Relevant constraint or pattern]

I plan to update the specification/plan by:
1. [Specific modification]
2. [Another modification]

Does this align with your intent?
```

### Step 4: Update the Plan

1. If the requested behavior changes the contract, update the specification reference or delta first
2. Make focused, precise edits with edit_file — not wholesale rewrites
3. Maintain the canonical structure and heading order unless the user explicitly asks for a different outline
4. Keep all file:line references accurate
5. Preserve or restore the required top-level sections:
   - `Review Outcome`
   - `Global Contract Rules`
   - `Overview`
   - `Current State Analysis`
   - `Desired End State`
   - `End-State Verification`
   - `Locked Decisions`
   - `What We Are Not Doing`
   - `Version Control Workflow (Jujutsu)`
   - `Parallel Execution Strategy`
   - `Cross-Phase Test Strategy`
   - `Migration Notes`
   - `References`
6. If adding or changing a phase, keep it self-contained and preserve the phase anatomy:
   - `Goal`
   - `Phase Execution Rules`
   - `Specifications`, `Workflow Specification`, or `Workflow Specifications` as appropriate
   - `Step Specifications` when the phase has step-level contracts
   - `Contract Coverage Checklist`
   - `Specification-Driven TDD Workflow`
   - `Files`
   - `Phase Gate`
7. If modifying scope, update `What We Are Not Doing`
8. Keep contract numbering and checklist numbering aligned within each phase
9. If a contract introduces a new type, ensure the specification includes a type definition that makes illegal states unrepresentable and prefers branded/opaque domain types over primitive aliases
10. Maintain the automated vs manual success criteria distinction inside each `Phase Gate`
11. If the updated plan would implement behavior without a specification, stop and create/refine the spec before finalizing the plan
12. If the updated plan adds contract tests, ensure it preserves both:
   - Full coverage of all specified outputs, errors, mutations, and side effects
   - One-test-at-a-time execution during implementation rather than batching RED tests
13. If a phase depends on prior work, make the prerequisite explicit inside that phase instead of assuming the reader will infer it from earlier sections
14. If sequencing changes, update the top-level chunk dependency map and every affected `Phase Execution Rules` section so blocked-by, unblocks, and parallelizable relationships stay accurate
15. If the revised plan can safely create or preserve more independent chunks, prefer that structure over serial sequencing
16. If the revised plan creates independent chunks, say so explicitly and note when `using-jj-workspaces` should be used to execute them in parallel

### Step 5: Commit and Present Changes

1. Run via Bash: `jj new` before editing so the plan changes are made in a clean working copy
2. Make the requested plan changes
3. Run via Bash: `jj describe -m "plan: [summary of changes made]"` to describe what changed in the plan
4. Only create a bookmark/branch if explicitly asked to
5. Present the changes:

```
I've updated the plan at `[plan-path]`

Changes made:
- [Specific change 1]
- [Specific change 2]

Would you like any further adjustments?
```

## Guidelines

- **Be skeptical**: Don't blindly accept changes that conflict with existing phases — point out issues
- **Be surgical**: Precise edits, preserve good content, only research what's necessary
- **Be interactive**: Confirm understanding before editing, allow course corrections
- **No silent contract drift**: Every behavior change must correspond to a specification change or an explicit statement that the contract is unchanged
- **Preserve the canonical outline**: Do not casually rename, reorder, or collapse the major sections or phase anatomy
- **No open questions**: If a change raises questions, ask immediately — don't update with unresolved items
- **Keep phases spec-linked**: Each affected phase must still point to the governing specification and contract tests
- **Keep dependency maps honest**: When sequencing changes, update the chunk dependency map and the per-phase blocked/unblocked notes in the same edit
- **Prefer preserving or increasing parallelism**: When revising sequencing, default to the plan shape that leaves the most chunks safely executable in parallel
- **Preserve contract-test shape**: Plans should enumerate coverage for the full contract, but still instruct implementation to proceed one failing contract test at a time
- **Preserve self-contained phases**: After edits, an agent given one phase in isolation should still have enough context to execute it correctly
- **Preserve parallelism signals**: Keep explicit notes about what can run concurrently and when `using-jj-workspaces` should be used
- **Preserve numbering symmetry**: If a contract is added, removed, or renumbered, update the matching checklist entries and related references in the same edit
- **Preserve type safety in the spec**: If a revised contract introduces a new type, add or update the type definition so illegal states remain unrepresentable and branded/opaque types are used by default
- **Iterate from a fresh change**: Start plan revisions with `jj new`, then use `jj describe` to summarize the plan changes you actually made
- **Success criteria**: Always maintain the two-category structure (automated commands vs manual human testing)
