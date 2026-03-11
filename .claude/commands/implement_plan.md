# Implement Plan

Execute approved plans phase by phase with verification.

## Process

1. **Load plan**: Read file, check existing `[x]` progress markers
2. **Read ALL referenced files** before starting
3. **Create todo list** from plan phases
4. **For each phase**:
   - Announce phase and changes
   - Read files before modifying
   - If reality differs from plan, stop and ask
   - Run `{{TEST_COMMAND}}` and `{{LINT_COMMAND}}` after changes
   - Mark items complete in plan: `- [x] file.{{FILE_EXT}} ✓`
   - Pause for manual verification if needed
5. **On completion**: Run full test suite, update plan status, present summary

## Handling Obstacles

If implementation differs from plan:
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

Ready for review or create commit?
```

## Commands

```bash
{{TEST_COMMAND}}                         # All tests
{{TEST_COMMAND}} {{TEST_DIR}}/path/      # Specific
{{LINT_COMMAND}}                         # Compile + lint + format check
```
