# `<PROJECT_NAME>` — kickoff

You are the first AI-coding-agent session opened on this project (Claude Code, Pi, or any other AGENTS-compatible harness). This document tells you what's already been decided, what hasn't, and what you should do first. **Read this before doing anything else.**

> **This is a starter-template file.** Once Phase 1 (stack-selection ADRs) and Phase 2 (repo bootstrap) are complete, delete this file — its only purpose is to bridge the gap from "starter scaffolding" to "first real work."

---

## What this project is

`<One-paragraph product description. What problem does this solve? Who for? What's the differentiator?>`

Full product context: read **`PROJECT.md`** next.

---

## Project state when you opened this

This repo was scaffolded from
[`ai-assisted-project-starter`](https://github.com/gorillabiscuit/ai-assisted-project-starter)
— the monorepo template that ships the working contract, ADR pattern,
AI-attribution scanner, North Star kickoff ritual, and pre-PR review flow
already wired up for both Claude Code and Pi.

The starter gave you:

- `AGENTS.md` (working contract — read end-to-end; `CLAUDE.md` is a symlink to it)
- `docs/north-star-kickoff.md` + `/north-star` command in both harnesses
- `.claude/skills/pre-pr/SKILL.md` + `.pi/prompts/pre-pr.md` (`/pre-pr` review)
- `.claude/agents/` (test-writer + pessimistic-reviewer subagents)
- `scripts/scan-ai-attribution.sh` + `.husky/pre-push` (AI-attribution gate)
- `docs/adr/` (ADR pattern + `_template.md`)
- `docs/runbooks/` (per-vendor incident reference pattern)
- `LEARNED.md`, `DEPS.md`, `ROADMAP.md`, `PROJECT.md` skeletons (the last with a `## North Star` block to be filled on kickoff)
- TypeScript strict baseline, ESLint flat config, Prettier, Vitest, husky+lint-staged

No application code exists yet. The artefacts you see are the **design + contract scaffolding** for you to build on.

---

## Phase 1: your starting point

Walk through these in order. **Each is a deliberate "decide before you build" gate.**

### 1.0 North Star

Run the kickoff ritual in `docs/north-star-kickoff.md` (or invoke `/north-star`).
Interview the human one question at a time. The output is three lines written
into `PROJECT.md`'s `## North Star` block: the metric, the "what this means
for what we build" sentence, and the boundary. Do this BEFORE filling
`PROJECT.md`'s product-brief sections — the rest of the brief gets sharper
once the North Star is fixed, and per `AGENTS.md §4` no other non-trivial
task may proceed until the placeholders are replaced.

### 1.1 Product brief

Open `PROJECT.md` and fill it in:

- What we're building
- What we're NOT building (cut-line)
- Target users (ranked by priority)
- Success metrics
- Phase 1A scope (IN / OUT)
- Revenue / business model (informs architecture)
- Defensible moats
- Open product decisions

Don't accept the skeleton silently — make the human articulate every section. Their answers shape every subsequent decision.

### 1.2 Architecture overview

Open `docs/adr/0000-architecture-overview.md` and fill it in. This is the macro shape — subsequent ADRs refine specific choices. Don't litigate every library; lay out the components and the data flow between them.

### 1.3 Stack-selection ADRs

Walk through the pending decisions with the human, one at a time. **The decision list lives in `docs/adr/QUEUE.md`** — one section per decision, each with a strawman recommendation, rejected alternatives, and change-our-mind signals. Don't duplicate the list here; open the queue and work it top to bottom (it's in rough dependency order; skip any that don't apply).

For each: write a real ADR using `docs/adr/_template.md` as `000X-<slug>.md`. Status = "Accepted". Commit each as its own commit (`docs(adr): accept ADR-0001 monorepo tool`), then delete the resolved QUEUE.md section.

### 1.4 Update the working contract

Now that you have decisions, fix `AGENTS.md` §1 (project identity) and §2 (architectural invariants) to match. Add any project-specific banned patterns (§3) and stop-and-ask items (§4) that the decisions imply.

### 1.5 Roadmap

Open `docs/ROADMAP.md` and lay out the milestones — sequenced view of the work, complementing PROJECT.md's contract. **Every milestone entry needs a `North Star linkage:` line** stating how its outcome moves the metric in PROJECT.md's `## North Star`. If a milestone can't be linked, it's the wrong milestone.

---

## Phase 2: repo bootstrap

After Phase 1 ADRs are accepted:

1. Install dependencies for whatever stack you decided on.
2. Stand up the first app (`apps/web/` is pre-created as an empty folder with an `AGENTS.md` overlay; `CLAUDE.md` symlinks to it).
3. Run `pnpm preflight` — should pass on the empty scaffolding.
4. First "real" feature commit lands.

Once Phase 2 is done, delete this `KICKOFF.md` file. It exists only to bridge starter → first work.
