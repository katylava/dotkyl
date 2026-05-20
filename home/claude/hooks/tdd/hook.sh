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
    additionalContext: "If this file is application code, follow strict red-green TDD: write ONE failing test for the smallest next behavior, run it and confirm it fails for the expected reason, then write the minimum code to make that one test pass, then run all tests. Only after green do you write the next test. Do NOT write multiple tests up front. Do NOT write the full implementation before the tests exist. One test, one implementation step, repeat. If this file is a script (any language), skip TDD — verify by running the script against real inputs."
  }
}'
