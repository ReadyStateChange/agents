---
name: reflecting-breadboards
description: "Reflects on breadboards by syncing them to implementation and fixing design-smell mismatches. Use when validating or refining a breadboard against real code behavior."
allowed-tools:
  - Read
  - Grep
  - glob
---

# Reflecting Breadboards

Improve breadboard quality in two passes: sync to code, then refine design.

## Two-Phase Method

1. `See` phase: make the breadboard match implementation reality.
2. `Reflect` phase: detect and fix affordance boundaries, naming, and wiring smells.

Always complete `See` before `Reflect`.

## See Phase Checklist

1. Read relevant implementation files first.
2. Verify module boundaries and public affordances.
3. Capture module-level constants/config that shape behavior as data stores.
4. Trace full call chains and intermediate transformations.
5. Update breadboard tables/diagram so every behavior is explainable.

## Reflect Phase Checklist

1. Trace one or more user stories through the wiring.
2. Run naming test on each affordance:
   - Who calls it?
   - What step-level effect does it perform?
   - Can it be named with one idiomatic verb?
3. Split affordances that require multiple verbs (`do X or Y`).
4. Fix missing or incorrect wires and store relationships.
5. Re-check that tables and diagram are consistent.

## Smell Signals

- behavior that cannot be explained by visible wires
- affordances that resist clear one-verb naming
- diagram-only nodes with no table entry
- stale or incorrect causality versus real code paths

## Guardrails

- Use implementation as ground truth.
- Update tables before diagram cosmetics.
- Do not invent affordances that have no code counterpart.
