# Price Parsing Implementation Plan

**Spec**: none for this fixture

### Task 1: parse_price

**Files:**
- Create: `src/prices.py`
- Test: `tests/test_prices.py`

- [ ] **Step 1: Write the failing test**

```python
from src.prices import parse_price


def test_parses_plain_amount():
    assert parse_price("12.50") == 1250
```

- [ ] **Step 2: Implement**

```python
def parse_price(text):
    cleaned = text.strip().lstrip("$")
    if cleaned == "":
        raise ValueError("empty price")
    dollars, _, cents = cleaned.partition(".")
    return int(dollars) * 100 + int((cents + "00")[:2])
```

The existing `Product.price_cents` field in `src/models.py:14` already stores this value, so callers only need to assign the result to it.

- [ ] **Step 3: Commit**

```bash
git add src/prices.py tests/test_prices.py
git commit -m "feat: parse prices"
```
