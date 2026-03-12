---
name: writing-functional-specs
description: "Finalizes feature-level functional specifications with explicit promised behavior and acceptance criteria. Use when refining draft spec artifacts into implementation-ready contracts."
argument-hint: "Provide draft functional spec, slices, shaping requirements, and proof obligations."
---

# Writing Functional Specs

Refine draft behavior into a complete, contract-facing functional specification.

## Use This Skill When

- Draft spec exists but is incomplete or ambiguous
- Slice boundaries are known and need contract clarity
- Acceptance criteria must be made explicit before implementation

## Inputs

- Draft functional spec
- Slices document
- Requirements, selected shape, and proof obligations
- Breadboard verification context

## Outputs

- Final functional spec
- Explicit acceptance criteria
- Open questions list (must be resolved before implementation)

## Required Spec Sections

1. User scenarios
2. Business rules
3. Validation rules
4. Error and recovery behavior
5. Roles and permissions
6. Integrations and expected outcomes
7. Non-goals and out-of-scope behavior
8. Acceptance criteria

## Workflow

1. Reconcile draft spec with requirements and shaped commitments
2. Fill all required sections using observable outcomes
3. Confirm each slice has traceable spec coverage
4. Remove mechanism-level wording that belongs to technical design
5. Resolve ambiguity or mark as blocking question

## Guardrails

- Do not add behavior not traceable to shaping outcomes
- Do not include architecture or framework decisions here
- Do not leave acceptance criteria implied

## Readiness Checks

- Spec is implementation-ready without guessing behavior
- Important failures and recoveries are explicit
- Permissions and integrations are explicit
- Acceptance criteria are testable and unambiguous
