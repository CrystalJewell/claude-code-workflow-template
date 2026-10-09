#!/bin/sh
# Behavioural tests for .claude/hooks/quality-gate-stop.sh. Run: sh tests/test-stop-hook.sh
set -u

export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_NOSYSTEM=1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$PROJECT_ROOT/.claude/hooks/quality-gate-stop.sh"
PASSED=0
FAILED=0
SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

new_repo() {
  repo="$SANDBOX/$1"
  mkdir -p "$repo/lib" "$repo/.claude/scripts" "$repo/.claude/context"
  cp "$PROJECT_ROOT/.claude/scripts/quality-gate" "$repo/.claude/scripts/quality-gate"
  cd "$repo" || exit 1
  git init -q -b main
  git config user.email test@example.com
  git config user.name Test
  printf 'clean = 1\n' > lib/touched.txt
  git add lib
  git commit -q -m "chore: seed"
  git checkout -q -b feature
  printf 'source_pattern=^lib/\nformat_cmd=%s\n' "$2" > .claude/context/quality-gate.conf
  printf 'changed = 1\n' >> lib/touched.txt
  export CLAUDE_PROJECT_DIR="$repo"
  export TMPDIR="$SANDBOX/tmp-$1"
  mkdir -p "$TMPDIR"
}

run_hook() {
  output=$(printf '%s' "$1" | sh "$HOOK" 2>&1)
  status=$?
}

expect() {
  description="$1"
  expected_status="$2"
  expected_text="$3"
  if [ "$status" -eq "$expected_status" ] && { [ -z "$expected_text" ] || printf '%s' "$output" | grep -Fq -- "$expected_text"; }; then
    PASSED=$((PASSED + 1))
  else
    FAILED=$((FAILED + 1))
    printf 'FAIL: %s\n  want status %s containing "%s"\n  got status %s:\n%s\n' \
      "$description" "$expected_status" "$expected_text" "$status" "$output"
  fi
}

expect_value() {
  description="$1"
  expected_value="$2"
  actual_value="$3"
  if [ "$expected_value" = "$actual_value" ]; then
    PASSED=$((PASSED + 1))
  else
    FAILED=$((FAILED + 1))
    printf 'FAIL: %s\n  want %s, got %s\n' "$description" "$expected_value" "$actual_value"
  fi
}

new_repo failing "echo format drift; exit 1"
run_hook '{"stop_hook_active": false}'
expect "a failing gate blocks the stop with the report" 2 "format drift"
run_hook '{"stop_hook_active": false}'
expect "a failing tree is not marked as seen" 2 "format drift"

new_repo loop_guard "echo format drift; exit 1"
run_hook '{"stop_hook_active": true}'
expect "a hook already continuing the turn never blocks again" 0 ""

new_repo passing "echo ran >> \"$SANDBOX/passing-runs\"; exit 0"
run_hook '{"stop_hook_active": false}'
expect "a passing gate lets the turn finish" 0 ""
run_hook '{"stop_hook_active": false}'
expect "an unchanged passing tree is accepted again" 0 ""
gate_runs=$(wc -l < "$SANDBOX/passing-runs" | tr -d ' ')
expect_value "an unchanged passing tree is not re-gated" 1 "$gate_runs"

new_repo changed_again "echo format drift; exit 1"
run_hook '{"stop_hook_active": false}'
printf 'more = 1\n' >> lib/touched.txt
run_hook '{"stop_hook_active": false}'
expect "a changed working tree is checked again" 2 "format drift"

new_repo untracked_edit "! grep -q bad lib/brand-new.txt"
printf 'fine\n' > lib/brand-new.txt
run_hook '{"stop_hook_active": false}'
expect "an untracked file that passes lets the turn finish" 0 ""
printf 'bad\n' > lib/brand-new.txt
run_hook '{"stop_hook_active": false}'
expect "an edited untracked file is checked again" 2 ""

new_repo no_gate_installed "exit 1"
rm .claude/scripts/quality-gate
run_hook '{"stop_hook_active": false}'
expect "a project without the gate script is never blocked" 0 ""

printf '\n%s passed, %s failed\n' "$PASSED" "$FAILED"
[ "$FAILED" -eq 0 ]
