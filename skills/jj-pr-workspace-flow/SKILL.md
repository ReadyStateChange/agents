---
name: jj-pr-workspace-flow
description: "Automates creation and cleanup of a temporary Jujutsu (jj) workspace to fix PR comments. Use when asked to fix a PR, address review feedback, or work on a bookmark while the main workspace is on a different task. Requires jj and gh CLI."
compatibility: Requires jj (Jujutsu VCS) and gh (GitHub CLI) installed and authenticated
---

# JJ PR Workspace Flow

Create an isolated jj workspace to fix PR review comments without disturbing the current working copy.

## Prerequisites

Before starting, run the setup script. It handles:

- `jj version` and `jj root` checks
- GitHub auth check with GraphQL fallback
- PR and bookmark resolution
- Workspace creation with a unique `fix-*` name
- `jj workspace update-stale` and `jj new <bookmark_name>` (with fetch fallback)

```bash
# Option A: start from a bookmark
eval "$(bash "$HOME/.config/agents/skills/jj-pr-workspace-flow/scripts/setup-workspace.sh" --bookmark <bookmark_name>)"

# Option B: start from a PR number
eval "$(bash "$HOME/.config/agents/skills/jj-pr-workspace-flow/scripts/setup-workspace.sh" --pr <pr_number>)"

# Enter the created workspace
cd "$WORKSPACE_DIR"
```

After setup succeeds, these env vars are available: `PR_NUMBER`, `BOOKMARK_NAME`, `ORIG_DIR`, `DIR_NAME`, `WORKSPACE_NAME`, and `WORKSPACE_DIR`.

## Workflow

### 1. Bootstrap context and workspace

Run one setup command above. If setup fails, stop and fix the reported error before continuing.

### 2. Fetch PR feedback
Gather all reviewer context before making any changes:

```bash
# Get the PR description and top-level conversation comments
gh pr view <pr_number> --comments

# Get inline review comments (line-level feedback on specific code)
gh api "repos/{owner}/{repo}/pulls/<pr_number>/comments" --paginate --jq '.[] | "**\(.path):\(.line // .original_line)** by @\(.user.login)\n\(.body)\n"'

# Get review summaries (approve/request-changes messages)
gh api "repos/{owner}/{repo}/pulls/<pr_number>/reviews" --paginate --jq '.[] | select(.body != "") | "**Review by @\(.user.login) (\(.state))**\n\(.body)\n"'

# Get unresolved review threads with GraphQL thread IDs (required for programmatic resolving)
gh api graphql \
  -f owner="<owner>" \
  -f name="<repo>" \
  -F number=<pr_number> \
  -f query='query($owner:String!, $name:String!, $number:Int!) {
    repository(owner:$owner, name:$name) {
      pullRequest(number:$number) {
        reviewThreads(first:100) {
          nodes {
            id
            isResolved
            isOutdated
            comments(first:30) {
              nodes {
                path
                line
                originalLine
                body
                author { login }
              }
            }
          }
        }
      }
    }
  }' \
  --jq '.data.repository.pullRequest.reviewThreads.nodes[]
    | select(.isResolved == false and .isOutdated == false)
    | .id as $threadId
    | .comments.nodes[]
    | "THREAD \($threadId) | **\(.path):\(.line // .originalLine)** by @\(.author.login)\n\(.body)\n"'

# Get the diff to understand what's being reviewed
gh pr diff <pr_number>
```

Read and understand ALL feedback — top-level comments, inline review comments, and review summaries — before proceeding to code changes.

### 3. Plan the changes

Before writing any code, create a plan from the feedback gathered in step 2:

1. List every change needed.
2. Group related comments into a single task (e.g., multiple comments about the same function or concern become one task).
3. Order tasks by priority (most critical / blocking issues first).
4. For each task, record the matching GraphQL review thread IDs (`THREAD <id>`) that should be resolved when the fix is pushed.
5. Each task will be applied, verified, committed, pushed, and then its matched review threads resolved.

### 4. Apply, verify, push, and resolve each change

Repeat the following cycle for **each change** in the plan, in priority order:

**a. Apply the fix**

Make the code changes for this single item only.

**b. Verify**

Run the project's tests, linter, and type checker before proceeding:

```bash
# Detect and run whatever is appropriate
bun test          # Bun
npm test          # Node.js
pytest            # Python
cargo test        # Rust
make check        # Make-based
```

**Do NOT move on to the next change if any verification fails.** Fix the error first, re-run verification, and only continue once everything is green.

**c. Describe, move bookmark, push, and new**

FOLLOW THESE STEPS EXACTLY

```bash
# Describe the change: one-line summary heading + thorough body
jj describe -m "<one-line summary>

<detailed explanation of what was changed and why>"

# Move the bookmark forward to the current change
jj bookmark move <bookmark_name> --to @

# Push to GitHub
jj git push -b <bookmark_name>

# Create a new change on top of the bookmark for the next fix
jj new <bookmark_name>
```

**d. Resolve addressed review threads programmatically**

After the push succeeds, resolve only the thread IDs mapped to this task:

```bash
for THREAD_ID in <thread_id_1> <thread_id_2>; do
  gh api graphql \
    -f threadId="$THREAD_ID" \
    -f query='mutation($threadId:ID!) {
      resolveReviewThread(input:{threadId:$threadId}) {
        thread {
          id
          isResolved
        }
      }
    }'
done
```

If a thread is already resolved, skip it and continue. Never resolve threads that are not fully addressed by the pushed change.

Return to step 4a for the next change in the plan. This ensures every fix is individually tracked, pushed, and easy to troubleshoot while review threads are resolved in lockstep.

### 5. Clean up

```bash
# Return to the original directory
cd "$ORIG_DIR"

# Deregister the workspace from jj
jj workspace forget "$WORKSPACE_NAME"

# Only delete the directory created by this workflow
TARGET_DIR="$ORIG_DIR/$DIR_NAME"
if [ -d "$TARGET_DIR" ] && [[ "$DIR_NAME" == fix-* ]]; then
  rm -rf "$TARGET_DIR"
fi
```
You have to ensure the directory created for this workflow is deleted. If not, stop ask for the human to help

## Error Recovery

- **Stale working copy**: Always run `jj workspace update-stale` if jj reports staleness.
- **Conflicts**: jj does not block on conflicts. For simple two-sided conflicts, resolve them in the workspace. For three-sided or more complex conflicts, it is acceptable to leave them — jj will track them without blocking your work.
- **Push rejected**: Run `jj git fetch` then `jj rebase -b <bookmark_name> -o <bookmark_name>@origin` and retry the push.
- **Review thread resolve failed**: Confirm the thread ID came from `reviewThreads`, re-fetch threads, and retry `resolveReviewThread` only for unresolved, non-outdated threads.
- **`gh auth status` false negative**: If it fails, run `gh api graphql -f query='{ viewer { login } }'`. If that succeeds, proceed.
- **Cleanup after failure**: If anything fails mid-flow, return to `$ORIG_DIR`, run `jj workspace forget "$WORKSPACE_NAME"`, and only delete the directory using the guarded `fix-*` check from step 5.

## Checklist

- [ ] Ran `eval "$(bash "$HOME/.config/agents/skills/jj-pr-workspace-flow/scripts/setup-workspace.sh" --bookmark <bookmark_name>)"` or `eval "$(bash "$HOME/.config/agents/skills/jj-pr-workspace-flow/scripts/setup-workspace.sh" --pr <pr_number>)"`
- [ ] Confirmed setup produced `PR_NUMBER`, `BOOKMARK_NAME`, `ORIG_DIR`, `WORKSPACE_NAME`, and `WORKSPACE_DIR`
- [ ] Fetched ALL feedback: top-level comments, inline review comments, and review summaries
- [ ] Collected unresolved GraphQL review thread IDs for programmatic resolving
- [ ] Created a prioritized plan with related comments grouped into tasks
- [ ] For each task:
  - [ ] Applied the fix
  - [ ] Verified with tests, linter, and type checker — no errors
  - [ ] Described the change with a one-line summary and detailed body
  - [ ] Moved the bookmark forward with `jj bookmark move --to`
  - [ ] Pushed with `jj git push -b`
  - [ ] Resolved matched review threads via `resolveReviewThread`
  - [ ] Created a new change for the next task with `jj new`
- [ ] Returned to `$ORIG_DIR`
- [ ] Ran `jj workspace forget` before deleting the directory
- [ ] Removed the temporary directory using the guarded `fix-*` check
