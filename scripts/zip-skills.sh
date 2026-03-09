#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT="$REPO_ROOT/skills-${TIMESTAMP}.zip"

zip -r "$OUTPUT" "$SKILLS_DIR" -x '*.DS_Store'

echo "Created $OUTPUT"
