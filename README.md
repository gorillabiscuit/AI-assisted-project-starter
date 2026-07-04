# ai-assisted-project-starter

A pnpm-monorepo starter that bakes in the working contract, doc layout, and
tooling that's already proven across multiple projects. Designed so a new
project can be productive with an AGENTS-compatible coding agent — Claude
Code, Pi, or any other — from the first session. The guardrails are
pre-wired, the conventions are pre-decided, and the project-specific
scaffolding is clearly marked.

**What this gives you on day one:**

- `AGENTS.md` — the working contract between you and the AI agent
  (`CLAUDE.md` is a symlink to it, so Claude Code's discovery path keeps
  working unchanged). Banned patterns, stop-and-ask gates including a North
  Star relevance gate, commit conventions, pre-PR process, testing approach
  (Approach A/B/C with sub-agent isolation for moat-relevant code).
- `PROJECT.md` with a `## North Star` block + the `/north-star` command in
  both harnesses (the ritual itself ships as a standalone skill —
  [gorillabiscuit/north-star-skill](https://github.com/gorillabiscuit/north-star-skill)),
  so the first thing a new project does is pick the single metric every
  feature must trace to.
- Harness command layout — `.claude/commands/` for Claude Code,
  `.pi/prompts/` for Pi, both symlinked to the same canonical doc bodies so
  there's one source of truth.
- ADR pattern (`docs/adr/`) + lightweight runbook pattern
  (`docs/runbooks/`).
- `LEARNED.md`, `DEPS.md`, `ROADMAP.md`, `PROJECT.md` skeletons — each
  with the "why this exists / when to update" prose intact. ROADMAP
  milestones carry a `North Star linkage:` line.
- AI-attribution pre-push scanner (`scripts/scan-ai-attribution.sh`) wired
  into `.husky/pre-push` so AI-co-author trailers can never reach a PR.
- `/pre-pr` command (works in both harnesses) that runs the full §7
  pre-PR review inline: gates, diff walk, sub-agent meta-check, AC
  mapping, commit hygiene, rebase status, PR-description draft.
- TypeScript strict baseline (`noUncheckedIndexedAccess`,
  `exactOptionalPropertyTypes`, the works).
- ESLint flat config + Prettier + lint-staged + husky pre-commit /
  pre-push.
- Vitest config that picks up `*.test.ts` in `apps/` and `packages/`.

**What this does NOT give you:**

- A specific framework (Next.js, Remix, etc) — add per project.
- A specific database / ORM / auth provider — pick per project and ADR
  the choice.
- Application code, schema, routes — empty `apps/web/` and
  `packages/shared/` placeholders ship with `AGENTS.md` overlays (and
  matching `CLAUDE.md` symlinks) and nothing else.

---

## How to use it

```bash
# 1. Clone or template-clone into a new project directory
gh repo create my-new-project --template gorillabiscuit/ai-assisted-project-starter --private --clone
# OR:
git clone git@github.com:gorillabiscuit/ai-assisted-project-starter.git my-new-project
cd my-new-project
rm -rf .git && git init

# 2. Install the North Star skill, then run the kickoff BEFORE anything else
#    The ritual ships as a standalone skill. Install it once at the user level:
#      git clone https://github.com/gorillabiscuit/north-star-skill.git \
#        ~/.claude/skills/north-star
#    Then open the project with your agent (Claude Code or Pi) and invoke
#    /north-star. Output: PROJECT.md's ## North Star block filled with metric
#    + companion sentence + boundary. Per AGENTS.md §4, no other non-trivial
#    task may proceed until these placeholders are replaced.
#    (See docs/north-star-kickoff.md for the install pointer.)

# 3. Edit project identity
#    - AGENTS.md §1 "Project identity" — name, phase, tracker
#      (CLAUDE.md is a symlink to AGENTS.md; edit AGENTS.md.)
#    - PROJECT.md — fill out the rest of the brief; the North Star sharpens
#      the cut-line.
#    - package.json `name` field — your project name
#    - docs/adr/0000-architecture-overview.md — your macro shape

# 4. Install deps and run prepare (sets up husky hooks)
pnpm install

# 5. Verify gates work on the empty scaffolding
pnpm preflight    # typecheck + lint + test (will exit clean — nothing to check yet)

# 6. Open KICKOFF.md and walk Phase 1 (stack-selection ADRs)
```

### Adopting this in an existing repo (retrofit)

Skip the `gh repo create` step. First install the North Star skill at the user
level (once per machine):

```bash
git clone https://github.com/gorillabiscuit/north-star-skill.git \
  ~/.claude/skills/north-star
```

Then, from the root of your existing repo, copy in (or symlink) `AGENTS.md`, the
AI-attribution pre-push hook (`scripts/scan-ai-attribution.sh` +
`.husky/pre-push`), and — if you don't already have one — the `## North Star`
block in `PROJECT.md`. Then run `/north-star` and pick **retrofit mode** at
Phase 0. The agent will read your repo (README, PROJECT.md, recent commits,
ROADMAP, LEARNED) before asking anything, and write the result as a dated
amendment to PROJECT.md, not a replacement.

---

## Layout

```
.
├── AGENTS.md              The working contract. Read end-to-end before any work.
├── CLAUDE.md              Symlink to AGENTS.md (Claude Code discovery).
├── KICKOFF.md             What the first session should do; remove once it has.
├── PROJECT.md             Product brief skeleton with ## North Star block.
├── CONTEXT.md             Domain-language skeleton — terms the code commits to.
├── DEPS.md                Per-dependency justification, one line each.
├── LEARNED.md             Sharp-edges journal — append when something costs >15 min.
├── README.md              You are here.
│
├── docs/
│   ├── ROADMAP.md         Sequenced milestone view; each milestone carries a North Star linkage line.
│   ├── north-star-kickoff.md  Pointer to the standalone north-star skill (ritual no longer ships here).
│   ├── adr/
│   │   ├── README.md      ADR index + format reference.
│   │   ├── _template.md   Empty ADR — copy this when adding one.
│   │   ├── QUEUE.md       Strawman decisions awaiting human review.
│   │   └── 0000-architecture-overview.md  Macro shape (draft).
│   └── runbooks/
│       └── README.md      Per-vendor incident reference pattern.
│
├── .claude/
│   └── commands/
│       ├── pre-pr.md      `/pre-pr` — full §7 inline (canonical).
│       └── north-star.md  Symlink → docs/north-star-kickoff.md (install pointer; ritual is the north-star skill).
│
├── .pi/
│   └── prompts/
│       ├── pre-pr.md      Symlink → .claude/commands/pre-pr.md.
│       └── north-star.md  Symlink → docs/north-star-kickoff.md (install pointer; ritual is the north-star skill).
│
├── .husky/
│   ├── pre-commit         lint-staged
│   └── pre-push           AI-attribution scan + preflight
│
├── scripts/
│   └── scan-ai-attribution.sh  Pre-push hook tool.
│
├── apps/
│   └── web/
│       ├── AGENTS.md      Per-package rules overlay (skeleton).
│       └── CLAUDE.md      Symlink to apps/web/AGENTS.md.
│
├── packages/
│   └── shared/
│       ├── AGENTS.md      Platform-agnostic package overlay (skeleton).
│       └── CLAUDE.md      Symlink to packages/shared/AGENTS.md.
│
├── eslint.config.mjs      Flat config. Banned-pattern rules enforced.
├── tsconfig.base.json     Strict TypeScript baseline.
├── vitest.config.ts       Workspace test runner.
├── .prettierrc.json
├── .lintstagedrc.json
├── .gitignore
├── package.json           Root scripts: preflight / typecheck / lint / test / format.
└── pnpm-workspace.yaml
```

---

## Customisation map

When you adapt this for a new project, here's where the boilerplate ends and
the project-specific content begins:

| File | What to keep | What to replace |
|---|---|---|
| `AGENTS.md` (root; `CLAUDE.md` symlinks to it) | §2–§12 (conventions, banned patterns, pre-PR, testing, etc) | §1 "Project identity" — replace with your name, phase, tracker, repo structure |
| `apps/web/AGENTS.md` (and its `CLAUDE.md` symlink) | Pattern + "imports allowed/forbidden" structure | Specific package imports for your stack |
| `packages/shared/AGENTS.md` (and its `CLAUDE.md` symlink) | Platform-agnostic rule + banned patterns | Project-specific anti-patterns if any |
| `PROJECT.md` | Section headings + the `## North Star` block scaffold | Fill the North Star block via `/north-star` BEFORE writing the rest; then replace skeleton content below |
| `docs/north-star-kickoff.md` | The pointer to the standalone north-star skill | Nothing (the ritual lives in the skill repo now) |
| `docs/adr/0000-architecture-overview.md` | The ADR-0000 structure | The ASCII diagram + every choice |
| `docs/adr/QUEUE.md` | The intro prose explaining the queue | Empty until you have pending stack-selection ADRs |
| `package.json` | Scripts block + devDependencies | `name` field |
| `eslint.config.mjs` | All rule blocks | The `packages/shared` rule may need to point at your platform-agnostic package, if any |

Everything else is generic and can stay verbatim.

---

## Why these conventions?

A separate doc describes the rationale for each rule in AGENTS.md (e.g. why
`==` is banned, why ADRs follow this specific format, why tests use
Approach B for moat code). That history isn't here yet — for now,
`AGENTS.md` itself has the reasoning inline as comments where it matters.
