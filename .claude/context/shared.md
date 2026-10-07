# Shared Context Reference

Reference for skills and agents. Values populated by the `setup-project` skill.

## Project: {{PROJECT_NAME}}

**Language**: {{LANGUAGE}} | **Framework**: {{FRAMEWORK}}

## Directory Structure

```
{{LIB_DIR}}           # Business logic / core application
{{SCHEMA_DIR}}        # Data models / schemas
{{WEB_DIR}}           # Web layer (controllers, views, LiveViews, routes)
{{WORKERS_DIR}}       # Background job workers
{{TEST_DIR}}          # Tests (mirrors application structure)
{{CONFIG_DIR}}        # Configuration files
{{MIGRATIONS_DIR}}    # Database migrations
```

## Verification Commands

```bash
{{TEST_COMMAND}}                        # Full test suite
{{TEST_COMMAND}} {{TEST_DIR}}/path/     # Specific tests
{{LINT_COMMAND}}                        # Lint + compile check
{{FORMAT_COMMAND}} --check              # Format check
```

## Module / Class Conventions

| Role | Prefix / Pattern |
|------|-----------------|
| Business logic | `{{MODULE_PREFIX}}` |
| Web layer | `{{WEB_MODULE_PREFIX}}` |
| Schemas / Models | `{{SCHEMA_MODULE_PREFIX}}` |
| Background workers | `{{WORKER_MODULE_PREFIX}}` |

## Search Patterns

| Find | Pattern |
|------|---------|
| Schema / Model | `{{SCHEMA_SEARCH_PATTERN}}` |
| Context / Service | `{{CONTEXT_SEARCH_PATTERN}}` |
| Controller / Handler | `{{CONTROLLER_SEARCH_PATTERN}}` |
| Worker / Job | `{{WORKER_SEARCH_PATTERN}}` |
| Test file | `{{TEST_FILE_PATTERN}}` |

## Core Domains

{{DOMAIN_LIST}}

## External Integrations

{{INTEGRATION_LIST}}

## Architecture Patterns

- **Data**: {{DB_TECHNOLOGY}}, {{ORM}}
- **Background**: {{BACKGROUND_JOBS}}
- **Caching**: {{CACHE_TECHNOLOGY}}
- **Real-time**: {{REALTIME_TECHNOLOGY}}

## Agent Sub-task Note

> Subagents are spawned through the Agent tool and return findings to the parent. The agent definitions in `.claude/agents/` restrict them to read/search tools.
