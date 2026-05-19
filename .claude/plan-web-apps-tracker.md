# Plan: Web-Downloaded Apps Tracker

A separate sync mechanism for apps installed by downloading from the
web (not via brew/mas/mise).

## Spec

Verbatim from `notes.md` (the human's original text — do not paraphrase
this; add interpretation around it instead):

> ## Installed Applications on both computers
>
> apps installed via downloading from the web -- when i install an app on one
> computer that i want on the other, i need a way to record it so a sync check
> reminds me to install it on the other computer. the shortcut for adding an
> entry should let me specify the download url, or at least the website.
>
> this is NOT solved by add-install-task. that skill writes one-time tasks into
> the root mise.toml, which gets messy fast. i want a SEPARATE process: its own
> manifest of web-downloaded apps, plus a dedicated task (or skill) that runs
> tasks from that separate manifest -- never touching the root mise.toml.

## Interpretation and scope notes

- **Why not `add-install-task`.** That skill is for *one-time* installs
  that disappear after running on both machines (`mise run stow`).
  Web-downloaded apps are a *persistent* inventory: the entry should
  stay forever, not get stowed. Different lifecycle → different tool.
- **Manifest shape.** Something like
  `setup/manifests/web-apps.yml` with entries per app: name, download
  URL or website, optional host scoping (`personal` / `work` / both),
  optional notes. Probably also a "version last installed" field per
  host, or a `.installed-on-<host>` flag file, so the sync check can
  tell who still needs it.
- **Sync check.** A `sync:web-apps` task that lists apps in the
  manifest scoped to the current host and not yet marked installed
  here. Prints reminders in the existing `👉 Run: ...` style so it
  surfaces during post-merge `mise run sync`.
- **"Mark as installed" path.** Once the user installs on the second
  machine, they need a one-liner to mark the entry done for that host
  (so the reminder stops firing). Likely a small `bin/` script or a
  `mise run web-apps:mark <name>` task.
- **Shortcut for adding entries.** Spec calls for ease of adding; a
  `bin/` script or skill that takes app name + URL and appends to the
  manifest. Should detect the current host so the new entry starts as
  "installed here, needs install on other host."
- **Distinct from `Brewfile.*`.** Apps in this manifest are exactly
  those that *can't* live in a Brewfile (no cask, or user prefers
  direct download). Don't try to unify.

## Scope cuts to consider

- **v0:** manifest file + sync-check task only. No add-entry shortcut
  (user hand-edits YAML). No mark-installed automation (user hand-edits
  to flip a flag). Useful immediately and small.
- **v1:** add-entry script.
- **v2:** mark-installed automation.

## Status

User-driven only. Do not propose work on this; the user will surface it
when they hit the friction.
