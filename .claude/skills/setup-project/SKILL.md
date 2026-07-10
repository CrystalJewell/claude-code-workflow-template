---
name: setup-project
description: Use when starting a new engagement on this project, or when project structure has changed significantly — auto-discovers the stack, generates .claude/context/project.md, and substitutes {{PLACEHOLDER}} values across all skill files. Run this first, before any other skill.
---

# Setup Project

Initialize all Claude Code templates for this project. Run once when starting a new engagement.

## When to Use

- First time working in this project with the Claude Code skill workflow
- Project structure changed significantly since the last run
- `.claude/context/project.md` is missing or stale

## Process

### Phase 1: Auto-Discovery

Run these in parallel to understand the project:

```bash
# Language / framework detection
ls mix.exs package.json pyproject.toml Gemfile go.mod Cargo.toml 2>/dev/null
cat mix.exs 2>/dev/null | head -40
cat package.json 2>/dev/null | head -60
cat pyproject.toml 2>/dev/null | head -40

# Directory structure
find . -maxdepth 3 -type d \
  ! -path '*/.git/*' ! -path '*/node_modules/*' \
  ! -path '*/_build/*' ! -path '*/deps/*' \
  ! -path '*/.elixir_ls/*' ! -path '*/__pycache__/*' \
  | sort

# Existing config files
ls -la .formatter.exs .credo.exs .eslintrc* .pylintrc setup.cfg 2>/dev/null
cat config/dev.exs 2>/dev/null | grep -E "database|repo|adapter" | head -10
cat config/config.exs 2>/dev/null | grep -E "oban|sidekiq|celery|bull|queue" | head -10

# External service signals
grep -r "stripe\|Stripe" lib/ src/ app/ --include="*.ex" --include="*.js" \
  --include="*.ts" --include="*.py" -l 2>/dev/null | head -5
grep -r "discord\|Discord" lib/ src/ app/ -l \
  --include="*.ex" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | head -5
grep -r "aws\|AWS\|s3\|S3" lib/ src/ app/ -l \
  --include="*.ex" --include="*.js" --include="*.ts" --include="*.py" 2>/dev/null | head -5

# Test setup
ls test/ tests/ spec/ __tests__/ 2>/dev/null
cat mix.exs 2>/dev/null | grep -E "test|check"
cat package.json 2>/dev/null | grep -A2 '"scripts"'
```

### Phase 2: Build Discovery Summary

From the above, determine:

| Variable | Detected Value |
|----------|---------------|
| `PROJECT_NAME` | (from mix.exs app name, package.json name, etc.) |
| `LANGUAGE` | elixir / javascript / typescript / python / go / rust |
| `FRAMEWORK` | phoenix / nextjs / rails / django / fastapi / none |
| `TEST_COMMAND` | `mix test` / `npm test` / `pytest` / `go test ./...` |
| `LINT_COMMAND` | `mix checks` / `npm run lint` / `ruff check .` |
| `FORMAT_COMMAND` | `mix format` / `prettier` / `black` |
| `LIB_DIR` | `lib/` / `src/` / `app/` |
| `TEST_DIR` | `test/` / `tests/` / `spec/` |
| `SCHEMA_DIR` | Detected schema/model location |
| `DB_TECHNOLOGY` | postgres / mysql / sqlite / mongodb / none |
| `BACKGROUND_JOBS` | oban / sidekiq / celery / bullmq / none |
| `MODULE_PREFIX` | (e.g. `MyApp` for Elixir, class naming convention for others) |
| `WEB_MODULE_PREFIX` | (e.g. `MyAppWeb` for Phoenix) |

### Phase 3: Present and Confirm

Present a formatted summary of detected values. Ask the user to confirm or correct each one, and fill in anything that couldn't be auto-detected:

```
## Detected Project Configuration

**Project**: MyApp (Elixir/Phoenix)
**Language**: Elixir | **Framework**: Phoenix + LiveView
**Module prefix**: MyApp | **Web module**: MyAppWeb

**Commands**:
- Test: `mix test`
- Lint: `mix checks`
- Format: `mix format`

**Directory layout**:
- Business logic: `lib/myapp/`
- Web layer: `lib/myapp_web/`
- Schemas: `lib/myapp_schema/` ← confirm or correct?
- Tests: `test/`

**Database**: PostgreSQL
**Background jobs**: Oban

**Detected integrations**: Stripe, Discord, AWS S3

**Missing — please provide**:
1. Project description (1-2 sentences for context in skills)
2. Core domain areas (e.g. "Users, Heroes, Tables, Payments")
3. Any integrations not detected above?

Does this look correct? Provide any corrections and I'll proceed.
```

### Phase 4: Generate `context/project.md`

Write the confirmed values to `.claude/context/project.md`:

```markdown
# Project: {{PROJECT_NAME}}
**Generated**: {{DATE}} | **Language**: {{LANGUAGE}} | **Framework**: {{FRAMEWORK}}

## Description
{{PROJECT_DESCRIPTION}}

## Commands
| Purpose | Command |
|---------|---------|
| Test | `{{TEST_COMMAND}}` |
| Lint | `{{LINT_COMMAND}}` |
| Format | `{{FORMAT_COMMAND}}` |

## Module Conventions
| Role | Prefix |
|------|--------|
| Business logic | `{{MODULE_PREFIX}}` |
| Web layer | `{{WEB_MODULE_PREFIX}}` |
| Schemas/Models | `{{SCHEMA_MODULE_PREFIX}}` |

## Directory Layout
| Purpose | Path |
|---------|------|
| Business logic | `{{LIB_DIR}}` |
| Web layer | `{{WEB_DIR}}` |
| Schemas/Models | `{{SCHEMA_DIR}}` |
| Tests | `{{TEST_DIR}}` |
| Workers/Jobs | `{{WORKERS_DIR}}` |
| Config | `{{CONFIG_DIR}}` |
| Migrations | `{{MIGRATIONS_DIR}}` |

## Data Layer
- **Database**: {{DB_TECHNOLOGY}}
- **ORM/Query**: {{ORM}}
- **Background jobs**: {{BACKGROUND_JOBS}}
- **Caching**: {{CACHE_TECHNOLOGY}}
- **Real-time**: {{REALTIME_TECHNOLOGY}}

## Core Domains
{{DOMAIN_LIST}}

## External Integrations
{{INTEGRATION_LIST}}

## Architecture Patterns
{{ARCHITECTURE_NOTES}}
```

### Phase 5: Rewrite All Templates

Do a targeted find-replace pass across all `.claude/` files (skills, agents, context), substituting `{{PLACEHOLDER}}` values from `project.md`. Key substitutions:

| Template Variable | Resolves To |
|------------------|-------------|
| `{{PROJECT_NAME}}` | e.g. `MyApp` |
| `{{TEST_COMMAND}}` | e.g. `mix test` |
| `{{LINT_COMMAND}}` | e.g. `mix checks` |
| `{{LIB_DIR}}` | e.g. `lib/myapp/` |
| `{{SCHEMA_DIR}}` | e.g. `lib/myapp_schema/` |
| `{{TEST_DIR}}` | e.g. `test/` |
| `{{MODULE_PREFIX}}` | e.g. `MyApp` |
| `{{WEB_MODULE_PREFIX}}` | e.g. `MyAppWeb` |
| `{{WORKERS_DIR}}` | e.g. `lib/myapp/workers/` |

### Phase 6: Scaffold Domain Research Skills

For each confirmed core domain, offer to generate a domain-specific research skill:

```
You listed these core domains: Users, Orders, Inventory

Would you like me to generate research-users, research-orders,
research-inventory skills? (Modeled on the generic research-codebase
skill but pre-scoped to each domain's files and patterns)
```

If yes, generate each one to `.claude/skills/research-{{domain}}/SKILL.md`, using the same frontmatter shape, Process, and Research Doc Template as the `research-codebase` skill, with:
- `description` naming the specific domain (e.g. "Use for open-ended research into the Users domain specifically...")
- Search Reference patterns scoped to that domain's known files/modules

### Phase 7: Final Report

```
## Setup Complete: {{PROJECT_NAME}}

**Files updated**: N
**Context generated**: `.claude/context/project.md`
**Domain skills created**: research-x, research-y (if applicable)

Suggested first steps:
1. overview skill — orientation pass
2. schema skill — understand the data model
3. routes skill — map the endpoints

Re-run the setup-project skill anytime the project structure changes significantly.
```

## Re-run Behavior

If `.claude/context/project.md` already exists:
1. Read it as the current baseline
2. Re-run discovery
3. Present only the **diffs** — what changed or couldn't be confirmed
4. Ask to apply changes selectively or wholesale
5. Never overwrite project.md without confirmation

