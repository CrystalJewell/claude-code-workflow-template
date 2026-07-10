---
name: commit
description: Use when you have changes ready to save as a git commit — runs safety checks (secrets, debug code, tests, lint) and drafts a structured commit message for approval before committing.
---

# Commit Changes

Create well-structured commit messages.

## When to Use

- Working tree has changes that form a coherent, reviewable unit
- Before ending a session or moving to PR description

## Process

1. **Gather info** (parallel):
   ```bash
   git status
   git diff --staged
   git diff
   git log -5 --oneline
   ```
2. **Categorize** changes: feat | fix | refactor | docs | test | chore
3. **Safety checks**:
   - [ ] No secrets (.env, *.pem, credentials, API keys)
   - [ ] No debug code (print statements, console.log, IO.inspect, dbg, breakpoints)
   - [ ] Tests pass: `{{TEST_COMMAND}}`
   - [ ] Lint passes: `{{LINT_COMMAND}}`
4. **Draft message**:
   ```
   type: Short summary (imperative mood)

   [Optional: why, not what]

   [Optional: Fixes #123]
   ```
5. **Present for approval** with files and checks status
6. **Execute**: `git add [files] && git commit -m "message"`

## Message Guidelines

- Subject: Max 50 chars, imperative ("Add" not "Added"), no period
- Body: Wrap 72 chars, explain why not what

## Examples

```
feat: Add stat recalculation on level up

Stats now recalculate when entities level, applying modifiers.
```

```
fix: Prevent duplicate signups for same session

Added optimistic locking to signup creation.
Fixes #123
```

## After Commit

- More changes? Continue
- Ready for review? Use the describe-pr skill
- End session? Use the create-handoff skill

