---
name: designing-clean-architecture
description: "Designs and reviews systems using clean architecture placement rules. Use when deciding where logic belongs across domain/application/adapters/infrastructure, or when reviewing code for layering violations and framework leakage."
argument-hint: "Provide the use case, architecture draft, or file paths/diff to evaluate."
---

# Designing Clean Architecture

Place logic by business meaning, not by the framework entry point.

Use this skill to design new systems, review pull requests, and plan refactors so policy and workflow logic move inward while framework details stay at the edge.

## Use This Skill When

- You need to decide where new logic should live
- You are reviewing code for dependency direction violations
- You want to split business rules from controllers, UI components, or ORM models
- You need a clean boundary for repositories or external services

## Core Rule

Put logic in the **innermost layer that can own it without depending on outer details**.

Dependency direction is always inward:

Frameworks / Infrastructure -> Interface / Adapters -> Application / Use Cases -> Domain / Business Rules

## Inputs To Gather First

1. Actor and user action
2. Inputs and expected outputs
3. Business rules and invariants
4. External side effects (DB, payment, email, queue, files)
5. Current entry points (API, UI, job, CLI)

## Design Workflow

1. Define the use case in one sentence (`actor`, `action`, `inputs`, `outputs`, `rules`, `side effects`).
2. Extract business rules and place them in `Domain`.
3. Place orchestration and action-specific authorization policy in `Application`.
4. Define interface boundaries for repositories and external services in `Application`.
5. Keep translation code in `Adapters` (request mapping, DTO/serializer mapping, input shape checks).
6. Keep framework and vendor integration in `Infrastructure`.
7. Validate dependency direction and remove outward imports from inner layers.

## Fast Placement Questions

Ask in order:

1. Does this rule define the business? -> `Domain`
2. Does this coordinate a user action/workflow? -> `Application`
3. Does this translate between internal and external models? -> `Adapter`
4. Does this talk to a framework, SDK, database driver, or runtime tool? -> `Infrastructure`

## Review Workflow

When reviewing existing code or a diff:

1. Map each touched file to one layer.
2. Flag dependency direction breaks (inner importing outer).
3. Flag business logic leakage in controllers/UI/infrastructure.
4. Flag duplicated policy logic (pricing, eligibility, permissions).
5. Propose minimal inward moves that preserve behavior.
6. Return findings ordered by severity, then a concrete refactor sequence.

## Output Format

Return findings using these sections:

1. `Layer Mapping`
2. `Dependency Direction Violations`
3. `Business Logic Placement Issues`
4. `Recommended Moves`
5. `Refactor Order`

Keep findings concrete with file and symbol references.

## Guardrails

- Do not place product policy in controllers, middleware, UI components, or SDK wrappers.
- Do not place framework request/response types in domain or application contracts.
- Do not place workflow orchestration in route handlers.
- Do not place domain rules inside ORM models unless those models are the domain model by explicit design.
- Avoid abstraction theater: only add boundaries that protect real policy/workflow concerns.

## Reference

Use the full placement guide and checklists in [references/clean-architecture-placement-guide.md](references/clean-architecture-placement-guide.md).
