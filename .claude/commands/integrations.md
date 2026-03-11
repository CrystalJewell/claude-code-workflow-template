# External Integrations

Map connections to external services.

## Process

1. **Find integration code** (parallel):
   ```
   Grep: pattern="{{INTEGRATION_GREP_PATTERN}}" type="{{FILE_EXT}}"
   Grep: pattern="HTTPoison|Finch|Req|axios|requests\.|httpx" type="{{FILE_EXT}}"
   ```
2. **Check config**: Environment variable usage, config files
3. **Find API clients**: Custom wrapper modules/classes
4. **Identify webhooks**: Incoming external calls
5. **Map data flow**: What data goes where

## Output Format

```markdown
## External Integrations: {{PROJECT_NAME}}

### [Service Name]
**Purpose**: [what it does]
**Config**: [where keys/config live]
**Key Modules**: 
- `[Module]` — [role]

**Operations**:
| Operation | Function / Method | Webhook (if any) |
|-----------|------------------|-----------------|
| [action] | `fn/arity` | `event.name` |

**Webhook Handler**: `[path or handler]`

---
[repeat for each service]

### Environment Variables Required
| Service | Variables |
|---------|-----------|
| [Service] | `SERVICE_API_KEY`, `SERVICE_WEBHOOK_SECRET` |

### Integration Health Checks
| Service | Method | Timeout |
|---------|--------|---------|
| [Service] | [how to verify] | Ns |
```
