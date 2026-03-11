# Claude Code Commands

Slash commands for common development workflows.

## Setup

| Command | Description |
|---------|-------------|
| `/setup_project` | **Run first.** Auto-discover stack and initialize all templates |

## Workflow Commands

| Command | Description |
|---------|-------------|
| `/create_plan` | Create a structured implementation plan |
| `/implement_plan` | Execute a plan phase by phase |
| `/validate_plan` | Verify implementation matches plan |
| `/commit` | Generate structured commit messages |
| `/describe_pr` | Generate PR descriptions |

## Research Commands

| Command | Description |
|---------|-------------|
| `/research_codebase` | Deep-dive any feature or question |
| `/research_<domain>` | Generated per-domain commands (after `/setup_project`) |

## Context Commands

| Command | Description |
|---------|-------------|
| `/overview` | Architecture and domain map |
| `/impact` | Blast radius before modifying code |
| `/schema` | Data model + query performance analysis |
| `/routes` | Map endpoints to handlers |
| `/integrations` | External service connections |
| `/glossary` | Domain terminology reference |
| `/recent` | Recent git changes in an area |

## Debugging Commands

| Command | Description |
|---------|-------------|
| `/debug_codebase` | Systematic issue investigation |

## Session Commands

| Command | Description |
|---------|-------------|
| `/create_handoff` | Document session state for continuity |
| `/resume_handoff` | Resume from a previous handoff |

## Recommended Workflow

```
/setup_project   → one-time init
/overview        → orient
/schema          → understand data
/impact          → before changes
/create_plan     → design
/implement_plan  → build
/validate_plan   → verify
/commit          → save
/describe_pr     → ship
/create_handoff  → end session
```
