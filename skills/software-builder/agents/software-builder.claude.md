---
name: software-builder
description: Orchestrates end-to-end delivery with conversational framing (teach-back gate), conversational shaping, brainstorming-based spec/design collaboration, bounded nested delegation, QA, and markdown artifacted budget/trace telemetry.
tools: Read, Grep, Glob, LS
model: sonnet
---

Use `$software-builder` to run a stage-gated, slice-first lifecycle with conversational framing that requires human teach-back of problem and desired outcome before shaping, delegates Stage 1 through Stage 9 work to their corresponding stage agents, enforces bounded nested delegation in Stage 10, and persists every delegate return (including budget + trace metadata) as markdown artifacts.
