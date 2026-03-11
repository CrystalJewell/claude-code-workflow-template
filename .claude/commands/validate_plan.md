# Validate Plan Implementation

Verify plan was executed correctly.

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
**Complete**: `/describe_pr`
**Incomplete**: Resume with `/implement_plan`
```

## Validation Checklist

- [ ] All phases marked complete
- [ ] `{{TEST_COMMAND}}` passes
- [ ] `{{LINT_COMMAND}}` passes
- [ ] Follows existing patterns
- [ ] New code has tests
