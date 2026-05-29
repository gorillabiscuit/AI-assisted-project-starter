# North Star kickoff — moved

The North Star kickoff ritual no longer ships in this starter. It now lives in
its own canonical repo so it can be a standalone, versioned Claude Code skill:

**→ https://github.com/gorillabiscuit/north-star-skill**

This file is a pointer only. The starter is now a *consumer* of the ritual, not
its owner.

## Install the skill

### Claude Code (user-level — available in every project)

```bash
git clone https://github.com/gorillabiscuit/north-star-skill.git ~/.claude/skills/north-star
```

Then invoke it in any project with `/north-star`.

### claude.ai

Zip the skill folder (`SKILL.md`) and upload it via claude.ai's skill settings.
See the skill repo's README for details.

## How this is wired in the starter

- The `/north-star` command works once the skill is installed at the user level
  (above). The `.claude/commands/north-star.md` and `.pi/prompts/north-star.md`
  entries point at this stub so the name still resolves to install guidance
  rather than dangling.
- `AGENTS.md` §4's North Star relevance gate references `/north-star` (the
  skill) rather than this doc body.
- `PROJECT.md`'s `## North Star` block is still filled by running `/north-star`.

If you previously relied on the ritual body living here, it is preserved
verbatim in the skill repo's `SKILL.md`.
