#!/bin/sh
# Checks the existing skills hand work to the gate and the two agents, and still parse.
. "$(dirname "$0")/lib.sh"

for skill in create-plan implement-plan validate-plan debug-codebase; do
  assert_frontmatter_valid ".claude/skills/$skill/SKILL.md"
done

assert_contains .claude/skills/create-plan/SKILL.md "plan-auditor agent"
assert_contains .claude/skills/create-plan/SKILL.md "- Modify: \`path/file.{{FILE_EXT}}\`"
assert_contains .claude/skills/create-plan/SKILL.md "Whole-File Cleanup"
assert_contains .claude/skills/implement-plan/SKILL.md "quality-gate skill with \`--plan <plan path>\`"
assert_contains .claude/skills/implement-plan/SKILL.md "classify the deviation by tier"
assert_not_matches .claude/skills/implement-plan/SKILL.md "If reality differs from plan, stop and ask"
assert_contains .claude/skills/validate-plan/SKILL.md "quality-gate skill with \`--plan <plan path>\`"
assert_contains .claude/skills/validate-plan/SKILL.md "visual-guard agent"
assert_contains .claude/skills/validate-plan/SKILL.md "simplify skill"
assert_contains .claude/skills/debug-codebase/SKILL.md "visual-guard agent"

assert_equals "plans list files the way the gate parses them" 1 \
  "$(grep -c '^- \(Modify\|Test\): `' "$REPO_ROOT/.claude/skills/create-plan/SKILL.md" | awk '{ print ($1 >= 3) }')"

assert_contains .claude/skills/validate-plan/SKILL.md '- [ ] The quality gate result is recorded'
assert_contains .claude/skills/validate-plan/SKILL.md 'the visual-guard verdict is recorded'

skills_readme=.claude/skills/README.md
assert_contains "$skills_readme" '| `quality-gate` |'
assert_contains "$skills_readme" '| `plan-auditor` |'
assert_contains "$skills_readme" '| `visual-guard` |'
assert_contains "$skills_readme" 'quality-gate   → check touched files'

finish
