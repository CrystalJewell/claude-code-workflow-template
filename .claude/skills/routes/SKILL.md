---
name: routes
description: Use to map all web/API routes to their handlers and auth layers, including the routing-table entry for incoming webhook endpoints. For what a webhook triggers on the receiving/external-service side, use the integrations skill.
---

# Routes & Endpoints

Map all routes to their handlers.

## When to Use

- Need to understand what endpoints exist and which handler/auth layer serves each

## Process

1. **Find route file(s)**: Common locations by framework:
   - Phoenix: `lib/{{WEB_DIR}}/router.ex`
   - Express/Next: `src/app/`, `pages/api/`, `routes/`
   - Django: `urls.py` files
   - FastAPI: `routers/`, main `app.py`
2. **Read route file** and map paths → handlers
3. **Identify auth layers**: middleware, pipelines, guards
4. **Find webhook endpoints**: external-facing POST routes
5. **Check for API vs web split**

## Output Format

```markdown
## Routes Overview: {{PROJECT_NAME}}

### Auth / Middleware Layers
| Layer | Applied To | Purpose |
|-------|------------|---------|
| [middleware] | [scope] | [purpose] |

### Web Routes
| Path | Handler | Auth | Purpose |
|------|---------|------|---------|
| `/feature` | FeatureHandler | ✓ | List items |
| `/feature/:id` | FeatureHandler | ✓ | Item detail |

### API Routes
| Method | Path | Handler | Auth |
|--------|------|---------|------|
| GET | `/api/v1/feature` | FeatureHandler | API key |

### Webhooks
| Endpoint | Source | Handler |
|----------|--------|---------|
| `/webhooks/stripe` | Stripe | WebhookHandler |

### Route Groups by Feature
**Feature A**: `N` routes
**Feature B**: `M` routes
```

