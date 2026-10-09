#!/bin/sh
# Checks agent frontmatter, and that the new generic agents carry no stack-specific wording.
. "$(dirname "$0")/lib.sh"

for agent_path in "$REPO_ROOT"/.claude/agents/*.md; do
  relative=".claude/agents/$(basename "$agent_path")"
  assert_frontmatter_valid "$relative"
  assert_equals "$relative name matches its filename" "$(basename "$agent_path" .md)" "$(frontmatter_field "$relative" name)"
done

STACK_WORDS='elixir|phoenix|liveview|heex|tailwind|credo|dialyzer|sobelow|ratchet|scout|daisy|petal'
for generic in .claude/agents/plan-auditor.md .claude/agents/visual-guard.md .claude/skills/quality-gate/SKILL.md .claude/scripts/quality-gate .claude/hooks/quality-gate-stop.sh; do
  assert_not_matches "$generic" "$STACK_WORDS"
done

assert_contains .claude/agents/plan-auditor.md "disallowedTools: Write, Edit"
assert_contains .claude/agents/plan-auditor.md "tools: Read, {{SEARCH_TOOLS}}, Bash"
assert_contains .claude/agents/plan-auditor.md "READY-WITH-RULINGS"
assert_contains .claude/agents/plan-auditor.md "NOT-READY"
assert_contains .claude/agents/plan-auditor.md "overrides the tier-based READY-WITH-RULINGS rule"
assert_contains .claude/agents/plan-auditor.md "plan text must be amended before dispatch"
assert_contains .claude/agents/visual-guard.md "tiered never, stop, or needs-approval"
assert_contains .claude/agents/visual-guard.md "tools: Read, {{SEARCH_TOOLS}}"
assert_contains .claude/agents/visual-guard.md "[FAIL - REJECTED]"
assert_contains .claude/agents/visual-guard.md "[WARN]"

for agent in plan-auditor visual-guard; do
  assert_contains ".claude/agents/$agent.md" "effort: high"
  assert_contains ".claude/agents/$agent.md" "model: inherit"
  assert_contains ".claude/agents/$agent.md" "Never propose the action to take"
  assert_not_matches ".claude/agents/$agent.md" '^(tools|disallowedTools):.*(Agent|Task)'
done

for variable in $(grep -oh '{{[A-Z_]*}}' "$REPO_ROOT/.claude/agents/plan-auditor.md" "$REPO_ROOT/.claude/agents/visual-guard.md" | sort -u); do
  assert_contains .claude/context/project.md.template "$variable"
done

finish
