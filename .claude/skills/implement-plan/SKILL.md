---
name: implement-plan
description: Use when executing an approved implementation plan phase by phase, with verification after each phase. Not for writing the plan itself — use the create-plan skill for that. If the superpowers plugin is installed, prefer superpowers:executing-plans or superpowers:subagent-driven-development instead.
---

# Implement Plan

Execute approved plans phase by phase with verification.

## When to Use

- A plan already exists in `.claude/thoughts/plans/` and is approved
- Resuming a partially-implemented plan (checks existing `[x]` progress markers)

## Process

1. **Load plan**: Read file, check existing `[x]` progress markers
2. **Read ALL referenced files** before starting
3. **Create todo list** from plan phases
4. **For each phase**:
   - Announce phase and changes
   - Read files before modifying
   - If reality differs from the plan, classify it by tier as described in Handling Obstacles: decide and log low-risk deviations, ask only for needs-approval or stop
   - Run the quality-gate skill with `--plan <plan path>` after changes. A clean gate means continue without pausing. Handle findings by their tier in the Approval Tiers of `.claude/context/project.md`. Only a needs-approval or stop finding waits for the user, and independent tasks keep going
   - Mark items complete in plan: `- [x] file.{{FILE_EXT}} ✓`
   - Pause for manual verification if needed
5. **On completion**: Run full test suite, update plan status, consult the advisor if one is available, present summary

## Handling Obstacles

If implementation differs from the plan, classify the deviation by tier. Decide and log the low-risk ones. For a needs-approval deviation, ask:
> Issue: [what's different]
> Options: 1) [option] 2) [option]
> Which approach?

## Completion Summary

```
## Implementation Complete: [Title]
**Tests**: ✓ Passing | **Checks**: ✓ Passing

**Changes**:
- [what changed]

**Files**: [list]

Ready for review or create a commit? Use the validate-plan skill, then the commit skill.
```

## Commands

```bash
{{TEST_COMMAND}}                         # All tests
{{TEST_COMMAND}} {{TEST_DIR}}/path/      # Specific
{{LINT_COMMAND}}                         # Compile + lint + format check
```

