#!/bin/sh
# Shared helpers for the structure tests. Source this file; do not run it.
PASSED=0
FAILED=0
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

pass() {
  PASSED=$((PASSED + 1))
}

fail() {
  FAILED=$((FAILED + 1))
  printf 'FAIL: %s\n' "$1"
}

assert_equals() {
  if [ "$2" = "$3" ]; then
    pass
  else
    fail "$1: expected [$2] but got [$3]"
  fi
}

assert_file_exists() {
  if [ -f "$REPO_ROOT/$1" ]; then
    pass
  else
    fail "missing file: $1"
  fi
}

assert_contains() {
  if grep -Fq -- "$2" "$REPO_ROOT/$1"; then
    pass
  else
    fail "$1 should contain: $2"
  fi
}

assert_not_matches() {
  if grep -Eiq -- "$2" "$REPO_ROOT/$1"; then
    fail "$1 must not match: $2"
  else
    pass
  fi
}

frontmatter_field() {
  ruby -ryaml -e '
    match = File.read(ARGV[0]).match(/\A---\n(.*?)\n---\n/m)
    abort("no frontmatter") unless match
    puts YAML.safe_load(match[1])[ARGV[1]]' "$REPO_ROOT/$1" "$2"
}

assert_frontmatter_valid() {
  name=$(frontmatter_field "$1" name 2> /dev/null)
  description=$(frontmatter_field "$1" description 2> /dev/null)
  if [ -z "$name" ] || [ -z "$description" ]; then
    fail "$1 needs parseable frontmatter with name and description"
  elif [ "${#description}" -gt 1536 ]; then
    fail "$1 description is over 1536 characters"
  else
    pass
  fi
}

finish() {
  printf '\n%s passed, %s failed\n' "$PASSED" "$FAILED"
  [ "$FAILED" -eq 0 ]
}
