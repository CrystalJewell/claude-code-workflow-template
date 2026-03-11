# Create Implementation Plan

Create detailed, actionable plans through structured research.

## Process

1. **Gather context**: Read mentioned files, check `.claude/thoughts/` for history
2. **Research current state**: Spawn parallel Explore tasks for patterns, dependencies, tests
3. **Identify approaches**: If multiple valid options exist, present trade-offs and ask user
4. **Define success criteria**:
   - Automated: `{{TEST_COMMAND}}`, `{{LINT_COMMAND}}`
   - Manual: UI behavior, edge cases
5. **Write plan** to `.claude/thoughts/plans/YYYY-MM-DD-description.md`
6. **Present summary** for approval

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
### Changes
- [ ] `path/file.{{FILE_EXT}}` - [change]

### Success Criteria
- [ ] `{{TEST_COMMAND}} {{TEST_DIR}}/path/` passes
- [ ] [Manual verification]

---
## Risks
| Risk | Mitigation |
|------|------------|

## Open Questions
- [ ] [Question]
```

## Before Planning

Consider running first:
- `/overview` — orientation
- `/schema` — if data model changes are involved
- `/impact` — blast radius of proposed changes

## Key Patterns to Respect

*Loaded from `.claude/context/project.md` — see Architecture Patterns and Core Domains sections.*
