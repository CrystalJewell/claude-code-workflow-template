---
name: resume-handoff
description: Use at the start of a session to resume from a previous handoff document — validates whether the branch, commits, and tests still match what the handoff described. Not for writing a handoff — use the create-handoff skill for that.
---

# Resume from Handoff

Resume work by validating state and continuing where left off.

## When to Use

- Starting a session that continues previously-handed-off work

## Process

1. **Find handoff**: If no path given, list recent from `.claude/thoughts/handoffs/`
2. **Validate state**:
   - Branch matches? `git branch --show-current`
   - New commits since? `git log [commit]..HEAD --oneline`
   - Completed work exists in code?
   - Tests passing? `{{TEST_COMMAND}} && {{LINT_COMMAND}}`
3. **Present summary**:
   ```
   ## Resuming: [Task]
   **Branch**: [name] [✓/⚠️ different]
   **Code**: [✓ unchanged / ⚠️ N new commits]

   ### Verified Completed
   - [x] [task] ✓

   ### Remaining
   - [ ] [task]

   ### Key Learnings
   - [learning]

   Ready to continue?
   ```
4. **Handle discrepancies**: If code diverged, assess impact and present options
5. **Create todos** from remaining work
6. **Begin work**, applying learnings from handoff

## Discrepancy Handling

**New commits exist**:
> ⚠️ N new commits since handoff. Impact: [assessment]. Proceed/Investigate/Update handoff?

**Completed work missing**:
> ⚠️ Expected changes not present. Re-implement?

**Tests failing**:
> ⚠️ Tests failing: [summary]. Fix first/Investigate/Proceed?

