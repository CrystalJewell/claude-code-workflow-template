---
name: validate-plan
description: Use after implementing a plan, to verify each phase was actually completed and check for regressions before shipping. Not for executing the plan — use the implement-plan skill for that.
---

# Validate Plan Implementation

Verify plan was executed correctly.

## When to Use

- Implementation of a plan is reportedly complete and needs independent verification
- Before moving to `describe-pr`, to confirm nothing was missed

## Process

1. **Load plan**: If no path, list recent from `.claude/thoughts/plans/`
2. **Gather evidence** (parallel):
   - Git: `git log --oneline -10`, `git diff HEAD~N..HEAD --name-only`
   - Tests: `{{TEST_COMMAND}}`, `{{LINT_COMMAND}}`
   - Files: Read each mentioned file, verify changes exist
3. **Validate each phase**:
   - Check `[x]` markers
   - Verify file changes exist
   - Run automated criteria
   - List manual criteria needing confirmation
4. **Check for regressions**: Unexpected file changes, unrelated test failures
5. **Generate report**

## Output Format

```markdown
## Validation: [Plan Title]
**Status**: ✓ Complete / ⚠️ Partial / ✗ Incomplete

| Metric | Result |
|--------|--------|
| Phases | X/Y complete |
| Tests | ✓ / ✗ N failures |
| Checks | ✓ / ✗ issues |

### Phase Results
#### Phase 1: [Name] - ✓/⚠️/✗
| File | Expected | Actual |
|------|----------|--------|

### Deviations
- [deviation and reason]

### Manual Testing Required
- [ ] [item]

### Next Steps
**Complete**: use the describe-pr skill
**Incomplete**: resume with the implement-plan skill
```

## Validation Checklist

- [ ] All phases marked complete
- [ ] `{{TEST_COMMAND}}` passes
- [ ] `{{LINT_COMMAND}}` passes
- [ ] Follows existing patterns
- [ ] New code has tests

