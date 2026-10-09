# Price Parsing Implementation Plan

**Spec**: none for this fixture

### Task 1: parse_price

**Files:**
- Create: `src/prices.py`
- Test: `tests/test_prices.py`

- [ ] **Step 1: Write the failing tests**

```python
import pytest

from src.prices import parse_price


def test_parses_plain_amount():
    assert parse_price("12.50") == 1250


def test_ignores_a_leading_dollar_sign():
    assert parse_price("$3") == 300


def test_rejects_an_empty_price():
    with pytest.raises(ValueError, match="empty price"):
        parse_price("  ")
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

- [ ] **Step 3: Run the quality gate**

Run: `.claude/scripts/quality-gate --plan docs/plan.md`
Expected: no FAIL and no NEEDS-APPROVAL

- [ ] **Step 4: Commit**

```bash
git add src/prices.py tests/test_prices.py
git commit -m "feat: parse prices"
```

### Task 2: Whole-file cleanup

**Files:**
- Modify: `src/prices.py`
- Modify: `tests/test_prices.py`

- [ ] **Step 1: Fix everything the quality gate reports in both files, whole file and not just the changed lines**

Run: `.claude/scripts/quality-gate --plan docs/plan.md`
Expected: no FAIL and no NEEDS-APPROVAL
