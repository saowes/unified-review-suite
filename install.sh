#!/usr/bin/env bash
# Install the unified-review-suite into Cursor.
# Default scope is personal (~/.cursor), available across all projects.
#
# Usage:
#   ./install.sh                 # install to ~/.cursor
#   ./install.sh -p /path/repo   # install to <repo>/.cursor
#   ./install.sh --skip-hooks    # do not install the automation hook
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH=""
SKIP_HOOKS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project) PROJECT_PATH="$2"; shift 2 ;;
    --skip-hooks) SKIP_HOOKS=1; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -n "$PROJECT_PATH" ]]; then
  BASE="$PROJECT_PATH/.cursor"; SCOPE="project ($PROJECT_PATH)"
else
  BASE="$HOME/.cursor"; SCOPE="personal (~/.cursor)"
fi

echo "Installing unified-review-suite -> $SCOPE"

# 1) Skills
mkdir -p "$BASE/skills"
for d in "$SRC"/skills/*/; do
  cp -R "$d" "$BASE/skills/"
  echo "  skill  -> $(basename "$d")"
done

# 2) Rules
mkdir -p "$BASE/rules"
cp -f "$SRC"/rules/*.mdc "$BASE/rules/"
echo "  rules  -> installed"

# 3) Commands
mkdir -p "$BASE/commands"
cp -f "$SRC"/commands/*.md "$BASE/commands/"
echo "  commands -> installed"

# 4) Hooks (safe: merge if jq present, else write snippet)
if [[ "$SKIP_HOOKS" -eq 0 ]]; then
  HOOK_SRC="$SRC/hooks/hooks.json"
  HOOK_DST="$BASE/hooks.json"
  if [[ ! -f "$HOOK_DST" ]]; then
    cp -f "$HOOK_SRC" "$HOOK_DST"
    echo "  hooks  -> installed (new hooks.json)"
  elif command -v jq >/dev/null 2>&1; then
    BAK="$HOOK_DST.bak.$(date +%Y%m%d%H%M%S)"
    cp -f "$HOOK_DST" "$BAK"
    jq -s '.[0] as $a | .[1] as $b
      | $a
      | .hooks.afterFileEdit = (((.hooks.afterFileEdit // []) + ($b.hooks.afterFileEdit // []))
          | unique_by(.prompt))' "$HOOK_DST" "$HOOK_SRC" > "$HOOK_DST.tmp" && mv "$HOOK_DST.tmp" "$HOOK_DST"
    echo "  hooks  -> merged into existing hooks.json (backup: $BAK)"
  else
    cp -f "$HOOK_SRC" "$HOOK_DST.unified-review-suite.json"
    echo "  hooks  -> existing hooks.json kept; ours saved as hooks.json.unified-review-suite.json (jq not found, merge manually)"
  fi
else
  echo "  hooks  -> skipped (--skip-hooks)"
fi

echo "Done. Restart Cursor or toggle Skills if the suite does not appear."
