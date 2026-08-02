# ADR Queue — pending stack-selection decisions

**This is Phase 1 work.** Walk through each entry below with the human, finalise as a real numbered ADR using `_template.md`, then commit. The order is roughly dependency order — earlier choices constrain later ones.

Each entry below has:

- The decision to make
- A strawman recommendation (the previous-session Claude's or your own preliminary view)
- The alternatives that were considered and why they're not the recommendation
- What might change the recommendation

These are NOT decisions yet. They're strawmen for the new-session Claude + human to challenge or accept.

---

## How to work through this queue in Phase 1

1. **Read each entry below with the human.**
2. **For each: confirm the recommendation, push back, or pick an alternative.** Don't accept silently — make the human articulate why they agree.
3. **Write the real ADR file** at `docs/adr/000X-<title-slug>.md` using `_template.md`. Status = "Accepted". Date = today.
4. **Commit each ADR as its own commit** (`docs(adr): accept ADR-0001 monorepo tool` etc).
5. **Mark this `QUEUE.md` entry as resolved** by deleting that section and adding a one-liner to `README.md`'s index table.

Once all pending entries are accepted: Phase 1 done, move to Phase 2 (repo bootstrap).

---

## Starter list of Phase 1 decisions to make

Add one section per decision below. Suggested decisions for a typical web-app project (skip any that don't apply):

### Monorepo tool

**Strawman:** plain pnpm workspaces (turbo or nx if build caching becomes a bottleneck).

**Alternatives + why not:**

- **turbo** — adds build caching across packages, but extra config + concept overhead.
- **nx** — heavy / opinionated; valuable for large teams, overkill for solo.
- **Yarn workspaces** — fine but pnpm is faster + stricter about phantom deps.

**Would change our mind:** more than ~5 packages with shared build steps that take >30s each.

---

### Frontend framework

`<fill in with the decision shape: strawman, alternatives, change-our-mind signals>`

---

### API surface

`<...>`

---

### Auth provider

`<...>`

---

### Database

`<...>`

---

### ORM

`<...>`

---

### Job orchestration

`<...>`

---

### Observability stack

`<...>`

---

### Hosting platform

`<...>`

---

### Deployment pipeline

How code reaches staging and production, and what gates block it. Distinct from _hosting platform_ (where it runs): this decision is about the promotion path. The CI file ships with a commented skeleton of the pattern (`.github/workflows/ci.yml`, `deploy` block) — this ADR fills in the platform-specific steps.

**Strawman:** staging deploys continuously from `main`; production deploys on a version tag through a GitHub `environment` with required approval; both depend on every gate job (preflight, dependency-audit, attribution). Rollback procedure written as a runbook (`docs/runbooks/`) before the first production deploy.

**Alternatives + why not:**

- **Deploy on merge to main straight to prod** — fine for a static site or throwaway; one bad merge is a production incident everywhere else.
- **Manual deploys from a laptop** — unauditable, bus-factor-1, and skips the gates by construction.
- **PR-preview environments from day one** — genuinely great, but platform-dependent effort; add when reviewing UI/API changes without pulling the branch becomes a real friction, not before.

**Would change our mind:** a platform whose native flow already implements the pattern (e.g. Vercel's preview/production model) — then the ADR documents the mapping instead of building it.

---

### Secrets management

Where credentials live in dev, CI, and production, and how they rotate. Deciding this late means secrets accrete in `.env` files and CI settings with no rotation story — and the first leaked key becomes an incident instead of a runbook.

**Strawman:** local dev uses `.env` (gitignored) seeded from a committed `.env.example` that names every variable with a comment but never a value; CI uses the platform's secret store (GitHub Actions secrets); production uses the hosting platform's managed secret store — never baked into images or bundles. Every vendor credential gets a rotation procedure in its runbook (`docs/runbooks/`) at the moment the vendor is added.

**Alternatives + why not:**

- **A dedicated secrets manager from day one** (Vault, Doppler, AWS Secrets Manager) — right answer for multi-service or compliance-bound projects; ceremony without payoff for a two-package MVP. Graduate via this ADR when the trigger below fires.
- **Encrypted secrets in the repo** (SOPS, git-crypt) — auditable and offline-friendly, but key distribution becomes its own problem and history rewrites on leak are brutal.

**Would change our mind:** more than one deploy target consuming the same secrets, any compliance regime with rotation requirements, or the first near-miss.

---

### Styling approach

`<...>`

---

### Component library

`<...>`

---

### Testing approach

`<...>`

---

### Privacy compliance approach

`<...>`

---

`<Add project-specific decisions below as needed — payment provider, vector store, ML inference stack, etc.>`
