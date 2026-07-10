---
name: debug-codebase
description: Use when investigating a bug or unexpected behavior without modifying code yet — traces the error, checks common failure patterns by layer, and proposes a hypothesis with fix options.
---

# Debug Issues

Investigate without modifying. Understand problems, then decide how to proceed.

## When to Use

- Something is broken or behaving unexpectedly and the cause isn't yet known
- Need a documented hypothesis before deciding on a fix

## Process

1. **Understand problem**: Expected vs actual, reproducible?
2. **Gather context** (parallel):
   - Git: `git log --oneline -10`, `git status`
   - Locate related files using the codebase-locator agent
3. **Trace error**: Find source, read code, trace call stack
4. **Check common issues** (see below)
5. **Form hypothesis** with evidence and verification steps

## Common Issues by Layer

**Web / Request handling**:
- Handler/controller receiving unexpected params
- Missing auth or middleware not applied
- Route mismatch — check route file first

**Data layer**:
- Query returning wrong results — check filters, joins, eager loading
- Validation failing silently — inspect changeset/model errors
- Transaction rollback — look for constraint violations

**Background jobs** (`{{BACKGROUND_JOBS}}`):
- Job args — check key type conventions (string vs symbol)
- Queue not configured — check `{{CONFIG_DIR}}`
- Timeout — check job duration vs configured limit

**Real-time / `{{REALTIME_TECHNOLOGY}}`**:
- Subscription topic mismatch vs broadcast topic
- Missing subscribe call in mount/setup
- State not updating — check event handler assignment

## Framework-Specific Notes

*See `.claude/context/project.md` → Architecture Patterns for stack-specific debugging cues.*

## Output Format

```markdown
## Debug: [Issue]
**Status**: Investigating / Root Cause Found

### Problem
Expected: [what should happen]
Actual: [what happens]

### Investigation
| File | Relevance |
|------|-----------|

### Root Cause
[Explanation]
**Location**: `file:line`

### Fix Options
1. [Option] - Pros/Cons
2. [Option] - Pros/Cons

### Verification
1. [step to verify fix]
```

