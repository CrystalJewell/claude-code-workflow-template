# Impact Analysis

Understand the blast radius before modifying code.

## Usage

`/impact <module, function, class, or file>`

## Process

1. **Identify target**: Parse the module/function/file to analyze
2. **Find callers** (parallel):
   ```
   Grep: pattern="TargetName\." type="{{FILE_EXT}}"    # Direct usage
   Grep: pattern="import.*TargetName" type="{{FILE_EXT}}"   # Imports
   Grep: pattern="from.*TargetName" type="{{FILE_EXT}}"     # Named imports
   ```
3. **Find dependents**: What breaks if this changes?
4. **Map test coverage**: `Grep: pattern="TargetName" path="{{TEST_DIR}}"`
5. **Check for pub/sub**: Does it broadcast? Who subscribes?
6. **Assess risk level**

## Output Format

```markdown
## Impact Analysis: [Target]

### Direct Callers
| File | Line | Usage |
|------|------|-------|
| `{{LIB_DIR}}/feature.{{FILE_EXT}}` | 45 | `Target.function/1` |

### Dependency Chain
```
[Target]
├── Called by: Module.A, Module.B
│   └── Called by: Handler.X
└── Calls: Module.C, Module.D
```

### Test Coverage
| Test File | References |
|-----------|------------|
| `{{TEST_DIR}}/feature_test.{{TEST_EXT}}` | 12 |

### Real-time Impact (if applicable)
- **Broadcasts**: `topic:event` 
- **Subscribers**: [handlers]

### Risk Assessment
| Change Type | Risk | Reason |
|-------------|------|--------|
| Rename | High | N callers across M modules |
| Change return type | Medium | K pattern matches depend on shape |
| Add parameter w/ default | Low | Backwards compatible |

### Recommended Approach
1. [suggestion based on analysis]
```
