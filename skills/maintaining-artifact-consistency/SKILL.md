---
name: maintaining-artifact-consistency
description: "Keeps frame, shaping, spec, design, implementation, and QA artifacts aligned when truth changes. Use when updates in one artifact must ripple safely across the chain."
argument-hint: "Provide the changed artifact, impacted stages, and current versions of related documents."
---

# Maintaining Artifact Consistency

Prevent drift by applying ripple updates across the artifact chain.

## Use This Skill When

- Any stage changes truth that other artifacts depend on
- QA or implementation reveals a mismatch with prior documents
- You need to resolve conflicts between shaping, spec, design, and verification artifacts

## Inputs

- Current versions of active artifacts
- The triggering change and rationale
- Known disagreements or unresolved gaps

## Outputs

- Consistency report
- Ripple update plan (upward and downward)
- Updated artifact set or explicit blocked items

## Workflow

1. Identify the highest artifact whose truth changed
2. Stop forward flow while conflicts remain
3. Apply updates downstream to dependent artifacts
4. Apply updates upstream when lower-level findings change scope or intent
5. Recheck traceability links and acceptance alignment

## Ripple Rule

Changes must ripple both directions when needed:

- Upward: implementation or QA discoveries that alter scope, risk, or behavior
- Downward: framing, shaping, or spec decisions that alter design or execution

Do not patch lower artifacts while leaving the true source of disagreement unresolved.

## Readiness Checks

- No active artifact contradicts a higher-level truth
- Requirement-to-spec and spec-to-QA links remain intact
- Open questions and known deviations are visible
- The artifact chain can be read as one coherent system of truth
