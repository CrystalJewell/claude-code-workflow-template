---
name: create-plan
description: Use when you need a structured, actionable implementation plan for a feature or change — researches the current codebase state, defines success criteria, and writes a phased plan to .claude/thoughts/plans/. If the superpowers plugin is installed, prefer superpowers:brainstorming and then superpowers:writing-plans instead.
---

# Create Implementation Plan

Create detailed, actionable plans through structured research.

## When to Use

- A feature or change is well-understood enough to plan, but not yet broken into phases
- Before starting implementation on anything non-trivial

## Process

1. **Gather context**: Read mentioned files, check `.claude/thoughts/` for history
2. **Research current state**: Spawn parallel Explore subagents (Agent tool) for patterns, dependencies, tests
3. **Identify approaches**: If multiple valid options exist, present trade-offs and ask user
4. **Define success criteria**:
   - Automated: `{{TEST_COMMAND}}`, `{{LINT_COMMAND}}`
   - Manual: UI behavior, edge cases
5. **Write plan** to `.claude/thoughts/plans/YYYY-MM-DD-description.md`
6. **Audit the plan**: dispatch the plan-auditor agent with the plan path, the spec path, the accepted-decisions paths from `.claude/context/project.md`, and the base branch. Resolve every finding before presenting
7. **Consult the advisor** if one is available: a plan is cheapest to correct before approval
8. **Present summary** for approval

## Plan Template

```markdown
# [Feature] Implementation Plan
**Date**: YYYY-MM-DD | **Status**: Draft/Approved/Complete

## Overview
[2-3 sentences]

## Current State
[How things work today with file refs]

## Out of Scope
[What this does NOT include]

---
## Phase 1: [Name]
**Files:**
- Modify: `path/file.{{FILE_EXT}}`
- Test: `{{TEST_DIR}}/path/file.{{TEST_EXT}}`

### Changes
- [ ] [change, with the exact detail an implementer needs]

### Success Criteria
- [ ] `{{TEST_COMMAND}} {{TEST_DIR}}/path/` passes
- [ ] The quality-gate skill passes for the files this phase touches
- [ ] [Manual verification]

---
## Final Phase: Whole-File Cleanup
**Files:**
- Modify: `every/file/the/plan/touches`

### Changes
- [ ] Fix everything the quality-gate skill reports in each of those files, whole file and not just the changed lines

### Success Criteria
- [ ] The quality-gate skill reports no FAIL and no NEEDS-APPROVAL

---
## Risks
| Risk | Mitigation |
|------|------------|

## Open Questions
- [ ] [Question]
```

## Before Planning

Consider using first:
- `overview` skill — orientation
- `schema` skill — if data model changes are involved
- `impact` skill — blast radius of proposed changes

## Key Patterns to Respect

*Loaded from `.claude/context/project.md` — see Architecture Patterns and Core Domains sections.*

