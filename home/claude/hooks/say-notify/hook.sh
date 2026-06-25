#!/usr/bin/env bash
# Notification + PermissionRequest hook: speak a short alert via `say` so the
# user hears, while away from the keyboard, when Claude needs approval or is
# asking a question.
#
# Companion to peon-ping. peon keeps owning completion/error/start *sounds*;
# this speaks the approval/question events instead. To make speech truly
# replace peon's sound there (not layer on top), peon's `input.required`
# category is set to false on each machine (peon's config.json is per-machine
# and not tracked in this repo).
#
# Registered async in ~/.claude/settings.json; synced via
# setup/manifests/claude-settings.shared.toml.
#
# Event payloads (Claude Code):
#   PermissionRequest -> .tool_name           (the canonical approval signal)
#   Notification      -> .notification_type    in {permission_prompt,
#                                                  idle_prompt,
#                                                  elicitation_dialog}
# We speak PermissionRequest and Notification/elicitation_dialog only:
#   - permission_prompt is the same approval as PermissionRequest -> skip (no
#     double-speak)
#   - idle_prompt is folded into peon's completion sound -> leave to peon

set -euo pipefail

payload=$(cat)

event=$(printf '%s' "$payload" | jq -r '.hook_event_name // ""')
cwd=$(printf '%s' "$payload" | jq -r '.cwd // ""')
project=${cwd##*/}

phrase=""
case "$event" in
  PermissionRequest)
    tool=$(printf '%s' "$payload" | jq -r '.tool_name // "a tool"')
    phrase="${project:+$project: }approval needed for $tool"
    ;;
  Notification)
    ntype=$(printf '%s' "$payload" | jq -r '.notification_type // ""')
    if [[ "$ntype" == "elicitation_dialog" ]]; then
      phrase="${project:+$project: }Claude has a question"
    fi
    ;;
esac

[[ -z "$phrase" ]] && exit 0

# Background the speech so the hook returns immediately (also async in
# settings). `say` otherwise blocks for the duration of the utterance.
say "$phrase" &
exit 0
