#!/bin/sh
# Checks the context files that carry the quality-gate and approval-tier configuration.
. "$(dirname "$0")/lib.sh"

PROJECT=.claude/context/project.md.template
NOTES=.claude/context/framework-notes.md

for variable in SEARCH_TOOLS LINT_COUNTS_COMMAND TYPECHECK_COMMAND SECURITY_COMMAND BASELINE_DESCRIPTION SUPPRESSION_PATTERNS DEFERRAL_LIST LEGACY_PATTERNS UI_GLOBS DESIGN_TOKENS_PATHS DECISIONS_PATHS PROTECTED_AREAS; do
  assert_contains "$PROJECT" "{{$variable}}"
done

for tier in decide-and-log batch needs-approval never stop; do
  assert_contains "$PROJECT" "| $tier |"
done

approval_tiers_section=$(sed -n '/^## Approval Tiers$/,$p' "$REPO_ROOT/$PROJECT")
for engine_tier in none decide-and-log needs-approval never controller-classifies; do
  case "$approval_tiers_section" in
    *"\`$engine_tier\`"*) pass ;;
    *) fail "Approval Tiers should map the engine tier: $engine_tier" ;;
  esac
done

assert_file_exists .claude/context/decisions.md
assert_contains .claude/context/decisions.md "**Do not**"

quality_gate_blocks=$(grep -c '^### Quality Gate$' "$REPO_ROOT/$NOTES")
assert_equals "every framework section has a Quality Gate block" 3 "$quality_gate_blocks"

for adapter in $(grep -o 'adapters/[a-z]*-counts\.jq' "$REPO_ROOT/$NOTES" | sort -u); do
  assert_file_exists ".claude/scripts/$adapter"
done

assert_contains .claude/context/project.md.template 'pre-existing occurrences in a touched file are reported too'
assert_contains .claude/context/project.md.template 'an occurrence on a line this branch added is `never`'

finish
