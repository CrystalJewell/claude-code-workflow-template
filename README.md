# Claude Code Starter Kit

Drop into any project. Run one skill. Start working.

## Setup

```bash
# 1. Copy .claude/ into your project root
cp -r /path/to/this-repo/.claude /path/to/your-project/

# 2. Open Claude Code in your project
# 3. Run the setup skill
/setup-project
```

The setup skill will:
- Auto-discover your tech stack, framework, directory structure, and tooling
- Ask you to confirm and fill in any gaps
- Rewrite all templates with project-specific context
- Generate `.claude/context/project.md` as the persistent source of truth
- Detect your linter, type checker, formatter, and test runner, and write them to `.claude/context/quality-gate.conf`
- Record your approval tiers and where your settled decisions live
- Offer to `@import` that file so every session loads it: into the project `CLAUDE.md` when this setup is shared, or into `.claude/CLAUDE.md` / `CLAUDE.local.md` when `.claude/` is gitignored and personal

## After Setup

All skills become project-aware. Start with orientation:

```
overview     → Architecture + domains
schema       → Data model
routes       → Endpoints
integrations → External services
```

## Skills Reference

| Skill | Purpose |
|-------|---------|
| `setup-project` | **Run first.** Initialize all templates for this project |
| `overview` | Bird's eye architecture view |
| `schema` | Data model + query analysis |
| `routes` | Endpoints mapped to handlers |
| `integrations` | External service connections |
| `glossary` | Domain terminology |
| `impact` | Blast radius before changing code |
| `research-codebase` | Deep-dive any feature |
| `create-plan` | Structured implementation plan |
| `implement-plan` | Execute a plan phase by phase |
| `validate-plan` | Verify implementation matches plan |
| `commit` | Structured commit messages |
| `describe-pr` | PR descriptions |
| `debug-codebase` | Systematic issue investigation |
| `create-handoff` | Document session state |
| `resume-handoff` | Resume from handoff |
| `recent` | Git-powered recent change analysis |
| `quality-gate` | Whole-file check of every touched file, run after each task |

Skills self-trigger on relevant requests, or invoke one directly by name (e.g. `/overview`). `setup-project` is the exception: it only runs when you invoke it. See `.claude/skills/README.md` for the full workflow map.

## Agents

`.claude/agents/` holds four read-only subagents (`codebase-locator`, `codebase-analyzer`, `pattern-finder`, `thoughts-analyzer`). The search-only ones run on `haiku`; the analyzers inherit your session model, so they follow whichever of Opus or Sonnet you are running.

Two more agents judge work instead of locating code, and both are read-only:

- `plan-auditor` audits an implementation plan before any task runs. It looks for tests that never reach the branches the plan's code mandates, unverified claims about the codebase, stale file references, and contradictions with the spec.
- `visual-guard` audits UI changes against your design tokens and responsive rules.

Neither agent decides what to do. Each tags its findings with an approval tier from `.claude/context/project.md`.

## Quality Gate

`.claude/scripts/quality-gate` checks every touched file in full against your own linters and rules, and the quality-gate skill runs it after each task. The `setup-project` skill writes its configuration. It can also install an optional hook, off by default, that runs a quick gate when Claude finishes responding.

## Tests

Run `sh tests/run-all.sh` from the repo root. It needs `jq` and `ruby`. The `tests/` folder is not part of what you copy into your project.

## Re-running Setup

If the project evolves significantly (new frameworks, major restructure), re-run the `setup-project` skill — it will read the existing `project.md` as a baseline and propose diffs rather than starting from scratch.

## Template Variables

Raw templates use `{{PLACEHOLDER}}` syntax. After the `setup-project` skill runs, these are all resolved. If you see a `{{...}}` in any skill output, re-run setup or manually edit `.claude/context/project.md`.

