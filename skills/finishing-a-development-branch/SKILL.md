---
name: finishing-a-development-branch
description: "Use when implementation is complete, all tests pass, and you need to decide how to integrate the work. Guides completion of development work by presenting structured options for merge, PR, or cleanup."
---

# Finishing a Development Branch

Guide completion of development work by presenting clear options and handling the chosen workflow.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

## Step 1: Verify Tests

Before presenting options, run verification using `verification-before-completion`:

```bash
# Run the project's test suite
bun test / npm test / cargo test / pytest / go test ./...
```

If tests fail:

```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Do not proceed to Step 2.

If tests pass, continue to Step 2.

## Step 2: Determine the Bookmark and Base

Identify the active bookmark and its base revision:

```bash
jj log -r @ --no-graph -T 'bookmarks'
jj log --no-graph -r 'roots(::@ ~ ::main)' -T 'change_id.short() ++ " " ++ description.first_line() ++ "\n"'
```

Or ask: "This work is based on main — is that correct?"

## Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete and verified. What would you like to do?

1. Merge back to <base> locally
2. Push and create a Pull Request
3. Keep the bookmark as-is (I'll handle it later)
4. Discard this work

Which option?
```

Do not add explanation — keep options concise.

## Step 4: Execute Choice

### Option 1: Merge Locally

```bash
# Rebase onto latest base
jj git fetch
jj rebase -b <bookmark> -o main

# Verify tests on rebased result
<test command>

# If tests pass, squash into the base
jj squash --from <bookmark> --into main

# Clean up the bookmark
jj bookmark delete <bookmark>
jj git push --deleted
```

Then: Clean up workspace (Step 5).

### Option 2: Push and Create PR

```bash
# Push the bookmark
jj git push -b <bookmark>

# Create the PR
gh pr create \
  --head <bookmark> \
  --title "<title>" \
  --body "## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>

@claude review
@codex review
@copilot review"
```

Then: Clean up workspace (Step 5).

### Option 3: Keep As-Is

Report: "Keeping bookmark `<name>`. Workspace preserved at `<path>`."

Do not clean up workspace.

### Option 4: Discard

Confirm first:

```
This will permanently discard:
- Bookmark: <name>
- Changes: <change-list>
- Workspace at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation. Do not proceed without it.

If confirmed:

```bash
# Abandon all changes on the bookmark
jj abandon <bookmark>

# Delete the bookmark
jj bookmark delete <bookmark>
jj git push --deleted
```

Then: Clean up workspace (Step 5).

## Step 5: Clean Up Workspace

**For Options 1, 2, 4 only. Skip for Option 3.**

Check if in a JJ workspace created by `using-jj-workspaces`:

```bash
jj workspace list
```

If the current workspace is not the default workspace:

```bash
# Return to the main workspace
cd "$ROOT"

# Deregister the workspace
jj workspace forget "$WORKSPACE_NAME"
```

Then delete only the directory created for this workflow. Guard the deletion so it only removes directories under:

- `$ROOT/.workspaces/$WORKSPACE_NAME`
- `$ROOT/workspaces/$WORKSPACE_NAME`
- `$HOME/.config/agents/workspaces/$PROJECT/$WORKSPACE_NAME`

If the directory does not match one of those patterns, stop and ask the user before deleting anything.

For Option 2, the workspace directory can be removed — the bookmark is pushed and the PR exists remotely.

## Quick Reference

| Option | Merge | Push | Keep Workspace | Clean Up Bookmark |
|--------|-------|------|----------------|-------------------|
| 1. Merge locally | ✓ | - | - | ✓ |
| 2. Create PR | - | ✓ | - | - |
| 3. Keep as-is | - | - | ✓ | - |
| 4. Discard | - | - | - | ✓ (abandon) |

## Common Mistakes

**Skipping test verification**
- Merging broken code or creating a failing PR
- Always verify tests before offering options

**Open-ended questions**
- "What should I do next?" is ambiguous
- Present exactly 4 structured options

**Automatic workspace cleanup for Option 3**
- The user explicitly asked to keep things as-is
- Only clean up for Options 1, 2, and 4

**No confirmation for discard**
- Accidentally abandoning work
- Require typed "discard" confirmation

**Confusing `jj workspace forget` with directory deletion**
- `jj workspace forget` only deregisters — it does not delete files
- Always delete the directory separately after forgetting

## Red Flags

Never:
- Proceed with failing tests
- Merge without verifying tests on the rebased result
- Delete or abandon work without confirmation
- Force-push without explicit request
- Delete a workspace directory that does not match the expected patterns

Always:
- Verify tests before offering options
- Present exactly 4 options
- Get typed confirmation for Option 4
- Run `jj workspace forget` before deleting the directory

## Integration

Called by:
- `implementing-plans` — after all phases are complete and verified
- `subagent-driven-development` — after all tasks and reviews pass

Pairs with:
- `using-jj-workspaces` — cleans up the workspace that skill created
- `verification-before-completion` — runs verification gate before presenting options
