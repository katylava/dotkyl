# Plan: New-Machine Setup Tooling

Three new mise tasks plus one Claude skill, all in service of moving
from an old machine to a new one (or a clean reinstall on the same
machine). Tightly related — share a manifest, share a host-awareness
model, and the skill drives the mise tasks. Tracked here as one plan.

## Spec (mise tasks)

Verbatim from `notes.md` (the human's original text — do not paraphrase
this; add interpretation around it instead):

> ### `mise run pre-new-install`
>
> Runs on old computer. Uses a manifest like symlinks.yml (but not symlinks.yml),
> to copy files/folders to a machine-state directory. The user can decide how
> best to get those files to the new computer.
>
> In addition to copying files, it lists all packages installed with any package
> managers, and anything in Applications, and saves the results to text files,
> also in the machine-state directory.
>
> Note that this should be host-aware. The user will only be either setting up a
> new personal computer, or a new work computer.
>
> ### `mise run post-new-install`
>
> Runs on new computer, after initial setup, uses same manifest as
> pre-new-install to move files from machine-state to the right places. Depends
> on `apply-system-settings`.
>
> ### `mise run apply-system-settings`
>
> Uses a manifest file (yml or toml) to configure system settings that can be
> programmatically configured, and remind user about ones that have to be
> manually configured.
>
> _We should also figure something out for app settings._

## Spec (Claude skill)

Verbatim from `notes.md`:

> ### `pre-new-install`
>
> The goal of this skill is to help the user find out what needs to be done for
> the new computer to have all the necessary packages, applications, and
> configuration that the old computer had. However since computers get crufty
> over time, Claude needs to work with the user to determine what is necessary.
> This would be run from the old computer only. Like the mise task, it should be
> host-aware (personal vs work).
>
> Runs `mise run pre-new-install`. Reads the text files (output by that mise
> task) of installed packages and applications. Compares to existing installed
> packages manifests in the repo. Helps the user work through what needs to be
> added to the manifests so it is installed with `mise run install` on the new
> cmoputer. Helps the user get a list of things they'll have to install manually.
> Helps the user decide what files they need from application support folders
> (maybe updates the pre-new-install manifest for these and runs that task
> again).
>
> Checks for system settings that can be programmatically read/set. Goes over
> them with the user to see what they want to apply on their new computer, and
> updates the manifest for `mise run apply-system-settings`.
>
> Using Claude's general knowledge of the OS for the old and new computers, helps
> the user determine if there are other settings, which Claude does not have
> visibility into, which the user may want to apply to the new computer. Adds
> reminders to the manifest about those.
>
> Finally, pushes up any changes made to this repo during the process.

## Interpretation and scope notes

- **Manifest shape.** The pre/post pair share one manifest. Likely sits
  in `setup/manifests/` next to `symlinks.yml` (e.g.
  `new-machine.yml`). Entries name source paths and destination
  treatment ("copy to machine-state, restore to original location" vs
  "copy to machine-state, user will decide"). Host-awareness via the
  same `--<host>` convention used elsewhere.
- **Machine-state directory.** Out-of-repo by default (e.g.
  `~/machine-state/`) since some of its contents are sensitive or
  large. The user "decides how best to get those files to the new
  computer" — likely a thumb drive / external SSD, occasionally
  iCloud. The repo only owns the manifest, not the snapshot itself.
- **Package listings.** Likely brew, mise, npm-global, pipx, mas, plus
  `/Applications` listing. Output format is "text files" per spec —
  one per source, in machine-state.
- **`apply-system-settings` manifest.** Each entry needs a read command
  (to capture current value) and a set command (to apply on new
  machine), plus a category (programmatic vs manual reminder). The
  skill helps populate this from the old machine's actual state.
- **App settings (`_We should also figure something out for app
  settings._`).** Open question in the spec. Possibilities: per-app
  `defaults read`/`defaults write` entries in the system-settings
  manifest, or a separate "app preferences" snapshot category in the
  new-machine manifest pointing at `~/Library/Preferences/<bundle>.plist`.
- **Skill flow.** Skill drives the mise task, then walks the user
  through diffs between captured listings and existing manifests
  (`Brewfile.*`, `mise.toml`, etc.). Treat each unmatched entry as a
  decision: add to manifest / install-once task / skip / install
  manually on new machine.
- **Old `clean-install.md` reference.** A pre-existing
  `clean-install.md` doc (out of date, deleted alongside this plan
  update) had a backup + bootstrap sequence for setting up a new
  machine. Worth scanning before designing the new flow. Last present
  at HEAD `7107e00`; retrieve with
  `git show 7107e00:clean-install.md`.
- **Relationship to `mise run install`.** Existing `install` handles
  the "given a populated manifest, set the machine up" path. These new
  tasks handle "discover what should be in the manifest by surveying
  the old machine."

## Scope cuts to consider

The full spec is large. Possible smaller first cuts:

- **v0:** just the package-listing half of `pre-new-install` (brew, mise,
  /Applications dumps to a directory). No manifest, no file-copying.
  Useful immediately for sanity-checking what's installed.
- **v0a:** just `apply-system-settings` with a hand-written manifest of
  the user's top-priority settings (keyboard repeat rate, dock prefs,
  Finder defaults). No discovery, no skill.

Defer scoping until the user is actively planning a new install — pre-
designing further risks building the wrong thing.

## Status

User-driven only. Do not propose work on this; the user will surface it
when a clean install is on the horizon.
