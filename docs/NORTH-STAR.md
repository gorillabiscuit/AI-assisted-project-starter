# North Star — the starter itself

_(added retrofit, 2026-07-05)_

This is the North Star for **this repo's own development** — the standard
every change to the starter is traced against. It deliberately does NOT
live in `PROJECT.md`: that file's placeholder `## North Star` block is a
shipped product feature (a fresh clone must have an unfilled star so the
edit gate arms and forces the new project's kickoff). Filling it here
would disarm the gate in every downstream clone. In this repo, tooling
that says "trace against PROJECT.md's North Star" traces against this
file instead; the edit gate staying armed over `apps/` and `packages/`
is correct — no product code belongs in the starter's scaffolds.

- **Mission.** The starter puts in place measures and guardrails that
  maximise the user's ability to write high-quality code with AI —
  preventing the patterns and problems commonly associated with
  AI-produced code — without being overly pedantic or burdensome to use.

- **Metric.** The share of the starter's guardrails with pointable
  real-world evidence of having caught or prevented a genuine problem.
  Measured at each guardrail audit; a guardrail without evidence counts
  against the score. Baseline: 6/9 (2026-07-05 audit — kept: lint
  banned-patterns, stop-and-ask, North Star hooks, test isolation,
  pre-PR ritual, ADR/LEARNED/DEPS discipline; failed: AI-attribution
  gate, tagged diff review, CONTEXT.md). Default, open to challenge:
  "evidence" means a concrete instance you can name — a caught
  exception, a blocked mistake, an external reviewer's validation — not
  a plausible story.

- **Companion.** What this means for what we build: every change either
  strengthens a guardrail that has evidence behind it, or removes or
  simplifies one that lacks it. First work list from the 2026-07-05
  audit: replace tagged diff review with plain-language change
  explanations (cold-context agent for security-touching changes);
  generalise the stop-and-ask list from ~20 specifics to 4 principles
  (hard to reverse / expands trust / changes a promise others rely on /
  grows beyond the ask); cut CONTEXT.md and the AI-attribution gate;
  point session hygiene at the /handoff practice.

- **Boundary.** What does NOT serve this: guardrails justified by
  plausibility rather than a pointable incident; ceremony that assumes
  human behaviour that doesn't actually happen; rules inherited from one
  project's specific problem dressed up as universal; any guardrail that
  nags on honest work.
