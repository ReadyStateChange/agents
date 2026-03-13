#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="${HOME}/.config/agents/skills"
CLAUDE_TARGET="${HOME}/.claude/agents"
OPENCODE_TARGET="${HOME}/.config/opencode/agents"
FORCE_REPLACE=0
PRUNE=1

usage() {
  cat <<'EOF'
Usage: sync-agent-links.sh [options]

Sync agent symlinks from ~/.config/agents/skills/*/agents into ~/.claude/agents
and ~/.config/opencode/agents.

Naming convention:
  *.claude.md    -> ~/.claude/agents/<name>.md
  *.opencode.md  -> ~/.config/opencode/agents/<name>.md

Options:
  --source <path>          Override source skills directory
  --claude-target <path>   Override Claude agents target directory
  --opencode-target <path> Override OpenCode agents target directory
  --force-replace          Replace non-symlink entries that conflict with agent names
  --no-prune               Do not remove stale source-managed symlinks in targets
  -h, --help               Show this help text
EOF
}

contains_destination_name() {
  local destination_name="$1"
  shift
  local entry
  for entry in "$@"; do
    if [ "${entry%%::*}" = "$destination_name" ]; then
      return 0
    fi
  done
  return 1
}

declare -a claude_entries=()
declare -a opencode_entries=()

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
    --claude-target)
      if [ "$#" -lt 2 ]; then
        echo "error: --claude-target requires a path" >&2
        exit 1
      fi
      CLAUDE_TARGET="$2"
      shift 2
      ;;
    --opencode-target)
      if [ "$#" -lt 2 ]; then
        echo "error: --opencode-target requires a path" >&2
        exit 1
      fi
      OPENCODE_TARGET="$2"
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

while IFS= read -r path; do
  file_name="$(basename "$path")"
  case "$file_name" in
    *.claude.md)
      destination_name="${file_name%.claude.md}.md"
      if contains_destination_name "$destination_name" "${claude_entries[@]-}"; then
        echo "error: duplicate Claude agent destination: $destination_name" >&2
        exit 1
      fi
      claude_entries+=("${destination_name}::${path}")
      ;;
    *.opencode.md)
      destination_name="${file_name%.opencode.md}.md"
      if contains_destination_name "$destination_name" "${opencode_entries[@]-}"; then
        echo "error: duplicate OpenCode agent destination: $destination_name" >&2
        exit 1
      fi
      opencode_entries+=("${destination_name}::${path}")
      ;;
  esac
done < <(find "$SOURCE_DIR" -mindepth 3 -maxdepth 3 -type f -path "*/agents/*.md" | sort)

if [ "${#claude_entries[@]}" -eq 0 ] && [ "${#opencode_entries[@]}" -eq 0 ]; then
  echo "error: no agent files found under $SOURCE_DIR (expected */agents/*.claude.md or *.opencode.md)" >&2
  exit 1
fi

created=0
updated=0
removed=0
skipped=0

sync_target() {
  local target="$1"
  local platform="$2"
  shift 2
  local entries=("$@")
  local entry destination_name source_path destination_path
  local current_target link link_name link_target

  mkdir -p "$target"
  echo "syncing target: $target"

  for entry in "${entries[@]}"; do
    destination_name="${entry%%::*}"
    source_path="${entry#*::}"
    destination_path="$target/$destination_name"

    if [ -L "$destination_path" ]; then
      current_target="$(readlink "$destination_path")"
      if [ "$current_target" = "$source_path" ]; then
        continue
      fi
      rm "$destination_path"
      ln -s "$source_path" "$destination_path"
      updated=$((updated + 1))
      echo "  updated: $destination_name"
      continue
    fi

    if [ -e "$destination_path" ]; then
      if [ "$FORCE_REPLACE" -eq 1 ]; then
        rm -rf "$destination_path"
        ln -s "$source_path" "$destination_path"
        updated=$((updated + 1))
        echo "  replaced: $destination_name"
      else
        skipped=$((skipped + 1))
        echo "  skipped non-symlink: $destination_name (use --force-replace to replace)"
      fi
      continue
    fi

    ln -s "$source_path" "$destination_path"
    created=$((created + 1))
    echo "  created: $destination_name"
  done

  if [ "$PRUNE" -eq 1 ]; then
    for link in "$target"/*; do
      [ -L "$link" ] || continue
      link_name="$(basename "$link")"
      link_target="$(readlink "$link")"

      case "$platform" in
        claude)
          case "$link_target" in
            "$SOURCE_DIR"/*/agents/*.claude.md)
              if ! contains_destination_name "$link_name" "${entries[@]}"; then
                rm "$link"
                removed=$((removed + 1))
                echo "  removed stale link: $link_name"
              fi
              ;;
          esac
          ;;
        opencode)
          case "$link_target" in
            "$SOURCE_DIR"/*/agents/*.opencode.md)
              if ! contains_destination_name "$link_name" "${entries[@]}"; then
                rm "$link"
                removed=$((removed + 1))
                echo "  removed stale link: $link_name"
              fi
              ;;
          esac
          ;;
      esac
    done
  fi
}

if [ "${#claude_entries[@]}" -gt 0 ]; then
  sync_target "$CLAUDE_TARGET" "claude" "${claude_entries[@]}"
fi

if [ "${#opencode_entries[@]}" -gt 0 ]; then
  sync_target "$OPENCODE_TARGET" "opencode" "${opencode_entries[@]}"
fi

echo
echo "done: created=$created updated=$updated removed=$removed skipped=$skipped"
