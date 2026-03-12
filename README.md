# AI Skills

A collection of reusable skills for AI coding agents.

## Skills

| Skill | Description |
|-------|-------------|
| **analyzing-thoughts** | Extracts key decisions, constraints, and actionable insights from documents |
| **brainstorming** | Explores user intent, requirements, and design before implementation |
| **breadboarding** | Transforms workflows into UI and Code affordance tables with wiring to map or design systems |
| **creating-handoffs** | Creates concise handoff documents with status, decisions, artifacts, and next actions |
| **conversational-shaping** | Facilitates human-led shaping through one-question-at-a-time dialogue and requires teach-back before completion |
| **creating-plans** | Creates detailed implementation plans through interactive research and iteration |
| **describing-pull-requests** | Generates or updates pull request descriptions from diffs, commits, and repository templates |
| **finishing-a-development-branch** | Guides completion of development work with structured options for merge, PR, or cleanup |
| **humanizing-writing** | Removes AI-writing patterns and rewrites text to sound natural, specific, and human |
| **implementing-plans** | Implements approved technical plans phase by phase with verification |
| **iterating-plans** | Iterates on existing implementation plans with research and surgical updates |
| **jj-pr-workspace-flow** | Automates temporary Jujutsu workspaces for fixing PR comments |
| **locating-thoughts** | Finds relevant research, plan, and decision documents in a project |
| **receiving-code-review** | Verifies and evaluates review feedback before implementation instead of applying suggestions blindly |
| **reflecting-breadboards** | Reflects on breadboards by syncing them to implementation and refining wiring/naming design |
| **requesting-code-review** | Dispatches a code-reviewer subagent to catch issues before they cascade |
| **researching-codebases** | Researches current codebase behavior and produces structured findings with references |
| **revising-prose** | Revises prose for clarity and concision using the Paramedic Method |
| **security-checklist** | Runs structured security reviews for plans, code changes, and architecture decisions |
| **shaping** | Collaboratively shapes a solution by iterating on requirements and solution options |
| **specification-driven-tdd** | Enforces contract-first TDD with implementation-independent specifications and one-test-at-a-time execution |
| **subagent-driven-development** | Executes approved plans with task-by-task implementer/reviewer subagent loops |
| **using-jj-workspaces** | Creates isolated Jujutsu workspaces for safe, parallel feature development |
| **verification-before-completion** | Requires running verification commands and confirming evidence before claiming completion |
| **writing-specifications** | Writes formal function/method specifications with preconditions and postconditions |

## Syncing Skill Links

Use the sync script to mirror canonical skills from `~/.config/agents/skills` into both `~/.claude/skills` and `~/.codex/skills`.

```bash
./scripts/sync-skill-links.sh
```

Useful options:

- `--force-replace` replaces conflicting non-symlink entries.
- `--no-prune` keeps stale source-managed symlinks instead of removing them.
- `--source <path>` syncs from a different source skill directory.
