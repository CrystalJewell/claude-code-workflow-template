# Project Overview

Bird's eye view of architecture without deep-diving.

## Process

1. **Scan structure** (parallel) — adjust globs to match `project.md` layout:
   ```
   Glob: {{LIB_DIR}}/*.{{FILE_EXT}}          # Core business logic
   Glob: {{SCHEMA_DIR}}/*.{{FILE_EXT}}        # Data models
   Glob: {{WORKERS_DIR}}/*.{{FILE_EXT}}       # Background workers
   Grep: pattern="{{WORKER_SEARCH_PATTERN}}" type="{{FILE_EXT}}"
   ```
2. **Map domains**: Identify core business areas from module/class names
3. **Find integrations**: `Grep: pattern="{{INTEGRATION_GREP_PATTERN}}" type="{{FILE_EXT}}"`
4. **Check entry points**: Router/routes file, scheduled jobs, pub/sub topics
5. **Present overview**

## Output Format

```markdown
## Project Overview: {{PROJECT_NAME}}

### Core Domains
| Domain | Module / Service | Schema(s) | Purpose |
|--------|-----------------|-----------|---------|
| [Domain] | `{{MODULE_PREFIX}}.[Name]` | [Model] | [purpose] |

### Architecture Patterns
- **Data**: {{DB_TECHNOLOGY}}, {{ORM}}
- **Web**: {{FRAMEWORK}} — [component model]
- **Background**: {{BACKGROUND_JOBS}}
- **Caching**: {{CACHE_TECHNOLOGY}}
- **Real-time**: {{REALTIME_TECHNOLOGY}}

### External Integrations
| Service | Purpose | Key Module |
|---------|---------|------------|
| [Service] | [purpose] | `[Module]` |

### Entry Points
**Routes**: [key route groups]
**Workers**: [scheduled/triggered jobs]
**Real-time**: [pub/sub channels or websocket rooms]

### Key Directories
```
{{LIB_DIR}}       # Business logic
{{SCHEMA_DIR}}    # Data models
{{WEB_DIR}}       # Web layer
{{WORKERS_DIR}}   # Background jobs
{{TEST_DIR}}      # Tests
```
```

## When to Use

- Starting a new session or engagement
- Before major architectural changes
- Quick orientation after time away
