#!/usr/bin/env bash
# PreToolUse Bash hook: ask before git commands that mutate a repo other
# than the one this session was started in ($CLAUDE_PROJECT_DIR).
#
# Triggered when an agent operating in repo A reaches over and runs a
# write-ish git command (commit, push, rebase, …) in repo B. Surfaces the
# repo paths as a permission prompt so cross-repo work can't slip by.

set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

# Fast path: not a git invocation at all.
if ! printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])git[[:space:]]'; then
  exit 0
fi

# Only guard write-ish verbs. Reads (status, log, diff, show, …) are fine.
if ! printf '%s' "$cmd" | grep -qE \
  '(^|[^[:alnum:]_.-])git([[:space:]]+-[^[:space:]]+)*[[:space:]]+(commit|push|pull|merge|rebase|reset|am|cherry-pick|revert|tag|branch|stash|restore|clean|filter-branch|update-ref|gc|prune|notes)([[:space:]]|$)'; then
  exit 0
fi

# Figure out which directory the git command targets. Three cases to handle:
#   1. `git -C <dir>` redirects git to <dir> regardless of cwd.
#   2. `cd <dir> && git …` runs git after the cd in this same invocation.
#   3. Neither — git runs in $PWD. $PWD usually matches $CLAUDE_PROJECT_DIR,
#      but Claude Code persists cwd across Bash calls, so a prior `cd` can
#      drift the session cwd and the next `git commit` lands in a different
#      repo without any cd/-C in the current command.
# The `-C` match requires it directly after `git` to avoid colliding with
# verb-level `-C` like `git commit -C <hash>`.
target_dir=$PWD
git_c=$(printf '%s' "$cmd" | grep -oE 'git[[:space:]]+-C[[:space:]]+[^[:space:];&|]+' | tail -1 || true)
if [[ -n $git_c ]]; then
  target_dir=$(printf '%s' "$git_c" | awk '{print $NF}')
else
  cd_arg=$(printf '%s' "$cmd" | grep -oE '(^|;|&&|\|\|)[[:space:]]*cd[[:space:]]+[^[:space:];&|]+' | tail -1 || true)
  if [[ -n $cd_arg ]]; then
    target_dir=$(printf '%s' "$cd_arg" | awk '{print $NF}')
  fi
fi
target_dir=${target_dir/#\~/$HOME}

target_repo=$(git -C "$target_dir" rev-parse --show-toplevel 2>/dev/null || true)
session_repo=$(git -C "${CLAUDE_PROJECT_DIR:-$PWD}" rev-parse --show-toplevel 2>/dev/null || true)

# No-op if either side can't be resolved, or they match.
[[ -z $target_repo || -z $session_repo || $target_repo == "$session_repo" ]] && exit 0

reason="This git command targets \`$target_repo\` but the session was started in \`$session_repo\`. Confirm before running."

jq -n --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "ask",
    permissionDecisionReason: $r
  }
}'
