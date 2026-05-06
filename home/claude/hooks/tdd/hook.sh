#!/usr/bin/env bash
# PreToolUse Edit/Write hook: remind to write a failing test first if the
# target file is application code.

set -euo pipefail

path=$(jq -r '.tool_input.file_path // ""')

case "$path" in
  *.py|*.ts|*.tsx|*.js|*.jsx|*.lua|*.go|*.rb) ;;
  *) exit 0 ;;
esac

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    additionalContext: "If this file is application code, write a failing test first, confirm it fails, then implement to make it pass. If it is a script (any language), skip TDD — verify by running the script against real inputs."
  }
}'
