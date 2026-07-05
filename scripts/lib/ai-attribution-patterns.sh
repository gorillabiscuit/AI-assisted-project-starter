#!/usr/bin/env bash
# Shared AI-attribution regex vocabulary — the single source of truth
# for WHICH substrings count as AI attribution. Sourced by both
# scripts/scan-ai-attribution.sh and
# scripts/hooks/block-ai-attribution-commit.sh.
#
# Why this file exists: those two scripts used to hand-copy their own
# versions of these patterns and drifted — one treated a bare 🤖 as a
# standalone trigger, the other only recognised it paired with
# "generated with"; one alternated "generated with" on both
# claude|anthropic, the other only on claude. Verified with grep:
# "🤖 wrote this by hand" and "Generated with Anthropic tooling" each
# tripped one scanner and not the other. Centralising the vocabulary
# here means a future new phrasing is added once, not twice-and-hope.
#
# Each caller still applies its own anchoring around this vocabulary —
# scan-ai-attribution.sh anchors the "generated with" pattern at line
# start (it scans real multi-line commit bodies and wants to avoid
# false-positiving on prose that mentions the phrase mid-sentence,
# since a scan-time reject means rebasing an already-made commit).
# block-ai-attribution-commit.sh does not anchor (it scans a raw JSON
# payload before the commit is even made, so a false positive there
# just means the agent rephrases — cheap). That difference in
# strictness is deliberate; this file only fixes disagreement on WHICH
# WORDS count, not how strictly they're matched.

AI_ATTRIB_AUTHORS='claude|anthropic'

# "Co-Authored-By: <author>" — colon required, this is specifically for
# matching git trailers (key:value pairs by definition).
AI_ATTRIB_COAUTHOR_PATTERN="co-authored-by[[:space:]]*:[[:space:]]*(${AI_ATTRIB_AUTHORS})"

# "Generated with <author>" footer, with an optional leading robot
# emoji. The emoji is a signal only when paired with "generated with"
# (matching the actual footer shape) — not a standalone trigger, in
# either script.
AI_ATTRIB_GENERATED_PATTERN="(🤖[[:space:]]*)?generated[[:space:]]+with[[:space:]]+\\[?(${AI_ATTRIB_AUTHORS})"
