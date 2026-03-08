#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat >&2 <<'USAGE'
Usage:
  bash scripts/setup-workspace.sh --bookmark <bookmark_name>
  bash scripts/setup-workspace.sh --pr <pr_number>
  bash scripts/setup-workspace.sh --bookmark <bookmark_name> --pr <pr_number>

If arguments are missing or invalid, the script prompts in the terminal for a PR number or bookmark.

This script prints export statements to stdout. Use with:
  eval "$(bash scripts/setup-workspace.sh --bookmark <bookmark_name>)"
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

PR_NUMBER=""
BOOKMARK_NAME=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bookmark)
      [ "$#" -ge 2 ] || fail "Missing value for --bookmark"
      BOOKMARK_NAME="$2"
      shift 2
      ;;
    --pr)
      [ "$#" -ge 2 ] || fail "Missing value for --pr"
      PR_NUMBER="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      fail "Unknown argument: $1"
      ;;
  esac
done

if [ ! -x "$SCRIPT_DIR/check-prereqs.sh" ]; then
  fail "Missing executable prerequisite script: $SCRIPT_DIR/check-prereqs.sh"
fi

# Run prereq checks first.
bash "$SCRIPT_DIR/check-prereqs.sh" >&2

has_tty() {
  [ -r /dev/tty ]
}

read_tty_line() {
  local prompt="$1"
  local input=""

  if ! has_tty; then
    fail "Cannot prompt for input because no TTY is available. Provide --pr or --bookmark."
  fi

  printf '%s' "$prompt" > /dev/tty
  IFS= read -r input < /dev/tty || fail "Failed to read input from terminal"
  printf '%s' "$input"
}

normalize_gh_value() {
  local value="$1"
  if [ "$value" = "null" ]; then
    printf ''
  else
    printf '%s' "$value"
  fi
}

resolve_pr_from_bookmark() {
  local bookmark="$1"
  local value=""
  if value="$(gh pr list --head "$bookmark" --json number --jq '.[0].number' 2>/dev/null)"; then
    normalize_gh_value "$value"
    return 0
  fi
  printf ''
  return 1
}

resolve_bookmark_from_pr() {
  local pr_number="$1"
  local value=""
  if value="$(gh pr view "$pr_number" --json headRefName --jq '.headRefName' 2>/dev/null)"; then
    normalize_gh_value "$value"
    return 0
  fi
  printf ''
  return 1
}

prompt_for_target() {
  while true; do
    printf '\n' >&2
    printf 'No valid PR/bookmark context yet.\n' >&2
    printf 'You can enter a PR number (example: 3) or bookmark name (example: v1/phase-3-parser).\n' >&2

    local response
    response="$(read_tty_line 'PR number or bookmark (q to quit): ')"

    case "$response" in
      q|Q|quit|QUIT|exit|EXIT)
        fail "Setup cancelled by user"
        ;;
      '')
        printf 'Input cannot be empty.\n' >&2
        ;;
      *)
        if [[ "$response" =~ ^[0-9]+$ ]]; then
          PR_NUMBER="$response"
          BOOKMARK_NAME=""
          return 0
        fi
        BOOKMARK_NAME="$response"
        PR_NUMBER=""
        return 0
        ;;
    esac
  done
}

resolve_context_interactively() {
  while true; do
    if [ -z "$PR_NUMBER" ] && [ -z "$BOOKMARK_NAME" ]; then
      prompt_for_target
      continue
    fi

    if [ -n "$BOOKMARK_NAME" ] && [ -z "$PR_NUMBER" ]; then
      printf 'Resolving PR number from bookmark %s...\n' "$BOOKMARK_NAME" >&2
      local resolved_pr
      resolved_pr="$(resolve_pr_from_bookmark "$BOOKMARK_NAME")"
      if [ -n "$resolved_pr" ]; then
        PR_NUMBER="$resolved_pr"
        return 0
      fi
      printf 'Could not find a PR for bookmark "%s".\n' "$BOOKMARK_NAME" >&2
      PR_NUMBER=""
      BOOKMARK_NAME=""
      continue
    fi

    if [ -n "$PR_NUMBER" ] && [ -z "$BOOKMARK_NAME" ]; then
      printf 'Resolving bookmark from PR #%s...\n' "$PR_NUMBER" >&2
      local resolved_bookmark
      resolved_bookmark="$(resolve_bookmark_from_pr "$PR_NUMBER")"
      if [ -n "$resolved_bookmark" ]; then
        BOOKMARK_NAME="$resolved_bookmark"
        return 0
      fi
      printf 'Could not resolve bookmark for PR #%s.\n' "$PR_NUMBER" >&2
      PR_NUMBER=""
      BOOKMARK_NAME=""
      continue
    fi

    printf 'Validating PR #%s against bookmark %s...\n' "$PR_NUMBER" "$BOOKMARK_NAME" >&2
    local resolved_from_pr
    resolved_from_pr="$(resolve_bookmark_from_pr "$PR_NUMBER")"

    if [ -n "$resolved_from_pr" ] && [ "$resolved_from_pr" = "$BOOKMARK_NAME" ]; then
      return 0
    fi

    if [ -n "$resolved_from_pr" ]; then
      printf 'Mismatch: PR #%s points to "%s", not "%s".\n' "$PR_NUMBER" "$resolved_from_pr" "$BOOKMARK_NAME" >&2
    else
      printf 'Could not validate PR #%s.\n' "$PR_NUMBER" >&2
    fi

    PR_NUMBER=""
    BOOKMARK_NAME=""
  done
}

resolve_context_interactively

ORIG_DIR="$(pwd)"
WORKSPACE_NAME=""
DIR_NAME=""
WORKSPACE_DIR=""

cleanup_on_error() {
  local exit_code=$?
  if [ "$exit_code" -ne 0 ]; then
    if [ -n "$WORKSPACE_NAME" ]; then
      (cd "$ORIG_DIR" && jj workspace forget "$WORKSPACE_NAME" >/dev/null 2>&1) || true
    fi
    if [ -n "$WORKSPACE_DIR" ] && [ -d "$WORKSPACE_DIR" ] && [[ "$DIR_NAME" == fix-* ]]; then
      rm -rf "$WORKSPACE_DIR"
    fi
  fi
  exit "$exit_code"
}
trap cleanup_on_error EXIT

SAFE_BOOKMARK="$(printf '%s' "$BOOKMARK_NAME" | tr '/[:space:]' '-' | tr -cd '[:alnum:]._-')"
[ -n "$SAFE_BOOKMARK" ] || fail "Bookmark name becomes empty after sanitization: $BOOKMARK_NAME"

TS="$(date +%s)"
DIR_NAME="fix-${SAFE_BOOKMARK}-${TS}"
WORKSPACE_NAME="$DIR_NAME"
WORKSPACE_DIR="$ORIG_DIR/$DIR_NAME"

if [ -e "$WORKSPACE_DIR" ]; then
  DIR_NAME="fix-${SAFE_BOOKMARK}-${TS}-${RANDOM}"
  WORKSPACE_NAME="$DIR_NAME"
  WORKSPACE_DIR="$ORIG_DIR/$DIR_NAME"
fi

printf 'Creating workspace %s...\n' "$WORKSPACE_NAME" >&2
(cd "$ORIG_DIR" && jj workspace add "$DIR_NAME" --name "$WORKSPACE_NAME") >&2

printf 'Updating stale state and targeting bookmark %s...\n' "$BOOKMARK_NAME" >&2
(
  cd "$WORKSPACE_DIR"
  jj workspace update-stale >&2
  if ! jj new "$BOOKMARK_NAME" >&2; then
    jj git fetch >&2
    jj new "$BOOKMARK_NAME" >&2
  fi
)

trap - EXIT

printf 'export ORIG_DIR=%q\n' "$ORIG_DIR"
printf 'export SKILL_DIR=%q\n' "$SKILL_DIR"
printf 'export PR_NUMBER=%q\n' "$PR_NUMBER"
printf 'export BOOKMARK_NAME=%q\n' "$BOOKMARK_NAME"
printf 'export DIR_NAME=%q\n' "$DIR_NAME"
printf 'export WORKSPACE_NAME=%q\n' "$WORKSPACE_NAME"
printf 'export WORKSPACE_DIR=%q\n' "$WORKSPACE_DIR"
