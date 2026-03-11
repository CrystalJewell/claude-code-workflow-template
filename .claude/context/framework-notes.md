# Framework Notes Library

Used by `/setup_project` to inject framework-specific content into agents and commands.
Not a slash command — internal reference only.

---

## Elixir / Phoenix

### Variables

```
FILE_EXT=ex
TEST_EXT=exs
MIGRATION_EXT=exs
TEST_COMMAND=mix test
LINT_COMMAND=mix checks
FORMAT_COMMAND=mix format
TRANSACTION_PATTERN=Ecto\.Multi|Multi\.new
ERROR_CHAIN_PATTERN=with \{:
PUBSUB_PATTERN=PubSub\.(subscribe|broadcast)
ASYNC_PATTERN=assign_async|Task\.async
WORKER_PATTERN=use Oban\.Worker
CACHE_PATTERN=Cachex\.(get|put|fetch)
FACTORY_PATTERN=def .*_factory
MOCK_PATTERN=expect\(|stub\(
SCHEMA_SEARCH_PATTERN=defmodule.*Schema
CONTEXT_SEARCH_PATTERN=defmodule {{MODULE_PREFIX}}\.
CONTROLLER_SEARCH_PATTERN=defmodule {{WEB_MODULE_PREFIX}}.*Live|Controller
WORKER_SEARCH_PATTERN=use Oban\.Worker
QUERY_CALL_PATTERN=Repo\.(all|one|get)
EAGER_LOAD_PATTERN=preload:
CHAINED_WHERE_PATTERN=\|>.*where.*\|>.*where
ASSOCIATION_PATTERN=has_many|belongs_to|has_one
SOFT_DELETE_FILTER_PATTERN=where([x], is_nil(x.deleted_at))
INTEGRATION_GREP_PATTERN=Stripe\.|Discord\.|ExAws
```

### Analyzer Notes (inject into codebase-analyzer.md)

```
**Schemas** (`{{SCHEMA_DIR}}`): Fields, types, associations, changesets, validations
**Contexts** (`{{LIB_DIR}}`): Public API functions, Ecto queries, Ecto.Multi transactions, PubSub broadcasts
**LiveViews** (`{{WEB_DIR}}/live/`): mount/2, assigns, handle_event/3, handle_info/2, assign_async/3
**Workers** (`{{WORKERS_DIR}}`): Queue config, perform/1, retry strategy, unique constraints
```

### Pattern Notes (inject into pattern-finder.md)

```
| Ecto.Multi | `Ecto\.Multi\|Multi\.new` |
| with chains | `with \{:` |
| PubSub | `PubSub\.(subscribe\|broadcast)` |
| assign_async | `assign_async` |
| LiveView streams | `stream(\|stream_insert` |
| Oban workers | `use Oban\.Worker` |
| GenServer | `use GenServer` |
| Cachex | `Cachex\.(get\|put\|fetch)` |
| ExMachina factories | `def .*_factory` |
| Mox | `expect(\|stub(` |
```

---

## JavaScript / TypeScript (Node / Next.js / Express)

### Variables

```
FILE_EXT=ts (or js)
TEST_EXT=test.ts
MIGRATION_EXT=ts (or js)
TEST_COMMAND=npm test (or yarn test / pnpm test)
LINT_COMMAND=npm run lint
FORMAT_COMMAND=npx prettier --write .
TRANSACTION_PATTERN=BEGIN|transaction\(|prisma\.\$transaction
ERROR_CHAIN_PATTERN=\.catch\(|try \{|\.then\(
PUBSUB_PATTERN=emit\(|on\(|subscribe\(|publish\(
ASYNC_PATTERN=async |await |Promise\.
WORKER_PATTERN=Bull|BullMQ|agenda|bee-queue|new Queue
CACHE_PATTERN=redis\.(get|set)|cache\.(get|set)
FACTORY_PATTERN=factory\(|createFactory|\.build\(
MOCK_PATTERN=jest\.mock|vi\.mock|sinon\.stub
SCHEMA_SEARCH_PATTERN=model |Schema\(|@Entity|interface .* \{
CONTEXT_SEARCH_PATTERN=export (class|function|const) [A-Z].*Service
CONTROLLER_SEARCH_PATTERN=router\.(get|post|put|delete)|@Controller|export default function.*Page
WORKER_SEARCH_PATTERN=new Worker|Queue\(|process\(
QUERY_CALL_PATTERN=\.findMany\(|\.find\(|\.findOne\(|\.query\(
EAGER_LOAD_PATTERN=include:|populate\(|relations:
CHAINED_WHERE_PATTERN=\.where\(.*\.where\(
ASSOCIATION_PATTERN=hasMany|belongsTo|OneToMany|ManyToOne
SOFT_DELETE_FILTER_PATTERN=deletedAt: null|where deleted_at IS NULL
INTEGRATION_GREP_PATTERN=stripe\.|discord\.|@aws-sdk
```

### Analyzer Notes

```
**Models** (`{{SCHEMA_DIR}}`): Fields, validations, hooks, associations
**Services** (`{{LIB_DIR}}`): Business logic, external calls, data transformation
**Route handlers / Pages** (`{{WEB_DIR}}`): Request parsing, response shaping, middleware usage
**Workers** (`{{WORKERS_DIR}}`): Queue name, concurrency, retry logic, job handlers
```

---

## Python (Django / FastAPI / Flask)

### Variables

```
FILE_EXT=py
TEST_EXT=py
MIGRATION_EXT=py
TEST_COMMAND=pytest (or python -m pytest)
LINT_COMMAND=ruff check . (or flake8)
FORMAT_COMMAND=black .
TRANSACTION_PATTERN=atomic\(|transaction\.atomic|with session
ERROR_CHAIN_PATTERN=try:|except |raise
PUBSUB_PATTERN=publish\(|subscribe\(|emit\(|celery\.send_task
ASYNC_PATTERN=async def|await |asyncio\.
WORKER_PATTERN=@shared_task|@app\.task|celery|rq\.enqueue
CACHE_PATTERN=cache\.(get|set)|redis\.(get|set)
FACTORY_PATTERN=factory\.Factory|faker\.|create_batch
MOCK_PATTERN=patch\(|MagicMock\(|mocker\.
SCHEMA_SEARCH_PATTERN=class .*Model\(|class .*Schema\(|@dataclass
CONTEXT_SEARCH_PATTERN=class .*Service\(|class .*Repository\(
CONTROLLER_SEARCH_PATTERN=@router\.|@app\.(get|post|put|delete)|class .*View\(
WORKER_SEARCH_PATTERN=@shared_task|@app\.task|celery
QUERY_CALL_PATTERN=\.objects\.|session\.query\(|\.filter\(
EAGER_LOAD_PATTERN=select_related\(|prefetch_related\(|joinedload\(
CHAINED_WHERE_PATTERN=\.filter\(.*\.filter\(
ASSOCIATION_PATTERN=ForeignKey\(|ManyToMany\(|OneToOne\(|relationship\(
SOFT_DELETE_FILTER_PATTERN=deleted_at__isnull=True|filter(deleted_at=None)
INTEGRATION_GREP_PATTERN=stripe\.|discord\.|boto3
```

### Analyzer Notes

```
**Models** (`{{SCHEMA_DIR}}`): Fields, Meta options, validators, managers
**Services / Repositories** (`{{LIB_DIR}}`): Business logic, ORM queries, external service calls
**Views / Handlers** (`{{WEB_DIR}}`): Request parsing, serializers, permission checks
**Tasks / Workers** (`{{WORKERS_DIR}}`): Celery/RQ task config, retry policy, task chains
```
