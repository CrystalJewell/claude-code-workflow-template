---
name: branch-changes
description: Use when you want a summary of everything changed on the current local git branch — commits since it diverged from the base branch, file-level diff stats, and any uncommitted work
---

# Branch Changes

## Overview

Git-powered report of everything that happened on the current branch: commits since
it diverged from the base branch, which files changed and how much, plus any
uncommitted work still sitting in the working tree. Use this to orient on "what have
I actually done here" before writing a PR description, requesting review, or handing
off to someone else.

## When to Use

- Picking up a branch after time away and need to remember what's on it
- Before drafting a PR description, to see the full scope rather than just the latest commit
- Handing off work and need an accurate "here's what changed" summary

Not for: summarizing recent activity across the whole repo or an arbitrary path —
use the `recent` skill for that instead.

## Process

1. **Determine base branch and divergence point**:
   ```bash
   git remote show origin | grep "HEAD branch"
   git merge-base origin/<base> HEAD
   ```
2. **List commits on this branch**:
   ```bash
   git log --oneline <merge-base>..HEAD
   ```
3. **Analyze committed changes**:
   ```bash
   git diff <merge-base>..HEAD --stat
   git log --format="%h %s" --name-only <merge-base>..HEAD
   ```
4. **Check uncommitted work**: `git status`, `git diff`, `git diff --staged`
5. **Identify patterns**: what the branch is doing as a whole, scope/risk of the changes
6. **Summarize impact**

## Output Format

```markdown
## Branch Changes: [branch-name]

### Summary
- **Base**: main @ [merge-base hash]
- **Commits**: N
- **Files changed**: N (committed) + N (uncommitted)

### Commits
| Hash | Summary | Files |
|------|---------|-------|
| `abc123` | Add feature X | 5 |

### Most Changed Files
| File | Changes | Touched By |
|------|---------|-------------|
| `apps/core/lib/core/feature.ex` | 45 lines | 3 commits |

### Uncommitted Changes
```
[git status output if any]
```
```

## Common Mistakes

- Hardcoding `main` as the base — detect it via `git remote show origin` since some
  branches diverge from something else.
- Skipping the uncommitted-work check — a branch's real state includes what's still
  in the working tree, not just what's committed.