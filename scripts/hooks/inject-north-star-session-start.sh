#!/usr/bin/env bash
# Claude Code SessionStart hook — prints PROJECT.md's North Star block
# to stdout so it lands in the agent's context at the start of every
# session.
#
# Wired via .claude/settings.json (tracked, project-level). Per the
# Claude Code hooks contract, stdout from SessionStart hooks is added
# to the session context. That is the whole trick: the AGENTS.md §4
# relevance gate asks every non-trivial task to trace to the North
# Star, and a star the model has to remember to go read is a star that
# gets skipped (the helpme2c audit found 0/30 commits carried a trace).
# Injecting it here means the star is in frame before the first
# request, with no reliance on the model's initiative.
#
# When the star is still placeholder text, we inject a warning instead
# of the block — the agent should know from message one that the edit
# gate (block-unstarred-source-edit.sh) is armed and why.
#
# Always exits 0: a session must never fail to start over this.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/north-star-block.sh
source "${SCRIPT_DIR}/../lib/north-star-block.sh"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_MD="${PROJECT_DIR}/PROJECT.md"

if north_star_is_filled "${PROJECT_MD}"; then
  # A star banner over the Metric sentence, if we can render one. Pure
  # eye-catcher: the full block below is still the substance the agent
  # reasons against. Any failure (no python3, metric too long, script
  # error) silently drops the banner — never the block.
  metric=$(north_star_metric "${PROJECT_MD}" 2>/dev/null || true)
  if [ -n "${metric}" ] && command -v python3 >/dev/null 2>&1; then
    banner=$(python3 "${SCRIPT_DIR}/../render-north-star-banner.py" "${metric}" 2>/dev/null || true)
    [ -n "${banner}" ] && printf '%s\n\n' "${banner}"
  fi
  echo "PROJECT.md North Star (every non-trivial task must trace to this — AGENTS.md §4):"
  echo
  north_star_block "${PROJECT_MD}"
else
  echo "NOTE: PROJECT.md's North Star block is missing or still placeholder text."
  echo "Edits under apps/ and packages/ are hook-blocked until it is filled."
  echo "Run the /north-star kickoff ritual (docs/north-star-kickoff.md) before feature work."
fi

exit 0
