# Domain Glossary

Understand project-specific terminology.

## Process

1. **Scan core models**: Extract domain entities from schema/model names and fields
2. **Check documentation**: `Glob: **/*.md` for existing docs
3. **Analyze service/context modules**: Function names reveal domain language
4. **Find enums/constants**: Status values, types, categories
5. **Build glossary** from code evidence

## Output Format

```markdown
## {{PROJECT_NAME}} Domain Glossary

### Core Entities

**[Entity Name]**
[1-sentence description]
- Model: `{{SCHEMA_MODULE_PREFIX}}.[Name]` (or file path)
- Key fields: [list]
- States: [if applicable]

### Status Values

**[Model] Status**:
- `value` — [meaning]

### Business Rules

- **[Rule]**: [explanation]

### Abbreviations

| Abbrev | Meaning |
|--------|---------|
| [abbrev] | [meaning] |
```

## Persisting the Glossary

When new domain terms are discovered, add to `.claude/thoughts/glossary.md` for persistence across sessions.
