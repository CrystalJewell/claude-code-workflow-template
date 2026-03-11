# Claude Code Starter Kit

Drop into any project. Run one command. Start working.

## Setup

```bash
# 1. Copy .claude/ into your project root
cp -r /path/to/this-repo/.claude /path/to/your-project/

# 2. Open Claude Code in your project
# 3. Run the setup command
/setup_project
```

The setup command will:
- Auto-discover your tech stack, framework, directory structure, and tooling
- Ask you to confirm and fill in any gaps
- Rewrite all templates with project-specific context
- Generate `.claude/context/project.md` as the persistent source of truth

## After Setup

All commands become project-aware. Start with orientation:

```
/overview     → Architecture + domains
/schema       → Data model
/routes       → Endpoints
/integrations → External services
```

## Commands Reference

| Command | Purpose |
|---------|---------|
| `/setup_project` | **Run first.** Initialize all templates for this project |
| `/overview` | Bird's eye architecture view |
| `/schema` | Data model + query analysis |
| `/routes` | Endpoints mapped to handlers |
| `/integrations` | External service connections |
| `/glossary` | Domain terminology |
| `/impact` | Blast radius before changing code |
| `/research_codebase` | Deep-dive any feature |
| `/create_plan` | Structured implementation plan |
| `/implement_plan` | Execute a plan phase by phase |
| `/validate_plan` | Verify implementation matches plan |
| `/commit` | Structured commit messages |
| `/describe_pr` | PR descriptions |
| `/debug_codebase` | Systematic issue investigation |
| `/create_handoff` | Document session state |
| `/resume_handoff` | Resume from handoff |
| `/recent` | Git-powered recent change analysis |

## Re-running Setup

If the project evolves significantly (new frameworks, major restructure), re-run `/setup_project` — it will read the existing `project.md` as a baseline and propose diffs rather than starting from scratch.

## Template Variables

Raw templates use `{{PLACEHOLDER}}` syntax. After `/setup_project` runs, these are all resolved. If you see a `{{...}}` in any command output, re-run setup or manually edit `.claude/context/project.md`.
