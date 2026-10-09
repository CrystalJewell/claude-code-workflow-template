---
name: validate-plan
description: Use after implementing a plan, to verify each phase was actually completed and check for regressions before shipping. Not for executing the plan — use the implement-plan skill for that. If the superpowers plugin is installed, prefer superpowers:verification-before-completion and superpowers:requesting-code-review instead.
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
   - Gate: the quality-gate skill with `--plan <plan path>`, which covers tests, lint, formatting, and the whole-file rule
   - Files: Read each mentioned file, verify changes exist
3. **Validate each phase**:
   - Check `[x]` markers
   - Verify file changes exist
   - Run automated criteria
   - List manual criteria needing confirmation
4. **Check for regressions**: Unexpected file changes, unrelated test failures
5. **Review the UI** when the diff touches `{{UI_GLOBS}}`: dispatch the visual-guard agent with the changed files and the diff, and confirm the project's design-review passes ran, naming where
6. **Check scale**: for a large diff, suggest the simplify skill before shipping
7. **Generate report**

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
- [ ] The quality gate result is recorded, and when the project has UI globs (`{{UI_GLOBS}}`), the visual-guard verdict is recorded
- [ ] Follows existing patterns
- [ ] New code has tests

