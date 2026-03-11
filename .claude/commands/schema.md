# Schema & Data Model Analysis

Understand the data model and identify query performance issues.

## Usage

`/schema [entity name]` — Specific model/schema
`/schema` — Full data model overview

## Process

1. **Find models**: `Glob: {{SCHEMA_DIR}}/**/*.{{FILE_EXT}}`
2. **Map relationships**: Parse association declarations for this stack:
   `{{ASSOCIATION_PATTERN}}`
3. **Check migrations**: `Glob: {{MIGRATIONS_DIR}}/*.{{MIGRATION_EXT}}`
4. **Analyze queries** (parallel):
   ```
   Grep: pattern="{{EAGER_LOAD_PATTERN}}" type="{{FILE_EXT}}"    # Eager loads / preloads
   Grep: pattern="{{QUERY_CALL_PATTERN}}" type="{{FILE_EXT}}"    # Query execution calls
   Grep: pattern="{{CHAINED_WHERE_PATTERN}}" type="{{FILE_EXT}}" # Chained filters
   ```
5. **Find indexes**: Check migrations for index creation
6. **Identify performance patterns**

## Output Format

```markdown
## Schema Analysis: [Name or "Full Model"]

### Tables & Relationships
```
users
├── has_many: orders
└── has_one: profile

orders
├── belongs_to: user
└── has_many: line_items
```

### Model Details: [Name]
| Field | Type | Notes |
|-------|------|-------|
| `name` | string | required |
| `metadata` | jsonb/dict | flexible attrs |
| `deleted_at` | datetime | soft delete (if applicable) |

### Indexes
| Table | Index | Columns |
|-------|-------|---------|
| [table] | [index_name] | [column(s)] |

### Query Patterns Found

#### Eager Load Analysis
| Location | Loads | Potential Issue |
|----------|-------|-----------------|
| `{{LIB_DIR}}/feature.{{FILE_EXT}}:45` | `[assoc1, assoc2]` | ✓ OK |

#### N+1 Query Risks
| File | Line | Pattern | Fix |
|------|------|---------|-----|
| `{{WEB_DIR}}/handler.{{FILE_EXT}}:67` | Loop + fetch | Eager load in initial query |

#### Missing Index Candidates
| Query Location | Filter Column | Suggestion |
|----------------|---------------|------------|

### Soft Delete Patterns
Tables using `deleted_at` (if applicable): [list]
- Ensure all queries filter: `{{SOFT_DELETE_FILTER_PATTERN}}`
```

## Query Anti-Patterns to Flag

1. **N+1 Queries** — Loop with individual fetches
2. **Missing Eager Loads** — Accessing associations without preloading
3. **Unbounded Queries** — Fetch-all without limit
4. **Missing Indexes** — Frequent filters on non-indexed columns
5. **Over-Fetching** — Loading unused associations
6. **Nested Transactions** — Transactions inside transactions
