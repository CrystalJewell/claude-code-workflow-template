# Claude Code Skills

Skills for common development workflows.

## Setup

| Skill | Description |
|-------|-------------|
| `setup-project` | **Run first.** Auto-discover stack and initialize all templates |

## Workflow Skills

| Skill | Description |
|-------|-------------|
| `create-plan` | Create a structured implementation plan |
| `implement-plan` | Execute a plan phase by phase |
| `validate-plan` | Verify implementation matches plan |
| `quality-gate` | Check every touched file against the project's linters, baselines, and legacy patterns |
| `commit` | Generate structured commit messages |
| `describe-pr` | Generate PR descriptions |

## Research Skills

| Skill | Description |
|-------|-------------|
| `research-codebase` | Deep-dive any feature or question |
| `research-<domain>` | Generated per-domain skills (after `setup-project`) |

## Context Skills

| Skill | Description |
|-------|-------------|
| `overview` | Architecture and domain map |
| `impact` | Blast radius before modifying code |
| `schema` | Data model + query performance analysis |
| `routes` | Map endpoints to handlers |
| `integrations` | External service connections |
| `glossary` | Domain terminology reference |
| `recent` | Recent git changes in an area |

## Review Agents

| Agent | Description |
|-------|-------------|
| `plan-auditor` | Audit a plan from a fresh context before it is executed |
| `visual-guard` | Audit changed UI files against design tokens before commit |

## Debugging Skills

| Skill | Description |
|-------|-------------|
| `debug-codebase` | Systematic issue investigation |

## Session Skills

| Skill | Description |
|-------|-------------|
| `create-handoff` | Document session state for continuity |
| `resume-handoff` | Resume from a previous handoff |

## Recommended Workflow

```
setup-project   → one-time init
overview        → orient
schema          → understand data
impact          → before changes
create-plan     → design
plan-auditor    → audit the plan (agent)
implement-plan  → build
quality-gate   → check touched files
visual-guard    → audit UI changes (agent, UI projects)
validate-plan   → verify
commit          → save
describe-pr     → ship
create-handoff  → end session
```

