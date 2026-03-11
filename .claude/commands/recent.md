# Recent Changes

Git-powered analysis of what changed recently in an area.

## Usage

`/recent <path or area>` — Changes in specific area
`/recent` — Overall recent activity

## Process

1. **Get recent commits**:
   ```bash
   git log --oneline -20 [-- path]
   git log --since="1 week ago" --oneline [-- path]
   ```
2. **Analyze changes**:
   ```bash
   git diff HEAD~10..HEAD --stat [-- path]
   git log --format="%h %s" --name-only -10 [-- path]
   ```
3. **Check uncommitted work**: `git status`, `git diff`
4. **Identify patterns**: What types of changes, active areas
5. **Summarize impact**

## Output Format

```markdown
## Recent Changes: [Area or "Project-Wide"]

### Summary
- **Period**: Last 10 commits / 1 week
- **Files changed**: N
- **Key areas touched**: [list]

### Recent Commits
| Hash | Date | Summary | Files |
|------|------|---------|-------|
| `abc123` | 2d ago | Add feature X | 5 |

### Most Changed Files
| File | Changes | Recent Commits |
|------|---------|----------------|
| `{{LIB_DIR}}/feature.{{FILE_EXT}}` | 45 lines | 3 |

### Uncommitted Changes
```
[git status output if any]
```
```
