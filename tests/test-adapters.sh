#!/bin/sh
# Tests the jq adapters that turn linter JSON into "<path><TAB><count>" lines.
. "$(dirname "$0")/lib.sh"

check_adapter() {
  adapter="$1"
  fixture="$2"
  expected="$3"
  actual=$(jq -s -r --arg root "/work/project/" -f "$REPO_ROOT/.claude/scripts/adapters/$adapter-counts.jq" "$REPO_ROOT/tests/fixtures/$fixture")
  assert_equals "$adapter adapter" "$expected" "$actual"
}

check_adapter credo credo.json "$(printf 'lib/a.ex\t2\nlib/b.ex\t1')"
check_adapter eslint eslint.json "$(printf 'src/a.js\t2')"
check_adapter ruff ruff.json "$(printf 'app/a.py\t2\napp/b.py\t1')"

for adapter in credo eslint ruff; do
  message=$(printf '' | jq -s -r --arg root "/work/project/" -f "$REPO_ROOT/.claude/scripts/adapters/$adapter-counts.jq" 2>&1 > /dev/null)
  case "$message" in
    *"$adapter produced no JSON"*) pass ;;
    *) fail "$adapter adapter must report that the linter printed nothing, got: $message" ;;
  esac
done

finish
