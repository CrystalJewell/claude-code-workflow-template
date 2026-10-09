#!/bin/sh
# Opt-in Stop hook: runs the quick quality gate once per distinct working-tree state.
# Exit 2 sends the gate report to Claude as the reason to keep working.
set -u

input=$(cat)
if printf '%s' "$input" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

project_dir=${CLAUDE_PROJECT_DIR:-$PWD}
cd "$project_dir" || exit 0
[ -x .claude/scripts/quality-gate ] || exit 0

state_file="${TMPDIR:-/tmp}/quality-gate-stop-$(printf '%s' "$project_dir" | cksum | cut -d' ' -f1)"
current_state=$({
  git status --porcelain
  git diff HEAD
  git ls-files --others --exclude-standard | while IFS= read -r untracked_path; do
    printf '%s\n' "$untracked_path"
    cksum < "$untracked_path"
  done
} 2> /dev/null | cksum)
if [ -f "$state_file" ] && [ "$(cat "$state_file")" = "$current_state" ]; then
  exit 0
fi

report=$(.claude/scripts/quality-gate --quick 2>&1)
if [ $? -eq 0 ]; then
  printf '%s\n' "$current_state" > "$state_file"
  exit 0
fi
printf 'The quality gate did not pass. Resolve it or raise it for approval before finishing.\n\n%s\n' "$report" >&2
exit 2
