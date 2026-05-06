#!/usr/bin/env bash
# PreToolUse Bash hook: block commands that violate shell conventions, forcing
# Claude to retry with the preferred form.

set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

reasons=()

# python3 / pip3 → python / pip
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_./-])(python3|pip3)([[:space:]]|$)'; then
  reasons+=("Use \`python\`/\`pip\`, not \`python3\`/\`pip3\` — same binary on this machine.")
fi

# Plain grep → ag. Skip git grep, pgrep, etc. by anchoring on a word boundary.
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])grep[[:space:]]'; then
  reasons+=("Use \`ag\` instead of \`grep\`.")
fi

# Plain sed → gsed (GNU sed; accepts the syntax you already know).
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])sed[[:space:]]'; then
  reasons+=("Use \`gsed\` (GNU) instead of \`sed\` (BSD).")
fi

# Plain find → gfind.
if printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])find[[:space:]]'; then
  reasons+=("Use \`gfind\` (GNU) instead of \`find\` (BSD).")
fi

if [[ ${#reasons[@]} -eq 0 ]]; then
  exit 0
fi

reason=$(printf '%s\n' "${reasons[@]}")

jq -n --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $r
  }
}'
