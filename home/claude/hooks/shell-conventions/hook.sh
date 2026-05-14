#!/usr/bin/env bash
# PreToolUse Bash hook for shell conventions.
# Non-blocking reminders only: ag is faster than grep; sed/find are BSD on
# macOS and GNU versions are gsed/gfind.

set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

notes=()

# Plain grep → reminder (non-blocking). Skip git grep, pgrep, etc. by
# anchoring on a word boundary.
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])grep[[:space:]]'; then
  notes+=("\`ag\` (the_silver_searcher) is available and is faster than \`grep\` for large inputs — prefer it when scanning trees or big files.")
fi

# Plain sed → reminder (non-blocking). macOS ships BSD sed; GNU sed is `gsed`.
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])sed[[:space:]]'; then
  notes+=("\`sed\` on this machine is BSD sed, not GNU. GNU sed is available as \`gsed\` — use it if you need GNU-specific syntax (e.g. \`sed -i\` without an extension arg, \`\\b\` word boundaries, etc.).")
fi

# Plain find → reminder (non-blocking). macOS ships BSD find; GNU find is `gfind`.
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])find[[:space:]]'; then
  notes+=("\`find\` on this machine is BSD find, not GNU. GNU find is available as \`gfind\` — use it if you need GNU-specific options.")
fi

if [[ ${#notes[@]} -gt 0 ]]; then
  ctx=$(printf '%s\n' "${notes[@]}")
  jq -n --arg c "$ctx" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      additionalContext: $c
    }
  }'
fi
