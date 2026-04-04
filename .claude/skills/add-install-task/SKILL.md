---
name: add-install-task
description: Add a one-time install task to root mise.toml to sync a hand-installed app from this machine to the other one. Use when the user says something like "I installed Vibe Island on this computer, create a task to add it to my other computer". See CLAUDE.md "One-time install lifecycle".
---

# Add Install Task Skill for dotkyl

Create a new one-time install task in root `mise.toml`. The task exists so the
*other* machine can install the app via `mise run <name>` after being nudged by
a sync reminder. After running, the task self-graduates to `setup/mise.toml`.

## Step 1: Identify the app and install path

The user will name an app (e.g. "Vibe Island"). Claude should:

- Derive a **task name** from the app name: lowercase, hyphenated, e.g.
  `vibe-island`. Confirm with the user only if ambiguous.
- Find **where the app is installed**. For macOS apps this is almost always
  `/Applications/<App Name>.app`. Check with `ls /Applications/ | grep -i <app>`.
- Determine the **install source**. Ask the user:
  - "Is this a Homebrew cask? If so, add it to `setup/Brewfile.*` instead — this
    skill isn't for brew." (stop here if yes)
  - "Is this from the App Store / Setapp / a licensed installer you need to
    sign into, do you have a download URL for a file you'll click through, or
    is there a headless install command (e.g. `curl ... | bash`, a GitHub release
    binary, etc.)?"

The install source determines the branch below.

## Step 2a: Manual install (App Store, Setapp, licensed)

The task can't automate the install — it just directs the user to go do it.
Install task and reminder task do essentially the same thing.

Task template:

```toml
[tasks.<name>]
description = "Install <App Name> (manual, from App Store/etc.)"
run = """
# ...
[ -d "/Applications/<App Name>.app" ] \\
  && echo "⏭️ <App Name> already installed" \\
  || { echo "👉 Install <App Name> from <source>, then run: mise run graduate <name>"; exit 1; }
"""
```

Note: graduation doesn't happen automatically here since install is manual. The
task exits 1 so it's visible in mise output, and the user runs graduate by hand
after installing.

## Step 2b: Direct download URL

The task downloads the file and opens the containing folder in Finder so the
user can run the installer/drag the app themselves.

Task template:

```toml
[tasks.<name>]
description = "Download <App Name> installer"
run = """
# ...
[ -d "/Applications/<App Name>.app" ] && { echo "⏭️ <App Name> already installed"; exit 0; }
curl -fL -o ~/Downloads/<filename> "<download-url>"
open ~/Downloads
echo "👉 Install <App Name>, then run: mise run graduate <name>"
"""
```

Same as 2a — user runs `mise run graduate <name>` after the manual install step.

## Step 2c: Headless install command

The task runs the install command itself and self-graduates on success. No user
intervention needed. This is the pattern for things like `curl ... | bash`
installers or GitHub-release binary drops.

Task template:

```toml
[tasks.<name>]
description = "Install <App Name>"
run = """
# ...
<check-command> \\
  && echo "⏭️ <App Name> already installed" \\
  || { <install-command> && mise run graduate <name>; }
"""
```

The check command depends on what gets installed — e.g. `which <name> >/dev/null`
for a CLI tool, `[ -d /Applications/<App Name>.app ]` for an app, or a
path-specific check for custom install locations.

## Step 3: Compose the reminder block

Reminder is the same across both branches:

```toml
[tasks.<name>-reminder]
description = "Remind to install <App Name> if missing"
run = """
# ...
[ -d "/Applications/<App Name>.app" ] \\
  && echo '⏭️ <App Name> already installed' \\
  || echo '👉 Run: mise run <name>'
"""
```

## Step 4: Insert into root mise.toml

Insert both blocks before the `# NOTE: sync and install share some deps` comment
(i.e., before `[tasks.sync]`).

Add `"<name>-reminder"` to the end of the `sync` task's `depends` array.

## Step 5: Show the user and confirm

Show the new blocks and confirm before committing. The user may want to tweak
wording, the check command, or the download URL.

## Step 6: Commit and push

Use the `commit` skill. Area prefix is `setup:`. The commit must be pushed so
the other machine sees the reminder on its next pull.

## Notes

- Don't run `mise run <name>` on this machine. It's for the other machine.
- If the app was already installed on both machines before the task was written,
  skip this skill and add the task straight to `setup/mise.toml`.
- For brew casks, skip this skill and add to the appropriate `Brewfile.*`.
- Graduation is manual for these app-install tasks (user runs `mise run graduate
  <name>` after the manual install step completes).
