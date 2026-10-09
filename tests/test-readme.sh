#!/bin/sh
# Checks the README names every part of the pipeline.
. "$(dirname "$0")/lib.sh"

for name in quality-gate plan-auditor visual-guard quality-gate.conf tests/run-all.sh "approval tiers"; do
  assert_contains README.md "$name"
done

finish
