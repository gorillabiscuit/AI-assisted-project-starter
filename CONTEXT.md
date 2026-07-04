# CONTEXT.md — domain language

The ubiquitous language of this project: the domain's nouns and verbs,
with the exact meanings this repo commits to. Code, tickets, ADRs, and
conversation all use these terms with these meanings — when a term
drifts, fix the drift here first, then in the code.

This file complements the ADRs in `docs/adr/`: ADRs record *decisions*
(what we chose and why); this file records *vocabulary* (what words
mean). Skills and review flows that reason about the domain read this
file first.

## When to update

- A new domain concept gets a name → add it here in the same PR.
- Two terms turn out to mean the same thing → collapse them here,
  then rename in code.
- A term's meaning shifts (scope grows, an edge case is excluded) →
  update the definition and note what changed.

## Format

One term per entry. Definition first, then boundaries — what the term
does NOT cover is often the load-bearing part.

```
### <Term>

<One- to three-sentence definition.>

**Not:** <the adjacent thing this term is often confused with, and why
it's different.>
```

---

## Terms

`<First entries land during kickoff, when PROJECT.md's product brief
names the core concepts. Until then, this file is intentionally
empty.>`
