---
name: translating-shape-to-spec
description: "Converts a selected shape and breadboard into explicit promised behavior with traceability. Use when bridging shaping outputs into a draft functional specification."
argument-hint: "Provide requirements, selected shape, fit check, proof obligations, and breadboard outputs."
---

# Translating Shape To Spec

Bridge shaping intent to contract-ready behavior without losing critical commitments.

## Use This Skill When

- A shape has been selected and breadboarded
- You need a draft functional spec before final spec refinement
- You want requirement-to-spec traceability and visible translation decisions

## Inputs

- Requirements and selected shape
- Fit check and proof obligations
- Breadboard affordances, wiring, and verification seams
- Draft acceptance criteria from shaping

## Outputs

- Draft functional spec entries stated as observable behavior
- Requirement-to-spec traceability notes
- Translation decisions with rationale
- Open questions that block finalization
- Subagent return metadata (`Budget snapshot` and `Trace metadata`) when invoked by an orchestrator that requires telemetry artifacts

## Delegated Return Metadata

When this skill is delegated by `software-builder`, include:

- `Budget snapshot` (`input_tokens`, `output_tokens`, `total_tokens`, `requests`, `tool_calls`, or `unknown` with reason)
- `Trace metadata` (`run_id`, `parent_run_id`, `stage_id`, `delegate_name`, `depth`, `correlation_id`, `started_at`, `ended_at`, `duration_ms`)

## Translation Workflow

1. Walk each requirement and write the observable behavior that would prove it satisfied
2. Walk each breadboard affordance and connection to surface implied behavior, failure behavior, and permission boundaries
3. Walk each proof obligation and confirm at least one spec entry can satisfy it
4. Mark ambiguity resolutions as explicit decisions
5. Mark unresolved items as open questions; do not silently guess

## Failure Patterns To Catch

- Silent omission of shaped requirements
- Implicit behavior left unstated in the draft spec
- Mechanism language replacing behavioral commitments
- Narrowing without recording a decision
- Premature concreteness that belongs to implementation or UI detail

## Readiness Checks

- Every requirement maps to at least one behavioral commitment
- Important error behavior is explicit
- Permission and integration behavior is explicit
- Non-goals are visible
- Traceability notes exist
- Decisions and open questions are visible

## Guardrails

- Do not invent new requirements
- Do not finalize acceptance criteria at this stage
- Do not define technical architecture here
