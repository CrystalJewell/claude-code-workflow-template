---
name: quality-gate
description: Use after finishing a task or before committing, to check every touched file against the project's own linters, baselines, suppression rules, and legacy-pattern list. Checks whole files, not just the diff, and reports PASS, FAIL, or NEEDS-APPROVAL per check.
allowed-tools: Bash(.claude/scripts/quality-gate *) Read
---

# Quality Gate

Deterministic check of every file the branch touches. A script decides, not the model, so the result does not depend on remembering a rule.

## When to Use

- After each task in an implementation plan
- Before a commit or a pull request
- When the validate-plan skill asks for it

## Process

1. Run the gate from the project root:
   ```bash
   .claude/scripts/quality-gate --plan <path-to-plan>
   ```
   Drop `--plan` when there is no plan. Add `--quick` for a fast pass that skips tests, the type checker, and the security scanner.
2. Read the table. Each row has a status and a tier:

   | Status | Meaning |
   |--------|---------|
   | PASS | Check satisfied |
   | FAIL | Fix it. Exit code 1 |
   | NEEDS-APPROVAL | Stop and ask the user. Exit code 2 |
   | INFO | Report only. The controller classifies it |
   | SKIP | Not configured for this project, so nothing was checked |

   Exit code 64 is a usage error: an unknown option, an option missing its value, or a working directory below the repository root. The gate prints no table; fix the call and rerun.

3. Act on the tier in the row. A clean gate means keep working without pausing. See Approval Tiers in project.md once set up.

   | Tier | What to do |
   |------|-----------|
   | `none` | Nothing to act on. The row is a SKIP or an INFO note |
   | `never` | Fix it. A regression is never deferred or waived |
   | `decide-and-log` | Fix it and log the choice without pausing. Deferring a file needs the user, see Deferrals and Approvals |
   | `needs-approval` | Stop and ask the user before continuing |
   | `controller-classifies` | Report the row to the controller, who decides whether it is acceptable |

## What It Checks

All checks cover the whole of each touched file, never only the changed lines.

- **lint / typecheck**: every touched file must have zero remaining issues. Only a file on the approved deferral list is exempt.
- **regression**: the project's baseline never increases. Without a baseline command, the project-wide lint total is compared with a snapshot, and the first run creates it. Commit the snapshot file and never gitignore it, because it is the shared floor. Bank a lower total with `--update-snapshot`.
- **suppressions**: an added suppression line needs a recorded approval before it passes.
- **legacy-patterns**: every touched file is scanned in full for the project's legacy patterns. The row is `decide-and-log` because pre-existing occurrences in a touched file are reported too; an occurrence on a line this branch added is `never`.
- **format, security, tests**: the project's own commands.
- **outside-plan**: touched files that the plan's `**Files:**` blocks do not name.

## Output Edge Cases

- A linter that crashes fails the regression row with `linter failed; project total not measured`, and the snapshot is never written.
- A base ref that does not resolve adds an INFO row, `base-ref: base <ref> not found; committed changes not checked`. Only uncommitted and untracked changes were checked.

## Scope Closure Rule

The set of touched files grows by one hop at most. Fixing a touched file may pull in a new file, and that file then gets the whole-file rule as well. If fixing that new file would pull in yet another new file, stop. Bring the user the choice between fixing it now and adding it to the deferral list.

## Deferrals and Approvals

Both files are written only after the user approves.

- Deferral list, default `.claude/thoughts/deferrals.md`: any line containing a file's path exempts that file from the lint and typecheck rows. Record the remaining issue count and the ticket.
- Approvals file, default `.claude/thoughts/gate-approvals.md`: one line per approved suppression.
  ```
  approved-suppression: <path> :: <the added line, trimmed>
  ```
  Put the written justification beside it.

## Configuration

The gate reads `.claude/context/quality-gate.conf`, written by the setup-project skill. One `key=value` per line. Repeatable keys use `key+=value`. A value may contain `=`.

| Key | Meaning |
|-----|---------|
| `base_ref` | Branch to compare against. Default `main` |
| `source_pattern` | Regex a path must match to be checked. Default every path outside `.claude/` |
| `lint_counts_cmd` | Prints `<path><TAB><count>` per file with issues, for the whole project |
| `typecheck_counts_cmd` | Same output, for the type checker |
| `baseline_cmd` | Exits non-zero when a regression baseline went up |
| `snapshot_file` | Where the lint total is kept. Default `.claude/context/lint-total.snapshot` |
| `suppression_pattern` | Regex for a suppression comment. Repeatable |
| `legacy_pattern` | `regex => replacement`, split at the last ` => `, so the regex may contain ` => ` but the replacement may not. Repeatable |
| `format_cmd` | Formatter check command |
| `security_cmd` | Security scanner command |
| `test_cmd` | Test command |
| `plan_files_cmd` | Prints the plan's file list for a plan path. Default reads `**Files:**` blocks |
| `deferral_list` | Path of the deferral list |
| `approvals_file` | Path of the approvals file |

Options: `--config`, `--plan`, `--base`, `--quick`, `--update-snapshot`.

## Adapters

An adapter turns a linter's output into `<path><TAB><count>` lines with repo-relative paths. It must exit 0 whenever it produced counts, even if the linter itself exits non-zero for findings. Ready-made jq filters live in `.claude/scripts/adapters/`. Run them as `jq -s -r -f`, which makes them fail on empty input. A linter that crashed and printed nothing then fails the gate instead of reading as clean. When passing `--arg root`, the root must be the physical path, `"$(pwd -P)/"`, because a linter reports real paths and a symlinked `$PWD` would never match.

Some linters change their results when given a path. Run them on the whole project and filter by file in the adapter.
