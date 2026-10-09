---
name: setup-project
description: Use when starting a new engagement on this project, or when project structure has changed significantly — auto-discovers the stack, generates .claude/context/project.md, and substitutes {{PLACEHOLDER}} values across all skill files. Run this first, before any other skill.
disable-model-invocation: true
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
| `LINT_COMMAND` | `mix credo --strict` / `npm run lint` / `ruff check .` |
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
- Lint: `mix credo --strict`
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

Then append the Search Tools, Quality Gates, UI, Accepted Decisions, and Approval Tiers sections from `.claude/context/project.md.template`. Phases 7 and 8 fill them in.

### Phase 5: Rewrite All Templates

Do a targeted find-replace pass across all `.claude/` files (skills, agents, context), substituting `{{PLACEHOLDER}}` values from `project.md`. Key substitutions:

| Template Variable | Resolves To |
|------------------|-------------|
| `{{PROJECT_NAME}}` | e.g. `MyApp` |
| `{{TEST_COMMAND}}` | e.g. `mix test` |
| `{{LINT_COMMAND}}` | e.g. `mix credo --strict` |
| `{{LIB_DIR}}` | e.g. `lib/myapp/` |
| `{{SCHEMA_DIR}}` | e.g. `lib/myapp_schema/` |
| `{{TEST_DIR}}` | e.g. `test/` |
| `{{MODULE_PREFIX}}` | e.g. `MyApp` |
| `{{WEB_MODULE_PREFIX}}` | e.g. `MyAppWeb` |
| `{{WORKERS_DIR}}` | e.g. `lib/myapp/workers/` |
| `{{SEARCH_TOOLS}}` | `Grep, Glob`, or the project's own search tools |
| `{{UI_GLOBS}}` | e.g. `**/*.html`, `assets/**` |
| `{{DESIGN_TOKENS_PATHS}}` | e.g. `assets/tailwind.config.js` |
| `{{DECISIONS_PATHS}}` | e.g. `.claude/context/decisions.md` |
| `{{PROTECTED_AREAS}}` | e.g. `payments, authentication` |
| `{{LEGACY_PATTERNS}}` | the list recorded in Phase 7 |

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

### Phase 7: Quality Gates

Detect what this stack can check, and record it so the quality-gate skill can run it. Never assume a tool exists.

1. Detect each capability, and mark the ones the stack lacks as absent:

   | Capability | Look for |
   |------------|----------|
   | Linter with per-file counts | credo, eslint, ruff, rubocop, golangci-lint |
   | Type checker | dialyzer, tsc, mypy |
   | Security scanner | sobelow, bandit |
   | Formatter | mix format, prettier, black, gofmt |
   | Tests | the test command from Phase 2 |
   | Regression baseline | a checked-in file or command that fails when issue counts rise |
   | Suppression syntax | the stack's inline disable comments |

2. Copy `.claude/context/quality-gate.conf.template` to `.claude/context/quality-gate.conf` and fill it in. Start from the Quality Gate block for the stack in `.claude/context/framework-notes.md`. For a linter with no ready-made adapter in `.claude/scripts/adapters/`, write a small one that prints `<path><TAB><count>` and fails on empty output.
3. Run `.claude/scripts/quality-gate --quick`. Every adapter must produce counts, not an error. Fix the config until it does. Commit the lint snapshot it creates and never gitignore it, because every checkout shares that floor.
4. Ask the user for `{{LEGACY_PATTERNS}}` as `regex => replacement` pairs: anti-patterns this project wants removed from any touched file. Write them to the conf and to the Legacy Patterns section of `project.md`.
5. Resolve `{{SEARCH_TOOLS}}`: `Grep, Glob` by default. If the user says search is routed through other tools, use their tool names.
6. Ask for `{{UI_GLOBS}}` and `{{DESIGN_TOKENS_PATHS}}`. Leave both empty for a project with no UI.
7. Fill the Quality Gates table in `project.md`, with absent capabilities marked absent.

### Phase 8: Approval Tiers and Accepted Decisions

1. Show the default Approval Tiers table from `project.md` and ask what to change. Ask specifically for `{{PROTECTED_AREAS}}`: parts of this codebase where any change needs the user's approval, such as payments or authentication.
2. Ask where settled decisions are recorded for this project. The default is `.claude/context/decisions.md`. Record the answer as `{{DECISIONS_PATHS}}`. Copy no entries across, since the user adds them over time.
3. Place the policy block, a compact copy of the Approval Tiers table plus the whole-file rule ("touching a file means fixing everything the gate reports in that whole file"), so agents outside this tool see it too:
   Decide the file here, in this order, using the same `git check-ignore` test as Phase 9. The choice stands even if Phase 9 is skipped:
   1. Personal (gitignored) setup: append the block to `.claude/CLAUDE.md`, creating it if absent. Never write it to a tracked `AGENTS.md` or root `CLAUDE.md`.
   2. Otherwise, if the project has an `AGENTS.md`: append the block there as self-contained text with no `@` imports. Then make sure `CLAUDE.md` contains the line `@AGENTS.md`: add the line when `CLAUDE.md` exists without it, and create `CLAUDE.md` holding only that line when the file is missing. Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists.
   3. Otherwise: append the block to the project `CLAUDE.md`.

   Keep the block near 15 lines, because loaded instructions share one size budget. Check the file's current length before adding to it.
4. Re-run the Phase 5 substitution, skipping this skill's own file, for the variables resolved in Phases 7 and 8: `{{SEARCH_TOOLS}}`, `{{UI_GLOBS}}`, `{{DESIGN_TOKENS_PATHS}}`, `{{DECISIONS_PATHS}}`, `{{PROTECTED_AREAS}}`, `{{LEGACY_PATTERNS}}`. Their values did not exist during Phase 5, so the agents and skills still hold the literal placeholders.
   Then run `grep -rn '{{' .claude/agents .claude/skills --exclude-dir=setup-project`. It must print nothing, because this skill's own examples are the only placeholders meant to survive.

### Phase 9: Load Context Into Sessions

Files in `.claude/context/` are not loaded automatically. Skills and agents read them on demand, but an `@import` makes `project.md` part of every session. It costs a few hundred tokens per session, so offer it and let the user choose.

1. Check whether the import already exists in any of the files below. If so, skip this phase.
2. Check whether the setup is shared or personal:
   ```bash
   git check-ignore -q .claude/context/project.md && echo personal || echo shared
   ```
3. Offer only the options that fit, with the recommended one first. Imports resolve relative to the file that contains them, so the path differs per option:

   | Setup | Target file | Line to add |
   |-------|-------------|-------------|
   | Shared (tracked in git) | `CLAUDE.md` at the project root | `@.claude/context/project.md` |
   | Personal (gitignored), a `.claude/CLAUDE.md` exists or the user prefers it | `.claude/CLAUDE.md` | `@context/project.md` |
   | Personal (gitignored), otherwise | `CLAUDE.local.md` at the project root | `@.claude/context/project.md` |

   When `.claude/` is gitignored, never write the import to the shared root `CLAUDE.md`. Teammates would receive an import that points at a file they don't have.
4. When Phase 8 placed the policy in `.claude/CLAUDE.md`, reuse that file for the personal import. Create the target file if it doesn't exist, append the line, and show the user what changed. Skip this phase if the user declines; the Phase 8 policy placement stands.

### Phase 10: Optional Enforcement Hook

Offer it, and default to no. The hook runs `quality-gate --quick` when Claude finishes responding, and sends the report back so Claude keeps working while the gate fails. It runs once per distinct working-tree state.

If the user accepts:
1. Put the hook in `.claude/settings.local.json`, which stays personal, unless the user chooses the shared `.claude/settings.json`. Merge into any existing file and never overwrite it. Write the command with the literal text `${CLAUDE_PROJECT_DIR}`, never expanded to an absolute path, because the harness expands it at run time.
   ```json
   {
     "hooks": {
       "Stop": [
         {
           "hooks": [
             { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/quality-gate-stop.sh", "timeout": 120 }
           ]
         }
       ]
     }
   }
   ```
2. If `.claude/settings.local.json` was created by hand, confirm it is gitignored.
3. Show the diff and list exactly what was added, so the user can remove it.

### Phase 11: Final Report

```
## Setup Complete: {{PROJECT_NAME}}

**Files updated**: N
**Context generated**: `.claude/context/project.md`
**Context loaded via**: `@import` in [file] (or "not imported")
**Quality gate**: `.claude/context/quality-gate.conf` (N checks configured, M absent)
**Policy placed in**: [file]
**Enforcement hook**: on (settings file) / off
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

