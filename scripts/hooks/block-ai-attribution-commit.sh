#!/usr/bin/env bash
# Claude Code PreToolUse hook (Bash matcher) — blocks `git commit`
# commands that carry AI attribution in the commit message.
#
# Wired via .claude/settings.json (tracked, project-level). This is the
# earliest gate in the chain: it fires at commit time inside the agent
# harness, before husky's pre-push scan and before CI. Unlike husky it
# needs no `pnpm install` to be armed, and unlike the pre-push scan it
# stops the attribution before it ever enters history (no rebase needed
# to remove it).
#
# Contract (per Claude Code hooks): JSON on stdin describing the tool
# call; exit 0 = allow, exit 2 = block (stderr is fed back to the
# agent). We deliberately DON'T parse the JSON (no jq dependency) —
# a raw grep over the payload is sufficient here, and a rare false
# positive (e.g. a command that merely quotes the banned phrase) is an
# acceptable cost for this rule: the agent sees the explanation and can
# rephrase.

set -u

INPUT=$(cat)

# Only inspect git commit invocations. Deliberately unbounded between
# `git` and `commit` (no token-count cap) — a bounded cap (e.g. "at
# most 4 tokens") is a real bypass: `git -C <path> -c user.name=a -c
# user.email=b -c commit.gpgsign=false commit -m "..."` is a completely
# ordinary invocation an agent would use in a sandbox with no
# configured git identity, and it alone has 9 intervening tokens.
# Being this loose on the pre-filter is safe: a false positive here
# only means we also run the attribution grep below on a non-commit
# command, which is harmless (it just won't match and falls through to
# exit 0). The failure mode this guards against — a false NEGATIVE that
# skips the attribution check entirely — is the one that matters, and
# an unbounded match closes it.
printf '%s' "${INPUT}" | grep -qiE 'git[[:space:]].*commit' || exit 0

if printf '%s' "${INPUT}" | grep -qiE 'co-authored-by[^"]{0,40}(claude|anthropic)|generated[[:space:]]+with[^"]{0,40}claude|🤖'; then
  {
    echo "BLOCKED: this git commit contains AI attribution."
    echo "Per AGENTS.md §5: no Co-Authored-By: Claude/Anthropic trailers,"
    echo "no 'Generated with Claude Code' footers, no robot emoji."
    echo "Re-run the commit with those lines removed from the message."
  } >&2
  exit 2
fi

exit 0
