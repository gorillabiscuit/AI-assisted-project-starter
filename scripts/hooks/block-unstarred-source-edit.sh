#!/usr/bin/env bash
# Claude Code PreToolUse hook (Edit|Write matcher) — blocks edits to
# source files under apps/ and packages/ while PROJECT.md's North Star
# block is missing or still placeholder text.
#
# Wired via .claude/settings.json (tracked, project-level). This is the
# mechanical half of the AGENTS.md §4 relevance gate: the prose version
# asks the agent to trace work to the North Star, but an evidence audit
# of a real project (helpme2c: 30 commits, 20 PRs) found the prose-only
# gate left zero footprint. This hook makes the precondition — a filled
# North Star — un-skippable: no feature code changes until the kickoff
# ritual has run. Doc/config/script edits stay allowed so the ritual
# itself (which writes PROJECT.md) is never blocked by its own gate.
#
# Contract (per Claude Code hooks): JSON on stdin describing the tool
# call; exit 0 = allow, exit 2 = block (stderr is fed back to the
# agent). Like the attribution hook we don't take a jq dependency —
# but unlike it we DO extract the file_path field rather than grepping
# the whole payload, because here a loose whole-payload match would
# block on file CONTENT mentioning apps/ (constant false positives),
# not just the target path.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/north-star-block.sh
source "${SCRIPT_DIR}/../lib/north-star-block.sh"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

INPUT=$(cat)

# Pull the file_path value out of the tool-call JSON. Good enough
# without a JSON parser: paths containing literal `"` would evade this,
# but such a path is not creatable on most filesystems agents target,
# and the cost of over-engineering here outweighs it.
FILE_PATH=$(printf '%s' "${INPUT}" \
  | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | head -1 \
  | sed -E 's/^"file_path"[[:space:]]*:[[:space:]]*"//; s/"$//')

# No file_path in the payload — nothing to gate.
[ -n "${FILE_PATH}" ] || exit 0

# Normalise to a project-relative path. Absolute paths outside the
# project are not this hook's business; relative paths are taken as
# project-relative (that is how the harness resolves them).
REL_PATH="${FILE_PATH}"
case "${FILE_PATH}" in
  "${PROJECT_DIR}"/*) REL_PATH="${FILE_PATH#"${PROJECT_DIR}"/}" ;;
  /*) exit 0 ;;
esac

# Lesson from the attribution hook (see its commit history): match
# loosely on the pre-filter, strictly on the block condition. The
# strict condition here is the placeholder check below; the path match
# stays broad — anything under apps/ or packages/ at any depth,
# including files created there via Write. `./`-prefixed spellings are
# normalised so `./apps/x.ts` can't slip past the case match.
REL_PATH="${REL_PATH#./}"
case "${REL_PATH}" in
  apps/*|packages/*) ;;
  *) exit 0 ;;
esac

if north_star_is_filled "${PROJECT_DIR}/PROJECT.md"; then
  exit 0
fi

{
  echo "BLOCKED: edit to '${REL_PATH}' — PROJECT.md's North Star block is missing or still placeholder text."
  echo "Per AGENTS.md §4, no source work under apps/ or packages/ until the North Star is defined."
  echo "Run the /north-star kickoff ritual (see docs/north-star-kickoff.md) to fill it, then retry."
  echo "Doc, config, and script edits are not blocked — only apps/ and packages/."
} >&2
exit 2
