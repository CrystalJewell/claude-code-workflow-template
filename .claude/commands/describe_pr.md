# Describe Pull Request

Create short, reviewer-friendly PR descriptions.

## Style

Keep descriptions short and parseable. A single line per bullet or section is fine. Reviewers get more value from a tight summary than from a dense wall of text.

- Don't re-inventory what the diff shows (file lists, per-call-site bullets). Summarize at the behavior level.
- Omit optional sections entirely if they'd be "N/A" or boilerplate — do not pad.
- Only keep items in Summary/Test Plan that flag real judgment calls or verification steps a reviewer needs, not restatements of the change.
- Self-review the description for length before proposing it. If it takes longer to read than it took to produce, trim it.

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
5. **Generate description** — applying the style rules above

## PR Template

Only `## Summary` is required. Every other section is optional — include it only if it adds information a reviewer couldn't get from the diff. Prefer omitting over writing "N/A".

```markdown
## Summary
- [One line per main change, at the behavior level]

## Changes

### [Category]
- [OPTIONAL: include only if grouping clarifies a large diff. Omit otherwise.]

## Test Plan

### Automated
- [ ] `{{TEST_COMMAND}}` passes
- [ ] `{{LINT_COMMAND}}` passes

### Manual
- [OPTIONAL: include only for changes that need human verification. Omit otherwise.]

## Related
- [OPTIONAL: plan, issue, or spec links. Omit if none.]
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
