---
name: verifying-feature-quality
description: "Plans and executes feature-level QA verification tied to spec promises and acceptance criteria. Use when validating slices or full features before acceptance."
argument-hint: "Provide functional spec, acceptance criteria, proof obligations, and current implementation evidence."
---

# Verifying Feature Quality

Prove feature-level correctness before acceptance.

## Use This Skill When

- A slice is implemented and needs QA evidence
- A full feature is ready for final acceptance recommendation
- You need coverage aligned to promised behavior

## Inputs

- Functional spec and acceptance criteria
- Proof obligations and breadboard verification seams
- Implementation artifacts and contract test evidence

## Outputs

- QA plan
- Coverage matrix (promised behavior -> verification evidence)
- QA results with defects and risk notes
- Acceptance recommendation

## QA Workflow

1. Build coverage matrix from promised behaviors and acceptance criteria
2. Prioritize critical workflows, errors, permissions, and integrations
3. Execute verification and capture evidence
4. Classify defects by impact and traceability
5. Issue acceptance recommendation with explicit unresolved gaps

## Must Verify

- Critical user workflows
- Error and recovery behavior
- Permission boundaries
- Integration behavior and failure handling
- Accessibility and device/browser expectations where relevant
- Regression risk in critical behavior

## Guardrails

- Do not invent acceptance criteria late
- Do not treat architecture conformance as the primary QA objective
- Do not mark acceptance when required evidence is missing

## Readiness Checks

- Every critical promised behavior has evidence or an explicit gap
- Acceptance recommendation traces to the functional spec
- Unresolved defects are visible and severity-scoped
- Coverage matrix reflects proof obligations
