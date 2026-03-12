---
name: using-jj-workspaces
description: Use when starting feature work that needs isolation from the current workspace or before executing implementation plans. Creates isolated Jujutsu workspaces with directory selection, base-revision safety, baseline verification, and cleanup.
---

# Using JJ Workspaces

Use this skill when work should happen in a separate Jujutsu workspace instead of the current working copy.

Announce at start: "I'm using the using-jj-workspaces skill to set up an isolated jj workspace."

## Jujutsu Rules That Matter

- `jj workspace add <destination> [revset]` creates another working copy for the same repo. Each workspace has its own working-copy commit, so the base revset matters.
- `jj workspace forget <name>` deregisters the workspace, but does not delete files from disk.
- If another workspace rewrites the checked-out commit and this workspace becomes stale, run `jj workspace update-stale`.
- Ignored files still use `.gitignore`. There is no `.jjignore`.

## 1. Pick the Workspace Location

Check in this order:

1. Existing project-local directories:

```bash
ls -d .workspaces 2>/dev/null
ls -d workspaces 2>/dev/null
```

If both exist, prefer `.workspaces`.

2. `AGENTS.md` for a project-specific preference:

```bash
rg -n "workspace|workspaces" AGENTS.md 2>/dev/null
```

If `AGENTS.md` specifies a location, use it.

3. If neither exists and `AGENTS.md` is silent, ask the user to choose:

- `.workspaces/` inside the repo
- `~/.config/agents/workspaces/<project-name>/` outside the repo

## 2. Verify Ignore Safety for Project-Local Directories

For `.workspaces/` or `workspaces/`, verify the directory is ignored before creating a workspace there:

```bash
git check-ignore -q .workspaces 2>/dev/null || git check-ignore -q workspaces 2>/dev/null
```

If the chosen project-local directory is not ignored:

1. Add it to `.gitignore`
2. Tell the user you made that repo-hygiene fix
3. Re-run the ignore check before continuing

Global directories do not need `.gitignore` verification.

## 3. Choose a Clean Base Revset

Run:

```bash
jj status
```

Then choose the base revset deliberately:

- If the current workspace is clean, using `@` is acceptable.
- If the current workspace has changes, do not blindly base the new workspace on `@`, because the new workspace gets its own working-copy commit and may inherit those in-progress changes.
- In a dirty workspace, choose an explicit clean base such as `@-`, `main`, `trunk()`, or a requested bookmark/change, and tell the user what you picked.

If the repo uses sparse patterns and you want the new workspace to match the current one, keep the default `--sparse-patterns=copy`. Use `--sparse-patterns=full` only when a full checkout is intentionally needed.

## 4. Create the Workspace

Detect the repo root and project name:

```bash
ROOT=$(jj root)
PROJECT=$(basename "$ROOT")
```

Derive a short hyphenated workspace slug from the task name, ticket, or feature name. Check existing workspace names first:

```bash
jj workspace list
```

If the slug is already in use, append a short suffix and retry.

Create the workspace with an explicit name and explicit base revset:

```bash
jj workspace add "$WORKSPACE_DIR" --name "$WORKSPACE_NAME" -r "$BASE_REVSET"
cd "$WORKSPACE_DIR"
jj workspace root
```

Use `--name` instead of relying on path-derived defaults.

## 5. Run Project Setup

Auto-detect and run only the setup that matches the repo:

```bash
# Bun
if [ -f bun.lockb ] || [ -f bun.lock ]; then bun install; fi

# Node.js
if [ -f package.json ] && [ ! -f bun.lockb ] && [ ! -f bun.lock ]; then npm install; fi

# Deno
# Deno often has no separate install step.

# Ruby
if [ -f Gemfile ]; then bundle install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

For Deno repos, common setup examples are `deno task setup` when the project defines that task, or `deno cache <entrypoint>` when the repo documents a standard entrypoint to pre-cache.

## 6. Verify a Clean Baseline

Run the repo-appropriate verification command before starting implementation:

```bash
bun test
npm test
deno test
cargo test
pytest
bundle exec rspec
bundle exec rake test
go test ./...
```

Use the command that fits the project. Prefer the repo's standard wrapper when one exists, for example `bun run test`, `deno task test`, or another documented project command.

If verification fails:

- Report the failure clearly
- Do not start implementation until the user says to proceed anyway or asks you to investigate

If a command fails because the workspace is stale, run:

```bash
jj workspace update-stale
```

Then rerun the failed command.

## 7. Report Ready

Report:

- Workspace path
- Base revset used
- Verification result
- Whether the workspace is ready for implementation

Example:

```text
Workspace ready at /path/to/repo/.workspaces/feature-auth
Based on main
Tests passing
Ready to implement auth feature
```

## 8. Cleanup

When the isolated work is done:

```bash
cd "$ROOT"
jj workspace forget "$WORKSPACE_NAME"
```

Then delete only the directory created for this workflow. Guard the deletion so it only removes:

- `$ROOT/.workspaces/$WORKSPACE_NAME`
- `$ROOT/workspaces/$WORKSPACE_NAME`
- `$HOME/.config/agents/workspaces/$PROJECT/$WORKSPACE_NAME`

If the directory does not match one of those patterns, stop and ask the user before deleting anything.

## Mistakes To Avoid

- Do not treat `jj workspace add` like `git worktree add -b`; workspace creation and bookmark management are separate in Jujutsu.
- Do not default to `@` when the current workspace is dirty.
- Do not use project-local workspace directories unless they are ignored.
- Do not assume `jj workspace forget` deletes files on disk.
- Do not proceed past failing baseline verification without user approval.

## Integration

Use this skill from:

- `creating-implementations-plans` when the plan identifies independent chunks that can run in parallel
- `iterating-plans` when plan revisions change which chunks are blocked or parallelizable
- `implementing-plans` when execution should not disturb the current workspace
- Any task where the user wants parallel or isolated JJ-based work
