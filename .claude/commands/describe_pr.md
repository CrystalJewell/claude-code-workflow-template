# Describe Pull Request

Create comprehensive PR descriptions.

## Process

1. **Determine base branch**: `git remote show origin | grep "HEAD branch"`
2. **Gather context** (parallel, substitute your base branch):
   ```bash
   git branch --show-current
   git log origin/<base>..HEAD --oneline
   git diff origin/<base>..HEAD --stat
   git diff origin/<base>..HEAD
   git status
   ```
3. **Check related**: plans in `.claude/thoughts/plans/`, handoffs, issues
4. **Analyze ALL commits** on branch (not just latest)
5. **Group changes**: Features, Fixes, Refactoring, Tests, Config
6. **Document testing**: Automated and manual verification
7. **Generate description**

## PR Template

```markdown
## Summary
- [Main change 1]
- [Main change 2]

## Changes

### [Category]
- [Change with file reference if helpful]

## Test Plan

### Automated
- [ ] `{{TEST_COMMAND}}` passes
- [ ] `{{LINT_COMMAND}}` passes

### Manual
- [ ] [Specific verification step]

## Related
- Plan: `.claude/thoughts/plans/[file].md`
- Issue: #XXX
```

## Title Format

`[Type] Brief description` (under 72 chars, imperative) (leading with conventional commit types)
- `feat: Add stat recalculation on level up`
- `fix: Duplicate signup race condition`

## Create PR

```bash
gh pr create --title "title" --body "$(cat <<'BODY'
[body]
BODY
)"
```
