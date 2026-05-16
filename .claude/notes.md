_This file managed by human._

Reminders to self about things to talk to Claude about.

## new mise tasks

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


## Installed Applications on both computers

apps installed via downloading from the web -- when i install an app on one
computer that i want on the other, i need a way to record it so a sync check
reminds me to install it on the other computer. the shortcut for adding an
entry should let me specify the download url, or at least the website.

this is NOT solved by add-install-task. that skill writes one-time tasks into
the root mise.toml, which gets messy fast. i want a SEPARATE process: its own
manifest of web-downloaded apps, plus a dedicated task (or skill) that runs
tasks from that separate manifest -- never touching the root mise.toml.

