#!/bin/sh
# Checks the setup-project skill keeps consecutive phases and covers the gate, policy, and hook steps.
. "$(dirname "$0")/lib.sh"

SKILL=.claude/skills/setup-project/SKILL.md

assert_frontmatter_valid "$SKILL"
assert_contains "$SKILL" "disable-model-invocation: true"
assert_equals "skill stays under 500 lines" 1 "$([ "$(wc -l < "$REPO_ROOT/$SKILL")" -le 500 ] && echo 1 || echo 0)"

phases=$(grep -o '^### Phase [0-9]*' "$REPO_ROOT/$SKILL" | awk '{ printf "%s ", $3 }')
assert_equals "phases are numbered consecutively" "1 2 3 4 5 6 7 8 9 10 11 " "$phases"

for phrase in quality-gate.conf AGENTS.md settings.local.json quality-gate-stop.sh SEARCH_TOOLS PROTECTED_AREAS DECISIONS_PATHS LEGACY_PATTERNS check-ignore; do
  assert_contains "$SKILL" "$phrase"
done

phase_eight=$(awk '/^### Phase 8/ { inside = 1; next } /^### Phase 9/ { inside = 0 } inside' "$REPO_ROOT/$SKILL")
personal_line=$(printf '%s\n' "$phase_eight" | grep -n 'Personal (gitignored)' | head -1 | cut -d: -f1)
agents_line=$(printf '%s\n' "$phase_eight" | grep -n 'has an `AGENTS.md`' | head -1 | cut -d: -f1)
assert_equals "phase 8 checks the personal case before AGENTS.md" 1 "$([ -n "$personal_line" ] && [ -n "$agents_line" ] && [ "$personal_line" -lt "$agents_line" ] && echo 1 || echo 0)"

for file in .claude/context/framework-notes.md "$SKILL"; do
  assert_not_matches "$file" 'mix checks'
done

phase_ten=$(awk '/^### Phase 10/ { inside = 1; next } /^### Phase 11/ { inside = 0 } inside' "$REPO_ROOT/$SKILL")
assert_equals "phase 10 keeps the literal hook path" 1 "$(printf '%s\n' "$phase_ten" | grep -Fq '${CLAUDE_PROJECT_DIR}/.claude/hooks/quality-gate-stop.sh' && echo 1 || echo 0)"
assert_equals "phase 10 forbids expanding the hook path" 1 "$(printf '%s\n' "$phase_ten" | grep -Fq 'never expanded to an absolute path' && echo 1 || echo 0)"
phase_seven=$(awk '/^### Phase 7/ { inside = 1; next } /^### Phase 8/ { inside = 0 } inside' "$REPO_ROOT/$SKILL")
assert_equals "phase 7 says to commit the lint snapshot" 1 "$(printf '%s\n' "$phase_seven" | grep -Fq 'Commit the lint snapshot it creates and never gitignore it' && echo 1 || echo 0)"

phase_eight_end=$(printf '%s\n' "$phase_eight" | grep -v '^$' | tail -n 3)
assert_equals "phase 8 ends with a late substitution pass" 1 "$(printf '%s\n' "$phase_eight_end" | grep -Fq 'Re-run the Phase 5 substitution' && echo 1 || echo 0)"
for variable in SEARCH_TOOLS UI_GLOBS DESIGN_TOKENS_PATHS DECISIONS_PATHS PROTECTED_AREAS LEGACY_PATTERNS; do
  assert_equals "phase 8 late pass names $variable" 1 "$(printf '%s\n' "$phase_eight_end" | grep -Fq "{{$variable}}" && echo 1 || echo 0)"
done
assert_equals "phase 8 verifies no placeholder is left" 1 "$(printf '%s\n' "$phase_eight_end" | grep -Fq "grep -rn '{{' .claude/agents .claude/skills" && echo 1 || echo 0)"

finish
