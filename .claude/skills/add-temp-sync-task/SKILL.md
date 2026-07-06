---
name: add-temp-sync-task
description: Add a temporary, self-deleting mise task to root mise.toml that runs a one-time action on the *other* machine after it next pulls, then prints a reminder to delete the task. Use when a change on this machine leaves the other machine needing a one-off action that `mise run sync` / manage-symlinks won't do on its own — e.g. pruning a stale symlink left by a rename, or migrating a config file in place. The action runs once and then the task is deleted, so it's not for durable machine setup. For syncing an app install, use add-install-task instead.
---

# Add Temp Sync Task Skill for dotkyl

Create a temporary task in root `mise.toml` that runs a one-time action on the
*other* machine after it pulls, then is deleted. This is a sibling of
`add-install-task`: both put a one-time task in root `mise.toml` that the other
machine runs once after a pull. They differ in what happens next —
`add-install-task` relocates to `setup/mise.toml` so it persists for a future
new machine, while this one is deleted, because it only reconciles a gap between
two already-diverged machines.

Reach for it when a change you made here leaves the other machine in a state
that the normal sync can't reconcile. The case it was originally written for:
`manage-symlinks` creates and relinks symlinks but never *removes* them, so
renaming or deleting a tracked file leaves a stale symlink on the other machine
that something has to clean up.

## Step 1: Pin down the one-time action

- **What** must happen on the other machine, exactly once (delete a file, prune
  a symlink, rewrite a config, etc.).
- **Why** the normal sync won't do it. If `mise run sync` or `manage-symlinks`
  already handles it, you don't need this skill.
- Derive a **task name**: lowercase, hyphenated, describing the action, e.g.
  `prune-stale-tech-writing-symlink`.

## Step 2: Make it self-limiting

The machine you're on made the change already, so the task must **no-op here**
and act only on the machine that still needs it. Two ways to detect that, in
order of preference:

1. **State detection (preferred).** Find a condition that is already-satisfied
   on this machine and not-yet-satisfied on the other. This is self-verifying
   and needs no hostname. In the worked example below, a valid symlink on this
   host makes `[ ! -e "$link" ]` false, so the whole block is skipped here.
2. **Host detection (fallback).** When there's no observable state difference,
   gate on `host=$(bin/get-host 2>/dev/null)` and check against the target host.

## Step 3: Confirm it's safe to auto-run

The task runs unattended on the other machine's post-merge `mise run sync`, so
the action must be safe to run with no human present — not destructive, not
needing confirmation first. If it isn't safe to auto-run, this pattern doesn't
fit; don't force it into `sync`.

## Step 4: Always remind to delete the task

This is the piece `add-install-task` doesn't have. Within the "applies here"
branch, **unconditionally** print a `👉` reminder to delete the task from
`mise.toml`. Guard the *action* so it runs at most once, but let the reminder
print on every run where the task still applies — the reminder repeats because
the task keeps running each sync until the human removes it, not because any
state persists.

## Step 5: Write the task

Template:

```toml
# One-line note on what change created the need and why sync can't reconcile it.
[tasks."sync:<name>"]
description = "<what it does>, deleted after it's run"
run = '''
# self-limiting condition: true only on the machine that still needs the action
if <needs-action-here>; then
  <guarded one-time action, e.g. rm/mv/edit>
  echo "👉 <action> done on this machine — delete the sync:<name> task from mise.toml"
fi
'''
```

Worked example (the task this skill was extracted from):

```toml
# The tech-writing skill moved to tech-writing--personal, so it's only symlinked
# on the personal host. manage-symlinks creates/relinks but never removes, so the
# old ~/.claude/skills/tech-writing symlink lingers (now broken) on other hosts.
# Prune it when broken, and keep reminding to delete this task until it's gone.
[tasks."sync:prune-stale-tech-writing-symlink"]
description = "Remove the stale tech-writing skill symlink left by the --personal rename"
run = '''
link="$HOME/.claude/skills/tech-writing"
# -e is false for both a broken symlink (pre-prune) and an absent path
# (post-prune); a valid symlink on personal makes it true and skips the block.
if [ ! -e "$link" ]; then
  if [ -L "$link" ]; then
    rm "$link" && echo "✅ removed stale tech-writing symlink" || echo "❌ failed to remove $link"
  fi
  echo "👉 tech-writing cleanup done on this machine — delete the sync:prune-stale-tech-writing-symlink task from mise.toml"
fi
'''
```

Note how the action (`rm`) is guarded by `[ -L "$link" ]` so it fires only the
once, while the `👉` reminder prints on every run until the task is deleted.

## Step 6: Insert into root mise.toml

Insert before `[tasks.sync]`. No depends-list edits — `sync:**` picks it up.

## Step 7: Show the user and confirm

Show the block and confirm the self-limiting condition is right before
committing — getting it wrong either misfires on this machine or never fires on
the other.

## Step 8: Commit and push

Use the `commit` skill. Pick the area prefix from what the change is *about* —
usually the same area as the change that created the need (the tech-writing
example committed under `skills:`), not `setup:` by default. The commit must be
pushed so the other machine runs it on its next pull.
