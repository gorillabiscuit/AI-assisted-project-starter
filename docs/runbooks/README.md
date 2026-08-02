# Runbooks

Two kinds live here: **per-vendor** runbooks (one page per third-party
dependency) and **operational** runbooks (procedures we execute under
pressure). Both exist for the same reason — the moment you need them is
the worst moment to be improvising.

## Operational runbooks

Written _before_ the event they cover, not after. The baseline set every
deployable project should have by first production deploy:

- `rollback.md` — how to get production back to the last good version,
  as exact commands. If rollback requires thinking, it isn't a rollback
  procedure yet.
- `secret-leak.md` — a credential hit a repo, a log, or a paste: which
  keys exist (link each vendor runbook's rotation section), revocation
  order, and how to verify the old credential is dead.
- `incident.md` — the first 15 minutes: how to tell vendor failure from
  our failure (link the vendor runbooks), where the logs and dashboards
  are, what "degraded but operating" modes exist, who to inform.

Same discipline as vendor pages: under ~100 lines, exact commands over
prose, updated in the same PR as the change that invalidates them. A
post-mortem that exposed a missing step ends with a commit to these files.

## Per-vendor runbooks

One page per third-party dependency. The point is not exhaustive vendor
documentation — it's enough to answer three questions in a hurry:

1. **What breaks if this vendor is down?** What's the user-visible impact?
2. **What's the manual fallback?** Can we keep operating in some degraded
   mode while the vendor recovers, or do we just have to wait?
3. **Where do we look to confirm it's the vendor and not us?** Status page,
   our own observability, log signatures.

Each runbook is intentionally short — under ~100 lines. If a runbook starts
growing into a multi-page guide, that's a sign the vendor is significant
enough to warrant its own ADR or on-call doc, not a longer runbook.

## Index

`<List one entry per vendor as they're added. Example:>`

- `<vendor-name>.md` — `<one-line description>` (per `ADR-XXXX`)

## Conventions

- **Status page** links go to the vendor's official status page. If a vendor
  doesn't have one, that's noted explicitly — outages have to be inferred from
  our own signals.
- **Cost signals** capture the free-tier ceiling and the first paid step.
  "Something to watch" not "exact pricing" — pricing pages are authoritative.
- **Key rotation** is the procedure for revoking + reissuing the vendor's
  primary credential after a leak. Rotation should be possible from the
  vendor's dashboard without code changes (env-var-only update).
- **No on-call paging** is wired up by default. These runbooks are for
  manual reference during incidents, not for automation.

## When to update

- A new vendor is added → add a runbook in the same PR as the dep.
- A vendor's status page URL changes → update the runbook.
- A vendor outage exposed a failure mode we hadn't documented → capture it
  under "What breaks" and link the post-mortem if there is one.

## Template for a new runbook

```markdown
# Runbook: `<Vendor>`

**What it is:** `<one-line role in our stack>`. Per [ADR-XXXX](../adr/XXXX-slug.md).

## What breaks if it's down

- `<impact 1>`
- `<impact 2>`

## Manual fallback

`<degraded mode, or "there isn't one in Phase 1A">`

## Status page

`<URL>`

## How we tell it's the vendor and not us

- `<log signature or observability signal that points at vendor failure>`
- `<our own metric/dashboard that goes red when this vendor fails>`

## Key rotation

`<step-by-step from the vendor's dashboard>`

## Cost signals

- Free tier ceiling: `<...>`
- First paid step: `<...>`
- Something to watch: `<usage that climbs unexpectedly>`
```
