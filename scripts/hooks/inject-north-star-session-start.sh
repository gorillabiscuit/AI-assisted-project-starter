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
# The Metric is framed in a simple bordered box — the "normal" display
# of the star. The full ASCII star scene is deliberately NOT shown here:
# it is the /north-star ritual's finalisation reveal (kickoff or a
# revise-mode change), shown once when the star is set, not re-flashed
# every session. Session start just keeps the one line in a clean frame.
#
# Always exits 0: a session must never fail to start over this.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/north-star-block.sh
source "${SCRIPT_DIR}/../lib/north-star-block.sh"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_MD="${PROJECT_DIR}/PROJECT.md"

# Print one metric sentence inside a plain bordered box. Pure awk so the
# hook carries no interpreter dependency; wraps to a fixed width.
metric_box() {
  awk -v text="$1" 'BEGIN{
    tw=54
    n=split(text, w, " "); line=""; nl=0
    for(i=1;i<=n;i++){ cand=(line==""?w[i]:line" "w[i])
      if(length(cand)>tw){ L[++nl]=line; line=w[i] } else line=cand }
    if(line!="") L[++nl]=line
    b="+"; for(i=0;i<tw+4;i++) b=b"-"; b=b"+"; print b
    t="N O R T H   S T A R"; pad=(tw+4)-length(t); lp=int(pad/2); rp=pad-lp
    s="|"; for(i=0;i<lp;i++) s=s"."; s=s t; for(i=0;i<rp;i++) s=s"."; print s"|"
    printf("|%*s|\n", tw+4, "")
    for(j=1;j<=nl;j++) printf("|  %-*s  |\n", tw, L[j])
    printf("|%*s|\n", tw+4, "")
    print b
  }'
}

if north_star_is_filled "${PROJECT_MD}"; then
  metric=$(north_star_metric "${PROJECT_MD}" 2>/dev/null || true)
  if [ -n "${metric}" ]; then
    metric_box "${metric}"
    echo
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
