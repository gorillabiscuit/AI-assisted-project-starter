#!/usr/bin/env bash
# scripts/scan-ai-attribution.sh — pre-push gate.
#
# Aborts the push if any commit on this branch (vs the base branch)
# contains an AI-attribution trailer in its commit message TRAILERS.
# Per AGENTS.md §5.
#
# Wired into .husky/pre-push as the AI-attribution scan step. To
# install (one-time per clone):
#   pnpm install                         # runs `husky install` via prepare script
#
# Why this exists: relying on the human to remember to grep for trailers
# before every push has failure modes (forgetting, slipping a trailer
# during an amend, etc). Making the push itself fail closes the gap.
#
# Two scans per commit, because the two attribution styles have
# different shapes:
#
# 1. Trailer scan (git interpret-trailers --parse) — catches
#    "Co-Authored-By: Claude/Anthropic" trailers. Parsing actual
#    trailers (key:value lines at the end of a commit message) is
#    robust against false positives where the commit message body
#    PROSE mentions phrases like "Co-Authored-By: Claude" while
#    explaining a rule.
#
# 2. Body-line scan — catches the "🤖 Generated with [Claude Code](…)"
#    footer. That footer is NOT a key:value trailer, so
#    interpret-trailers strips it and a trailer-only scan misses it
#    entirely (a footer-only commit passed the old scan). The body
#    scan anchors at line start, so prose that mentions the phrase
#    mid-sentence doesn't trip it.
#
# Exit 0 = clean. Exit 1 = attribution found, push aborted.

set -u
set -o pipefail

# Configurable: override BASE_BRANCH via env if you're targeting a
# branch other than origin/main. For most workflows the default works.
BASE_BRANCH="${PRE_PUSH_BASE_BRANCH:-origin/main}"

# STRICT: set by CI (see .github/workflows/ci.yml) to turn "can't
# resolve base branch" from a silent pass into a hard failure. Local
# pushes stay lenient (offline, initial push, untracked base branch are
# all normal); CI is the backstop and must not be able to regress into
# a silent no-op the way it did before this flag existed — a checkout
# misconfiguration should fail loudly, not scan zero commits and pass.
STRICT="${AI_ATTRIBUTION_STRICT:-0}"

# Pattern vocabulary is shared with scripts/hooks/block-ai-attribution-commit.sh
# via scripts/lib/ai-attribution-patterns.sh — see that file for why.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/ai-attribution-patterns.sh
source "${SCRIPT_DIR}/lib/ai-attribution-patterns.sh"

# Scan 1 pattern — matched against PARSED TRAILERS only. The grep is
# case-insensitive; the pattern allows flexible whitespace because
# canonical trailers use exactly one space but obfuscation attempts
# might vary.
TRAILER_PATTERN="${AI_ATTRIB_COAUTHOR_PATTERN}"

# Scan 2 pattern — matched against every line of the full commit
# message body, anchored at line start (a "Generated with" footer is
# always its own line; prose mentions mid-sentence don't match).
BODY_PATTERN="^[[:space:]]*${AI_ATTRIB_GENERATED_PATTERN}"

# Best-effort fetch so the comparison range is accurate. Don't fail the
# scan if the fetch fails (offline, no remote, etc) — the scan still
# uses local refs in that case.
git fetch --quiet origin 2>/dev/null || true

# If the base branch isn't reachable locally: in STRICT mode (CI) this
# is a hard failure — a backstop that silently scans nothing is worse
# than no backstop, because it looks green. Outside STRICT (local
# pushes) don't block — warn and exit clean, since offline pushes and
# untracked base branches are normal there.
if ! git rev-parse --verify "${BASE_BRANCH}" >/dev/null 2>&1; then
  if [ "${STRICT}" = "1" ]; then
    echo "ERROR: ${BASE_BRANCH} not reachable in STRICT mode — refusing to" >&2
    echo "silently pass. Fetch the base ref before running this script" >&2
    echo "(see .github/workflows/ci.yml for the CI invocation)." >&2
    exit 1
  fi
  echo "WARN: ${BASE_BRANCH} not reachable; skipping AI-attribution scan." >&2
  exit 0
fi

# Walk every commit on this branch beyond the base. For each commit,
# run both scans: parsed trailers against TRAILER_PATTERN, full body
# lines against BODY_PATTERN.
OFFENDERS=""
while IFS= read -r SHA; do
  [ -z "${SHA}" ] && continue
  BODY=$(git show "${SHA}" --format='%B' --no-patch)
  TRAILERS=$(printf '%s\n' "${BODY}" | git interpret-trailers --parse 2>/dev/null || true)
  HIT=0
  if [ -n "${TRAILERS}" ] && printf '%s\n' "${TRAILERS}" | grep -iE "${TRAILER_PATTERN}" >/dev/null; then
    HIT=1
  fi
  if printf '%s\n' "${BODY}" | grep -iE "${BODY_PATTERN}" >/dev/null; then
    HIT=1
  fi
  if [ "${HIT}" -eq 1 ]; then
    OFFENDERS="${OFFENDERS}\n  $(git log -1 --format='%h %s' "${SHA}")"
  fi
done < <(git log "${BASE_BRANCH}..HEAD" --format='%H' 2>/dev/null)

if [ -n "${OFFENDERS}" ]; then
  echo
  echo "ERROR: AI attribution detected in a commit message. Push aborted."
  echo "Per AGENTS.md §5, no Co-Authored-By: Claude trailers and no"
  echo "Generated with Claude Code footers are allowed."
  echo
  echo -e "Offending commits:${OFFENDERS}"
  echo
  echo "To fix:"
  echo "  1. Identify the commit (use the SHAs above)."
  echo "  2. Amend it to strip the attribution:"
  echo "       git rebase -i <commit-before-offender>"
  echo "       (mark the offender as 'reword', strip the line, save)."
  echo "  3. Push again."
  echo
  echo "Bypass (DISCOURAGED — only for true emergencies):"
  echo "  git push --no-verify"
  exit 1
fi

exit 0
