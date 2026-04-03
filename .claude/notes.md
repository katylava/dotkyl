_This file managed by human._

Reminders to self about things to talk to Claude about.

## new mise tasks

### `mise run add-dotfile`

Takes args:

- current path
- repo path
- host (null for all)
- private (default false)
- secrets (default false)

Instead of an inline script this script will live in setup and be called from
the task.

1. Copies current path to repo path, renames for host if necessary
2. Handles secrets (somehow)
3. Adds to symlinks.yml
4. Commits and pushes (after user confirmation)
5. Runs sub-task (mise run sync) to sync symlinks
6. Verifies

To handle secrets, use gitleaks cli to scan for secrets and notify the user.
Ideally, the task itself would add all the secrets to 1password (with a
distinct naming convention) with the op cli, then replace the secrets in the
(copied) file with placeholders which include the 1password key or path. If
not, it should list all the secrets for the user so they can do that manually.

Note: Which 1password vault to use depends on the host value.

### `mise run pre-new-install`

Runs on old computer. Uses a manifest like symlinks.yml (but not symlinks.yml),
to copy files/folders to a machine-state directory. The user can decide how
best to get those files to the new computer.

In addition to copying files, it lists all packages installed with any package
managers, and anything in Applications, and saves the results to text files,
also in the machine-state directory.

Note that this should be host-aware. The user will only be either setting up a
new personal computer, or a new work computer.

### `mise run post-new-install`

Runs on new computer, after initial setup, uses same manifest as
pre-new-install to move files from machine-state to the right places. Depends
on `apply-system-settings`.

### `mise run apply-system-settings`

Uses a manifest file (yml or toml) to configure system settings that can be
programmatically configured, and remind user about ones that have to be
manually configured.

_We should also figure something out for app settings._


## Claude skills

These skills should live in this repo.

### `pre-new-install`

The goal of this skill is to help the user find out what needs to be done for
the new computer to have all the necessary packages, applications, and
configuration that the old computer had. However since computers get crufty
over time, Claude needs to work with the user to determine what is necessary.
This would be run from the old computer only. Like the mise task, it should be
host-aware (personal vs work).

Runs `mise run pre-new-install`. Reads the text files (output by that mise
task) of installed packages and applications. Compares to existing installed
packages manifests in the repo. Helps the user work through what needs to be
added to the manifests so it is installed with `mise run install` on the new
cmoputer. Helps the user get a list of things they'll have to install manually.
Helps the user decide what files they need from application support folders
(maybe updates the pre-new-install manifest for these and runs that task
again).

Checks for system settings that can be programmatically read/set. Goes over
them with the user to see what they want to apply on their new computer, and
updates the manifest for `mise run apply-system-settings`.

Using Claude's general knowledge of the OS for the old and new computers, helps
the user determine if there are other settings, which Claude does not have
visibility into, which the user may want to apply to the new computer. Adds
reminders to the manifest about those.

Finally, pushes up any changes made to this repo during the process.


## Separate install from sync commands

find a way to separate things needing frequent sync and things needing
one-time install/modification/uninstall... different mise.toml files if
possible (maybe one in the install directory for installs, and the repo root
one can be for frequent syncs. so the process for something to sync between two
active computers, would be to put it in the sync file first, then after it is
done on the other computer, move it to the install file. not sure if the moving
it after syncing is something we can program into the mise tasks or if it needs
to something claude knows to take care of, either from CLAUDE.md for this repo
or from a skill


## Installed Applications on both computers

apps installed via downloading from the web -- when i install an app on one
computer that i want on the other, i need some kind of shortcut to add that to
some kind of manifest that mise run sync checks and reminds me to install on
the other computer. ideally the shortcut would allow me to specify the download
url, or at least website.


## Custom claude hooks

Would like to track custom claude hooks in this repo, that get synced with mise
run sync. Would like a hook for updating the tab title that overrides any other
title updates, like from peon-ping or vibe island. Although vibe island's
titles are good, it costs $15 per machine so I'm only going to have it
installed on my work computer. So I need custom hooks that do what it does.


