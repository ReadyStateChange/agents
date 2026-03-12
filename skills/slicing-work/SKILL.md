---
name: slicing-work
description: "Breaks a shaped solution into vertical, demoable increments with clear sequence and dependencies. Use when preparing implementation to proceed slice-by-slice instead of all at once."
argument-hint: "Provide selected shape, breadboard outputs, and draft functional spec."
---

# Slicing Work

Cut work into vertical slices that preserve product behavior and verification intent.

## Use This Skill When

- Shaping and breadboarding are complete
- You need implementation increments with visible demos
- Delivery must proceed in thin end-to-end slices

## Inputs

- Selected shape and fit context
- Breadboard affordances and wiring
- Draft functional spec

## Outputs

- Slices document with sequence
- Slice boundaries and dependencies
- Per-slice demo target and acceptance hook

## Slicing Workflow

1. List all promised behaviors and group them by user-visible flow
2. Propose minimum vertical path that demonstrates value for each flow
3. Cut slices so each one includes behavior, data path, and observable output
4. Sequence slices by dependency and risk
5. Verify each slice can be implemented and QA-verified independently

## Per-Slice Definition

Each slice entry should include:

1. Slice objective
2. Included promised behaviors
3. Demo scenario
4. Acceptance criteria subset
5. Dependencies and out-of-scope edges

## Guardrails

- Do not create infra-only slices with no demoable behavior
- Do not hide critical verification obligations in later slices
- Do not redefine shaped intent while slicing
- Do not cut boundaries that force broad structural rework in later slices

## Readiness Checks

- Every slice is vertical and demoable
- Slice order is explicit and justified
- Acceptance hooks exist per slice
- Critical risk behavior appears in an early slice
