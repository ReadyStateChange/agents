# AI Skills

A collection of reusable skills for AI coding agents.

## Canonical Skills

| Skill | Description |
|-------|-------------|
| **analyzing-docs** | Extracts key decisions, constraints, and actionable insights from documents |
| **brainstorming** | Explores user intent, requirements, and design before implementation |
| **breadboarding** | Transforms workflows into UI and Code affordance tables with wiring to map or design systems |
| **creating-handoffs** | Creates concise handoff documents with status, decisions, artifacts, and next actions |
| **conversational-shaping** | Facilitates human-led shaping through one-question-at-a-time dialogue and requires teach-back before completion |
| **creating-implementation-plan** | Creates detailed implementation plans through interactive research and iteration |
| **designing-clean-architecture** | Designs and reviews systems using clean architecture placement rules |
| **describing-pull-requests** | Generates or updates pull request descriptions from diffs, commits, and repository templates |
| **finding-code-patterns** | Finds similar implementations and concrete code examples already in the codebase |
| **finishing-a-development-branch** | Guides completion of development work with structured options for merge, PR, or cleanup |
| **framing-problems** | Defines the problem and desired outcome before solution shaping |
| **humanizing-writing** | Removes AI-writing patterns and rewrites text to sound natural, specific, and human |
| **implementing-plans** | Implements approved technical plans phase by phase with verification |
| **iterating-plans** | Iterates on existing implementation plans with research and surgical updates |
| **jj-pr-workspace-flow** | Automates temporary Jujutsu workspaces for fixing PR comments |
| **locating-code** | Finds the files, directories, and entry points relevant to a feature or question |
| **locating-docs** | Finds relevant research, plan, and decision documents in a project |
| **maintaining-artifact-consistency** | Keeps frame, shaping, spec, design, implementation, and QA artifacts aligned as truth changes |
| **receiving-code-review** | Verifies and evaluates review feedback before implementation instead of applying suggestions blindly |
| **reflecting-breadboards** | Reflects on breadboards by syncing them to implementation and refining wiring/naming design |
| **requesting-code-review** | Dispatches a code-reviewer subagent to catch issues before they cascade |
| **researching-codebases** | Researches current codebase behavior and produces structured findings with references |
| **revising-prose** | Revises prose for clarity and concision using the Paramedic Method |
| **security-checklist** | Runs structured security reviews for plans, code changes, and architecture decisions |
| **shaping** | Collaboratively shapes a solution by iterating on requirements and solution options |
| **slicing-work** | Breaks a shaped solution into vertical, demoable increments with clear sequence and dependencies |
| **software-builder** | Orchestrates end-to-end software delivery from rough idea through shaping, design, implementation, QA, and consistency |
| **specification-driven-tdd** | Enforces contract-first TDD with implementation-independent specifications and one-test-at-a-time execution |
| **subagent-driven-development** | Executes approved plans with task-by-task implementer/reviewer subagent loops |
| **translating-shape-to-spec** | Converts shaped intent and breadboard artifacts into traceable draft functional behavior |
| **using-jj-workspaces** | Creates isolated Jujutsu workspaces for safe, parallel feature development |
| **verification-before-completion** | Requires running verification commands and confirming evidence before claiming completion |
| **verifying-feature-quality** | Plans and executes feature-level QA verification tied to spec promises and acceptance criteria |
| **web-research** | Researches current external documentation and sources with citations |
| **writing-functional-specs** | Finalizes feature-level functional specs with explicit behavior and acceptance criteria |
| **writing-technical-specifications** | Writes technical function/method specifications with preconditions and postconditions |

## Syncing Skill Links

Use the sync script to mirror skills from `~/.config/agents/skills` into both `~/.claude/skills` and `~/.codex/skills`.

```bash
./scripts/sync-skill-links.sh
```

Useful options:

- `--force-replace` replaces conflicting non-symlink entries.
- `--no-prune` keeps stale source-managed symlinks instead of removing them.
- `--source <path>` syncs from a different source skill directory.

## Syncing Agent Links

Use the agent sync script to mirror repo-managed agent files into both Claude and OpenCode:

```bash
./scripts/sync-agent-links.sh
```

Agent source files are discovered under `skills/*/agents` using platform suffixes:

- `*.claude.md` syncs to `~/.claude/agents/<name>.md`
- `*.opencode.md` syncs to `~/.config/opencode/agents/<name>.md`

Useful options:

- `--force-replace` replaces conflicting non-symlink entries.
- `--no-prune` keeps stale source-managed symlinks instead of removing them.
- `--source <path>` overrides the source skills directory.
- `--claude-target <path>` overrides the Claude agents target directory.
- `--opencode-target <path>` overrides the OpenCode agents target directory.

## Acknowledgements

### [HumanLayer](https://github.com/humanlayer/humanlayer) — Advanced Context Engineering for Coding Agents

The research-plan-implement workflow and "frequent intentional compaction" methodology described in Dex Horthy's [Advanced Context Engineering for Coding Agents](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md) directly shaped several skills in this repo. The idea that AI coding agents work best when context is deliberately structured and compacted into specification artifacts — rather than accumulating raw tool output — informed the design of **researching-codebases**, **creating-implementation-plan**, **implementing-plans**, and **iterating-plans**, which mirror the research → plan → implement pipeline. The emphasis on specs as the real source of truth (drawn from Sean Grove's "specs are the new code") influenced **writing-functional-specs**, **writing-technical-specifications**, and **specification-driven-tdd**. The concept of keeping context utilization in the 40–60% range and designing entire workflows around context management shaped the **software-builder** orchestration skill and the general approach of compacting work into structured markdown artifacts at each stage.

### [rjs/shaping-skills](https://github.com/rjs/shaping-skills) — Shape Up Methodology for LLMs

Ryan Singer's shaping-skills repo adapts the [Shape Up](https://basecamp.com/shapeup) methodology for use with AI coding agents. The skills in this repo for **shaping**, **breadboarding**, **reflecting-breadboards**, and **framing-problems** are adapted from his `/shaping`, `/breadboarding`, `/breadboard-reflection`, and `/framing-doc` skills respectively. Core concepts carried over include: the R/S notation for requirements and shapes, fit checks as binary decision matrices, the affordance table format (UI/Code affordances with Places, Wiring Out, and Returns To), the two-phase breadboard reflection loop (SEE then REFLECT), and the framing discipline of evidence-based problem definition from conversation transcripts. Extensions in this repo include **conversational-shaping** (adding one-question-at-a-time dialogue with teach-back), **conversational-breadboarding** (human-in-the-loop breadboard iteration), **slicing-work**, **translating-shape-to-spec**, and **maintaining-artifact-consistency**, which build on the shaping foundation to bridge into implementation.

### [Q00/ouroboros](https://github.com/Q00/ouroboros/tree/main) — Specification-First Socratic Development

The conversational interview behavior in this repo was adapted in part from Ouroboros, a specification-first development system centered on Socratic questioning, ontological clarification, and staged movement from vague ideas into explicit specs. The repo's emphasis on asking better questions before generating solutions influenced the interviewer-only direction of **conversational-shaping** and **conversational-breadboarding**, as well as the supporting research helpers that let those conversational agents pause to answer codebase, document, or web questions before resuming artifact-building. The specific carryovers are the focus on clarifying hidden assumptions, using questioning to improve human input quality, and treating the conversation as a path toward stronger specification artifacts rather than immediate implementation.

### [obra/superpowers](https://github.com/obra/superpowers) — Agentic Skills Framework

Jesse Vincent's Superpowers provides a complete software development workflow for coding agents built on composable skills. Several skills in this repo were adapted from Superpowers originals: **brainstorming** (Socratic design refinement before coding), **subagent-driven-development** (dispatching fresh subagents per task with two-stage review), **requesting-code-review** and **receiving-code-review** (pre-review checklists and feedback evaluation), **finishing-a-development-branch** (structured merge/PR/cleanup decisions), and **verification-before-completion** (evidence-based verification before claiming success). The overall philosophy of mandatory skills that trigger automatically — "the agent checks for relevant skills before any task" — and the emphasis on TDD, systematic process over ad-hoc prompting, and complexity reduction as a primary goal all influenced the design of the **software-builder** orchestration skill and the general approach taken in this repo.
