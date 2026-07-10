---
name: research-codebase
description: Use for open-ended research into how an existing feature or subsystem works, without suggesting changes — spawns parallel search agents and writes findings to .claude/thoughts/research/. Not for a quick blast-radius check before changing a specific target (use the impact skill), not for a first orientation pass across the whole project (use the overview skill), and not for a git-log summary of what changed recently (use the recent skill).
---

# Research Codebase

Document and explain existing code. Do NOT suggest improvements.

## When to Use

- Need to understand how a feature or subsystem currently works, in depth
- Before planning a change that touches unfamiliar code

## Process

1. **Clarify**: If no question provided, ask what to research
2. **Read mentioned files first** before spawning tasks
3. **Decompose** question into searchable components
4. **Spawn parallel research** via Task tool (`subagent_type=Explore`)
5. **Synthesize** findings, prioritizing live code over cached context
6. **Write** research doc to `.claude/thoughts/research/YYYY-MM-DD-topic.md`
7. **Present** concise summary

## Research Doc Template

```markdown
# [Topic] Research
**Date**: YYYY-MM-DD | **Status**: Complete

## Overview
[2-3 sentences]

## Key Files
- `{{LIB_DIR}}/file.{{FILE_EXT}}` - [description]

## Data Flow
[How data moves through system]

## Key Functions
- `Module.function/arity` at file:line — [purpose]

## Patterns Used
[Transaction patterns, error chains, pub/sub, etc.]
```

## Search Reference

| Looking for | Pattern |
|-------------|---------|
| Data model | `{{SCHEMA_SEARCH_PATTERN}}` |
| Business logic | `{{CONTEXT_SEARCH_PATTERN}}` |
| Handler | `{{CONTROLLER_SEARCH_PATTERN}}` |
| Worker | `{{WORKER_SEARCH_PATTERN}}` |
| Transactions | `{{TRANSACTION_PATTERN}}` |

