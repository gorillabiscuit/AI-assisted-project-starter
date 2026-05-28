# `<PROJECT_NAME>` — Phase 1A roadmap

**Status:** living document, refined as we learn
**Last updated:** `<DATE>`

This is the sequenced milestone view of [Phase 1A scope](../PROJECT.md). It captures the build order and dependencies — **not the scope itself**. PROJECT.md remains the cut-line contract: anything outside the IN-scope list there requires explicit negotiation per [AGENTS.md §4](../AGENTS.md), and the same section requires every non-trivial task — including each milestone below — to trace to PROJECT.md's North Star.

When the project tracker is in regular use, individual tickets live there (see the relevant ADR); these milestones become projects or cycles. This file stays as the readable narrative — it complements the tracker, doesn't replace it.

---

## Sequenced milestones

Each milestone is meant to **ship as it lands** — not "complete everything before starting the next." Several can interleave once dependencies are satisfied.

### M1 — `<name>`

`<bullet points of what M1 ships>`

**North Star linkage:** `<one sentence — how shipping M1 moves the metric in PROJECT.md's North Star. If you can't write this, the milestone is the wrong milestone (AGENTS.md §4).>`

**Outcome:** `<what the user / tester can do after M1>`

### M2 — `<name>`

`<bullet points>`

**North Star linkage:** `<one sentence — same shape as above.>`

**Outcome:** `<...>`

`<continue for each milestone>`

### MN — Launch readiness

- Performance budgets met per PROJECT.md
- Accessibility audit (e.g. WCAG 2.1 AA)
- Error states polished
- Empty states polished
- Alpha tester onboarding for first 10–20 testers

**North Star linkage:** `<one sentence — readiness milestones still need a linkage: e.g. "ensures the value moment is reliably reachable for the first cohort of testers, so the metric can start being measured at all.">`

**Outcome:** shippable.

---

## Parallelism + dependency notes

- `<note any milestones that can run in parallel after deps are satisfied>`
- `<note any cross-cutting tracks that run continuously (e.g. privacy hardening, observability)>`

---

## Explicitly deferred to Phase 1B+

Per PROJECT.md cut-line:

- `<Phase 1B feature 1>` → 1B
- `<Phase 2 feature>` → 2
- `<Out-of-scope item>` → Out of product scope entirely

---

## Maintenance

- Refine this file as scope is learned, but PROJECT.md remains the contract.
- When a milestone completes, mark it ✅ and link the relevant tracker cycle.
- When a deferred item moves into 1A, update both this file AND PROJECT.md (per AGENTS.md §4 stop-and-ask) — and confirm the moved item has a North Star linkage that justifies promoting it.
