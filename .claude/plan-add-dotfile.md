# Plan: `mise run add-dotfile`

Automate the currently-manual workflow of bringing a new dotfile under
repo management.

## Relationship to `plan-audit-dotfiles.md`

**These go hand-in-hand. The audit must come first.**

`add-dotfile` automates the manual "Process for Adding Files" section of
`plan-audit-dotfiles.md` — copy into `home/`, route public vs private,
rename for host, add to `symlinks.yml`, run sync, verify, commit.

The audit determines *which `add-dotfile` features actually carry the
value*:

- How many files are host-specific → how much the `--<host>` rename +
  host-conditional symlink routing matters.
- How many contain secrets → whether the gitleaks/`op`/placeholder path
  is worth building or a scan-and-refuse stub is enough for now.
- How many live in mixed directories (e.g. `gh/`, `.claude/skills/`) →
  whether per-file / partial-directory routing is needed.

Until the audit is done, scoping this task is guesswork — we'd be
guessing which of the hard parts (host routing, secret handling, per-file
routing) the real backlog of untracked files actually needs. So: **do
the audit first, then let its findings drive this task's scope.** The
audit also designs the `symlinks.yml` host-conditional / per-file routing
that this task depends on.

## Spec

Verbatim from `notes.md` (the human's original text — do not paraphrase
this; add interpretation around it instead):

> Takes args:
>
> - current path
> - repo path
> - host (null for all)
> - private (default false)
> - secrets (default false)
>
> Instead of an inline script this script will live in setup and be called from
> the task.
>
> 1. Copies current path to repo path, renames for host if necessary
> 2. Handles secrets (somehow)
> 3. Adds to symlinks.yml
> 4. Commits and pushes (after user confirmation)
> 5. Runs sub-task (mise run sync) to sync symlinks
> 6. Verifies
>
> To handle secrets, use gitleaks cli to scan for secrets and notify the user.
> Ideally, the task itself would add all the secrets to 1password (with a
> distinct naming convention) with the op cli, then replace the secrets in the
> (copied) file with placeholders which include the 1password key or path. If
> not, it should list all the secrets for the user so they can do that manually.
>
> Note: Which 1password vault to use depends on the host value.

## Proposed v1 (pending audit findings)

Common path only — public, all-hosts, no secrets:

- Copy into `home/`, add the `symlinks.yml` entry, run the sync
  sub-task, verify, commit on confirmation.
- No prerequisites; clean reviewable chunk.

Deferred, each its own follow-up chunk:

- **Secret handling** — v1 runs a gitleaks scan and *refuses + reports*
  if it finds anything, rather than handling it.
- **Host-specific routing** — depends on the `symlinks.yml`
  host-conditional gap the audit plan owns; v1 punts.

Whether v1 is even the right cut is itself an audit-findings question —
don't lock it in before the audit.
