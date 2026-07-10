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

Skills self-trigger on relevant requests, or invoke one directly by name (e.g. `/overview`). See `.claude/skills/README.md` for the full workflow map.

## Re-running Setup

If the project evolves significantly (new frameworks, major restructure), re-run the `setup-project` skill — it will read the existing `project.md` as a baseline and propose diffs rather than starting from scratch.

## Template Variables

Raw templates use `{{PLACEHOLDER}}` syntax. After the `setup-project` skill runs, these are all resolved. If you see a `{{...}}` in any skill output, re-run setup or manually edit `.claude/context/project.md`.

