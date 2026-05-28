# North Star kickoff

Run at the start of a new project — or when adopting these conventions into an
existing one. Goal: arrive at ONE product north star metric, a companion
sentence, and a scope boundary. Write the result into PROJECT.md.

Two modes share most of the ritual but diverge at Phase 1:

- **Greenfield** — nothing built yet. Interview the human from blank.
- **Retrofit** — code shipped, decisions made, users (real or pilot)
  exist. Read the evidence first; interview informed by it; write the
  result as an amendment, not a replacement.

## How the AI must run this
- Interview the human. One focused question at a time. Never dump a questionnaire.
- A north star is a proxy for delivered value, not a vanity count. Reject vanity
  answers (signups, MAU, page views) and say why.
- Do not let the human converge early. Generate at least two candidates and
  pressure-test both before recommending one.
- Be opinionated. Recommend one, with reasoning. The human decides.

## Phase 0 — Greenfield or retrofit?

Ask once, route accordingly:

- **Greenfield** = no shipped code, no real users, PROJECT.md is still
  placeholder text. Go to Phase 1A.
- **Retrofit** = anything else — there's code in `apps/` or `packages/`,
  real or pilot users, a filled (even partly) PROJECT.md, or historical
  commits that mean "what we've built" is a real question. Go to Phase 1B.

When in doubt, pick retrofit. Reading-first is cheap; writing-from-blank
into a non-blank repo causes real damage.

## Phase 1A — Greenfield: the job (ask one at a time)
1. In one sentence, what is this product?
2. Who is the single most important user? Not a segment list. One person.
3. What one job do they hire it to do?
4. If it vanished tomorrow, what specifically would they miss?

Once those four are answered, skip to Phase 2.

## Phase 1B — Retrofit: read the repo, then interview

### 1B.0 Read first (no questions yet)

Before asking the human anything, read the evidence. Minimum:

- `README.md` — the public framing of what this is.
- `PROJECT.md` — if it exists. If not, look for the top-level pitch in
  the README and note that PROJECT.md is missing.
- `git log --oneline -50` — what has actually shipped recently? Where
  has the work concentrated?
- `docs/ROADMAP.md` — if it exists. What was planned vs what got built?
- `ls apps/ packages/` (and one level deeper) — what's the surface area?
- `LEARNED.md` — if it exists, this is gold for "what's actually mattered."

Do not start the interview until this read is done. Asking the human
questions you could have answered from the repo wastes their time and
signals you didn't do the work.

### 1B.1 Read-back: what does this project do today?

Write a single sentence: "From what I read, this project does X for Y
so that Z." Read it back to the human. They will correct it. This is
the calibration step — if the read-back is wildly off, more reading is
needed before interviewing further. Do not proceed until the read-back
lands.

### 1B.2 Usage: shipped vs ignored

The repo can't tell you what users actually do; the human can. Ask, but
anchor every question to something specific you read:

- "I noticed `apps/web/<feature>/` ships three modes — which one do
  users actually pick?"
- "The last 10 commits are concentrated in `<area>` — is that because
  it's load-bearing for users, or because it's been hard to get right?"
- "Which feature would users miss most if you removed it tomorrow? And
  which would they not notice?"

### 1B.3 Moat in practice

Greenfield asks "what's defensible." Retrofit asks "what *has been*
defensible, on evidence":

- Where has the defensible thing actually shown up? A feature that
  travels by word of mouth, a customer conversation that surprised
  you, a competitor who couldn't match something specific?
- Is there a gap between what the team thinks the moat is and where
  usage / feedback / word-of-mouth concentrates? Surface the gap.

### 1B.4 Strawman North Star

Propose a North Star *derived from the evidence plus the usage
interview*. Offer two candidates minimum, each with one sentence of
reasoning grounded in what you read or heard:

- "Candidate A: <metric>. Reasoning: <one sentence tying it to the
  value moment you saw evidence of>."
- "Candidate B: <different metric>. Reasoning: <one sentence>."

Human defends one, rejects both, or counter-proposes. Do not converge
yet — both candidates still need to pass Phase 3's pressure tests.

### 1B.5 Surface contradictions

Look at what's been built that *doesn't* fit the strawman. List it
explicitly. There are two readings, and both belong on the table:

- **Mistake.** Something got built that doesn't serve the North Star;
  we should stop investing in it (or sunset it).
- **Wrong star.** The built thing was right and the strawman is wrong
  — the work that actually delivered value reveals a different North
  Star than the one being proposed.

Don't let the human resolve this in one breath. Sit with it. The
contradictions often contain the real answer.

## Phase 2 — The value moment
5. What is the single moment the user receives the core value? Name the event.
6. Does that moment exploit the project's moat / what's defensible here?
   If not, flag the mismatch and dig further.

## Phase 3 — Candidates

Propose 2-3 candidate metrics, each a countable thing tied to the value moment.
(In retrofit mode, the Phase 1B.4 strawmen are already candidates — bring them
forward and add at least one more for contrast.) Pressure-test each:

- Value proxy, not vanity: does it rise only when the user genuinely got value?
- Gameable: could the team juice it without delivering value?
- Incentive: optimise it hard for a year, does the product get better or worse?
- Leading, not lagging: can it move this week, not next quarter?
- Traceable: can an arbitrary feature be honestly linked to it?

## Phase 4 — Converge and commit
- Pick ONE. State it as a single metric.
- Write the companion sentence: "What this means for what we build: ..."
- Write the boundary: "What does NOT serve this: ..."
- Write all three into PROJECT.md under `## North Star`.
- Confirm the AGENTS.md relevance gate references it.

**If retrofit:** the result lands in PROJECT.md as an *amendment*, not a
replacement.

- Add a new `## North Star` block at the top of `PROJECT.md` (above
  "What this is", not nested under it).
- Mark it with `_(added retrofit, YYYY-MM-DD)_` on a line directly
  under the heading, using today's date in ISO format, so future
  readers know where it came from.
- If a `## North Star` block already exists from a prior pass, do NOT
  overwrite it silently. Show the human both old and new and let them
  choose: replace, keep both with dated parentheticals, or fold the old
  one into a "Prior North Star" note below.
- Do not delete or rewrite anything below the block. The retrofit
  discovers the North Star; it doesn't relitigate the brief.
