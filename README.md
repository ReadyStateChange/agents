# AI Skills

A collection of reusable skills for AI coding agents.

## Skills

| Skill | Description |
|-------|-------------|
| **analyzing-thoughts** | Extracts key decisions, constraints, and actionable insights from documents |
| **brainstorming** | Explores user intent, requirements, and design before implementation |
| **creating-handoffs** | Creates concise handoff documents with status, decisions, artifacts, and next actions |
| **creating-plans** | Creates detailed implementation plans through interactive research and iteration |
| **describing-pull-requests** | Generates or updates pull request descriptions from diffs, commits, and repository templates |
| **humanizing-writing** | Removes AI-writing patterns and rewrites text to sound natural, specific, and human |
| **implementing-plans** | Implements approved technical plans phase by phase with verification |
| **iterating-plans** | Iterates on existing implementation plans with research and surgical updates |
| **jj-pr-workspace-flow** | Automates temporary Jujutsu workspaces for fixing PR comments |
| **locating-thoughts** | Finds relevant research, plan, and decision documents in a project |
| **reflecting-breadboards** | Reflects on breadboards by syncing them to implementation and refining wiring/naming design |
| **researching-codebases** | Researches current codebase behavior and produces structured findings with references |
| **revising-prose** | Revises prose for clarity and concision using the Paramedic Method |
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
