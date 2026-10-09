#!/bin/sh
# Runs every test-*.sh in this directory and fails if any suite fails.
cd "$(dirname "$0")" || exit 1
failed=0
for suite in test-*.sh; do
  printf '== %s\n' "$suite"
  sh "$suite" || failed=1
done
exit "$failed"
