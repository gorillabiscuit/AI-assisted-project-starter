#!/usr/bin/env bash
# Shared North Star inspection helpers — the single source of truth for
# WHAT counts as "the North Star block" and WHEN it counts as filled.
# Sourced by scripts/hooks/block-unstarred-source-edit.sh and
# scripts/hooks/inject-north-star-session-start.sh.
#
# Why this file exists: both hooks need the same two judgments (extract
# the `## North Star` section from PROJECT.md; decide whether it is
# still placeholder text). The attribution hooks in this repo already
# learned the hard way that two hand-copied versions of one vocabulary
# drift (see scripts/lib/ai-attribution-patterns.sh) — so this starts
# shared.

# Prints the `## North Star` section of the given markdown file —
# everything from the `## North Star` heading up to (not including) the
# next `## ` heading. Prints nothing and returns 1 if the file or the
# section is missing.
north_star_block() {
  local file="$1"
  [ -f "${file}" ] || return 1
  local block
  block=$(awk '/^## North Star[[:space:]]*$/{found=1; print; next} found && /^## /{exit} found{print}' "${file}")
  [ -n "${block}" ] || return 1
  printf '%s\n' "${block}"
}

# Returns 0 iff the file has a North Star block AND that block carries
# no placeholder markers. Placeholders are the `<...>` template markers
# PROJECT.md ships with, plus the literal "(not yet defined)" escape
# hatch. `<[^>]+>` needs a CLOSING bracket, so filled content like
# "p95 <200ms" does not false-positive; genuine HTML in a filled block
# would, but that false positive is cheap (the agent sees the message
# and the human de-angle-brackets one line) whereas a false NEGATIVE
# means the relevance gate silently disarms — the failure mode the
# helpme2c audit (0/30 traced commits) proved is the one that matters.
north_star_is_filled() {
  local file="$1"
  local block
  block=$(north_star_block "${file}") || return 1
  if printf '%s' "${block}" | grep -qE '<[^>]+>|\(not yet defined\)'; then
    return 1
  fi
  return 0
}

# Prints just the Metric sentence from the North Star block — the one
# line every task must trace to, and the only line the session banner
# shows. Handles both the PROJECT.md template form (`**Metric:**`) and
# the /north-star skill's amendment form (`**Metric.**`): strips the
# label, markdown backticks, and surrounding whitespace. Returns 1 if
# no metric line is present.
north_star_metric() {
  local file="$1"
  local block line
  block=$(north_star_block "${file}") || return 1
  line=$(printf '%s\n' "${block}" | grep -iE '\*\*Metric[:.]\*\*' | head -1)
  [ -n "${line}" ] || return 1
  line=$(printf '%s' "${line}" | sed -E 's/^.*\*\*Metric[:.]\*\*[[:space:]]*//; s/`//g; s/^[[:space:]]+//; s/[[:space:]]+$//')
  [ -n "${line}" ] || return 1
  printf '%s\n' "${line}"
}
