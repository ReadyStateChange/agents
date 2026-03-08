#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

printf 'Checking jj availability...\n'
if ! jj version >/dev/null 2>&1; then
  fail "jj is not installed or not on PATH. Install jj before running this skill."
fi

printf 'Checking repository context...\n'
if ! jj root >/dev/null 2>&1; then
  fail "Not inside a jj repository. Run this skill from within a jj repo."
fi

printf 'Checking GitHub authentication...\n'
if gh auth status >/dev/null 2>&1; then
  printf 'Prerequisites passed.\n'
  exit 0
fi

if gh api graphql -f query='{ viewer { login } }' >/dev/null 2>&1; then
  printf 'Prerequisites passed (gh auth status false-negative; GraphQL auth works).\n'
  exit 0
fi

fail "GitHub authentication failed. Re-authenticate with: gh auth login -h github.com"
