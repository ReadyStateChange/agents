#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="${HOME}/.config/agents/skills"
TARGET_DIRS=("${HOME}/.claude/skills" "${HOME}/.codex/skills")
FORCE_REPLACE=0
PRUNE=1

usage() {
  cat <<'EOF'
Usage: sync-skill-links.sh [options]

Sync skill symlinks from ~/.config/agents/skills into ~/.claude/skills and ~/.codex/skills.

Options:
  --source <path>     Override source skills directory
  --force-replace     Replace non-symlink entries that conflict with skill names
  --no-prune          Do not remove stale source-managed symlinks in targets
  -h, --help          Show this help text
EOF
}

contains_skill() {
  local name="$1"
  shift
  for skill in "$@"; do
    if [ "$skill" = "$name" ]; then
      return 0
    fi
  done
  return 1
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --source)
      if [ "$#" -lt 2 ]; then
        echo "error: --source requires a path" >&2
        exit 1
      fi
      SOURCE_DIR="$2"
      shift 2
      ;;
    --force-replace)
      FORCE_REPLACE=1
      shift
      ;;
    --no-prune)
      PRUNE=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ ! -d "$SOURCE_DIR" ]; then
  echo "error: source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

skills=()
for path in "$SOURCE_DIR"/*; do
  [ -d "$path" ] || continue
  [ -f "$path/SKILL.md" ] || continue
  skills+=("$(basename "$path")")
done

if [ "${#skills[@]}" -eq 0 ]; then
  echo "error: no skills with SKILL.md found in $SOURCE_DIR" >&2
  exit 1
fi

created=0
updated=0
removed=0
skipped=0

for target in "${TARGET_DIRS[@]}"; do
  mkdir -p "$target"
  echo "syncing target: $target"

  for skill in "${skills[@]}"; do
    src="$SOURCE_DIR/$skill"
    dst="$target/$skill"

    if [ -L "$dst" ]; then
      current_target="$(readlink "$dst")"
      if [ "$current_target" = "$src" ]; then
        continue
      fi
      rm "$dst"
      ln -s "$src" "$dst"
      updated=$((updated + 1))
      echo "  updated: $skill"
      continue
    fi

    if [ -e "$dst" ]; then
      if [ "$FORCE_REPLACE" -eq 1 ]; then
        rm -rf "$dst"
        ln -s "$src" "$dst"
        updated=$((updated + 1))
        echo "  replaced: $skill"
      else
        skipped=$((skipped + 1))
        echo "  skipped non-symlink: $skill (use --force-replace to replace)"
      fi
      continue
    fi

    ln -s "$src" "$dst"
    created=$((created + 1))
    echo "  created: $skill"
  done

  if [ "$PRUNE" -eq 1 ]; then
    for link in "$target"/*; do
      [ -L "$link" ] || continue
      link_name="$(basename "$link")"
      link_target="$(readlink "$link")"
      case "$link_target" in
        "$SOURCE_DIR"/*)
          if ! contains_skill "$link_name" "${skills[@]}"; then
            rm "$link"
            removed=$((removed + 1))
            echo "  removed stale link: $link_name"
          fi
          ;;
      esac
    done
  fi
done

echo
echo "done: created=$created updated=$updated removed=$removed skipped=$skipped"
