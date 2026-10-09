#!/bin/sh
# Keeps the quality-gate skill, the config template, and the engine describing the same contract.
. "$(dirname "$0")/lib.sh"

SKILL=.claude/skills/quality-gate/SKILL.md
TEMPLATE=.claude/context/quality-gate.conf.template
ENGINE=.claude/scripts/quality-gate
CONFIG_KEYS="base_ref source_pattern lint_counts_cmd typecheck_counts_cmd baseline_cmd snapshot_file suppression_pattern legacy_pattern format_cmd security_cmd test_cmd plan_files_cmd deferral_list approvals_file"
OPTIONS="--config --plan --base --quick --update-snapshot"

assert_file_exists "$SKILL"
assert_file_exists "$TEMPLATE"
assert_frontmatter_valid "$SKILL"
assert_equals "skill name matches its directory" quality-gate "$(frontmatter_field "$SKILL" name)"
assert_contains "$SKILL" "Bash(.claude/scripts/quality-gate *)"
assert_not_matches "$SKILL" '\./\.claude/scripts/quality-gate'
assert_equals "skill stays under 500 lines" 1 "$([ "$(wc -l < "$REPO_ROOT/$SKILL")" -le 500 ] && echo 1 || echo 0)"

for key in $CONFIG_KEYS; do
  assert_contains "$SKILL" "\`$key\`"
  assert_contains "$TEMPLATE" "$key"
  assert_contains "$ENGINE" "$key"
done
for option in $OPTIONS; do
  assert_contains "$SKILL" "$option"
  assert_contains "$ENGINE" "$option"
done

for message in "linter failed; project total not measured" "not found; committed changes not checked"; do
  assert_contains "$SKILL" "$message"
  assert_contains "$ENGINE" "$message"
done

assert_not_matches "$TEMPLATE" '^source_pattern='
assert_not_matches "$TEMPLATE" '^[a-z_]+\+=[[:space:]]*$'

for tier in none never decide-and-log needs-approval controller-classifies; do
  assert_contains "$SKILL" "\`$tier\`"
  assert_contains "$ENGINE" "$tier"
done

for file in .claude/context/framework-notes.md "$TEMPLATE"; do
  assert_not_matches "$file" 'arg root "\$PWD/"'
  assert_contains "$file" 'arg root "$(pwd -P)/"'
done
assert_contains "$SKILL" 'the root must be the physical path, `"$(pwd -P)/"`'
assert_contains "$SKILL" 'Commit the snapshot file and never gitignore it, because it is the shared floor.'

decide_row=$(grep -F '| `decide-and-log` |' "$REPO_ROOT/$SKILL" | head -1)
assert_equals "decide-and-log row never lets the controller defer alone" 0 "$(printf '%s\n' "$decide_row" | grep -Eic 'defer.*recorded reason')"
assert_equals "decide-and-log row points deferrals at the user" 1 "$(printf '%s\n' "$decide_row" | grep -Fc 'Deferring a file needs the user, see Deferrals and Approvals')"
assert_contains "$SKILL" 'pre-existing occurrences in a touched file are reported too'
assert_contains "$SKILL" 'an occurrence on a line this branch added is `never`'

finish
