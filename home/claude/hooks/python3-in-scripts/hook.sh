#!/usr/bin/env bash
# PreToolUse Edit/Write hook: deny adding python3/pip3 to scripts and
# task-runner config. They're the same binary as python/pip on this machine,
# and the bare names travel better.
#
# Allows edits that preserve pre-existing python3/pip3 (so Claude can edit
# legacy files without tripping the hook), and edits that remove python3/pip3.

set -euo pipefail

input=$(cat)

tool=$(printf '%s' "$input" | jq -r '.tool_name // ""')
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')

case "$tool" in
  Write) new=$(printf '%s' "$input" | jq -r '.tool_input.content // ""'); old="" ;;
  Edit)  new=$(printf '%s' "$input" | jq -r '.tool_input.new_string // ""'); old=$(printf '%s' "$input" | jq -r '.tool_input.old_string // ""') ;;
  *)     exit 0 ;;
esac

# Does the file path look like a script or task-runner config?
is_script=false
case "$path" in
  *.sh|*.zsh|*.bash|*.py) is_script=true ;;
  */bin/*) is_script=true ;;
  *mise.toml|*Makefile|*makefile|*.mk) is_script=true ;;
  *crontab*.txt) is_script=true ;;
esac

# Or does the new content start with a shebang?
if [[ $is_script == false ]] && printf '%s' "$new" | head -n1 | grep -qE '^#!'; then
  is_script=true
fi

[[ $is_script == false ]] && exit 0

pat='(^|[^[:alnum:]_./-])(python3|pip3)([[:space:]]|$)'

# Allow if new content doesn't introduce python3/pip3.
printf '%s' "$new" | grep -qE "$pat" || exit 0

# Allow if old content already had it (edit isn't introducing it).
if [[ -n "$old" ]] && printf '%s' "$old" | grep -qE "$pat"; then
  exit 0
fi

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: "Do not put `python3`/`pip3` in scripts or task-runner config — use `python`/`pip` instead. Same binary on this machine, and the bare names travel better."
  }
}'
