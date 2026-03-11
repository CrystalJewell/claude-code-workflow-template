# Create Handoff Document

Capture session context for seamless resumption.

## Process

1. **Gather context**: Git status, test status, files touched
2. **Identify learnings**: Non-obvious discoveries, patterns, mistakes corrected
3. **Prioritize next steps**: Dependencies, order
4. **Write handoff** to `.claude/thoughts/handoffs/YYYY-MM-DD_HH-MM_description.md`

## Handoff Template

```markdown
# Handoff: [Description]
**Date**: YYYY-MM-DD HH:MM | **Branch**: [branch] | **Commit**: [hash]
**Status**: In Progress/Blocked/Ready for Review

## Task Summary
[1-2 sentences. Original request: "[quote]"]

## Completed
- [x] [Task] - [what was done]

## Remaining
- [ ] [Task] - [what needs doing]

## Critical Files
| File | Purpose |
|------|---------|
| `path:line` | [why it matters] |

## Learnings
- **Patterns**: [discovered patterns]
- **Gotchas**: [non-obvious issues]

## Next Steps
1. [First action]
2. [Second action]

## Test Status
{{TEST_COMMAND}}: [passing/X failures] | {{LINT_COMMAND}}: [status]

---
*Resume with `/resume_handoff [this-file]`*
```

## Related

Use `/recent` to capture what changed during the session.

## Principles

- Thorough > brief (include everything needed to resume)
- Use `file:line` references
- Capture non-obvious learnings
- Actionable next steps
