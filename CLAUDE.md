# CLAUDE.md

Personal dotfiles repo (`~/.dotkyl`) for macOS (Apple Silicon).

@README.md

## Applying Changes

- Reload shell after edits: open a new terminal tab
- Apply symlinks: `setup/bin/manage-symlinks` (supports `--dry-run`)

## Conventions

### Zsh Loading Order

`~/.zshenv` sources `lib/010-aliases.zsh` only (runs for all zsh instances).
`~/.zshrc` sources all `lib/*.zsh` and `private/lib/*.zsh` files in numeric order, skipping
host-specific files that don't match the current host.

### Host-Specific Files

Files named `*--<host>.zsh` (e.g., `010-aliases--work.zsh`) are only loaded when `get-host`
returns that host name. Current hosts: `personal`, `work`. This pattern also applies to
crontab files and Brewfiles.

### Dotfile Symlinking

Symlinks are declared in `setup/manifests/symlinks.yml` and applied by `setup/bin/manage-symlinks`.
The `private/` submodule mirrors the `home/` structure for sensitive files.

### Shell Scripts

Prefer `#!/usr/bin/env zsh` over bash for new scripts. This is a zsh-centric repo on macOS —
no need to stay POSIX-portable. All scripts in `bin/` are on `$PATH`.

### Mise Tasks (`mise.toml`)

`mise run install` ensures the machine is in the correct state. `mise run sync` runs just the
fast tasks (used by the post-merge hook).

`setup/mise.toml` holds stowed one-time per-machine installs. After the initial
bootstrap, run `cd setup && mise run install` to install them on a new machine.

One-time per-machine install tasks get created in root `mise.toml`, then move
into `setup/mise.toml` via `mise run stow <name>` after running on the second
machine. Use the `add-install-task` skill to create new ones.

Tasks are grouped by name prefix:
- `setup:*` — shared infra (git-hook, symlinks, crontab, private-repo); runs in both `sync` and `install`
- `sync:*` — fast checks/reminders; runs in `sync` only
- `install:*` — slow real installs; runs in `install` only

`sync` and `install` depend on these via wildcards (`sync:**`, `install:**`),
so new tasks only need the right prefix — no depends-list edits.

Each task uses inline check-or-run logic for idempotency:
```toml
[tasks."install:example"]
run = "check-command || fix-command"
```

Echo output uses emoji to indicate state:
- ⏭️ already done — ✅ ran successfully — ❌ failed — 👉 manual action needed

**Confirm tasks must not be dependencies.** Mise's `confirm` field hides output from other
parallel tasks. Instead, create two tasks: the confirm task itself (run manually), and a
reminder task under the `sync:` prefix. The reminder should include a check so it only
prints when the action hasn't been done yet.

```toml
# The actual task (run manually: mise run install:migrate-espanso)
[tasks."install:migrate-espanso"]
confirm = "Export Dash snippets first (Dash → Preferences → Snippets → Export). Ready?"
run = "brew install espanso && brew uninstall dash"

# The reminder (picked up by sync:** wildcard)
[tasks."sync:migrate-espanso"]
run = "which espanso >/dev/null || echo '👉 Run: mise run install:migrate-espanso'"
```

### Claude Code Settings Sync

A chosen subset of `~/.claude/settings.json` is kept in sync between machines
via `setup/manifests/claude-settings.shared.toml` (the source of truth) and the
`mise run claude-settings-sync` task. The TOML lists each synced key as an
entry with `read`/`set` yq filter expressions and a `value`. Use literal
`$HOME` in `value` for paths — the script substitutes the real home dir at
apply time and back to `$HOME` at capture time.

- `mise run claude-settings-sync` — show drift between repo and host (default)
- `mise run claude-settings-sync to-host` — apply repo values to `~/.claude/settings.json`, and remove any hook entries whose absolute-path command is missing on disk
- `mise run claude-settings-sync to-repo` — capture host values back into the TOML

The diff is wired into `mise run sync`, so the post-merge hook surfaces drift.

For a fixture-based test run, override the live file path:
```sh
CLAUDE_SETTINGS_LIVE=/tmp/some-fixture.json mise run claude-settings-sync to-host
```

### Commits

Always use the /commit skill for commits — never commit manually.

## Workflow

- Default to committing directly to `main` for ordinary changes (fixes, tweaks, single-task
  work). Do **not** create a feature branch for these — this overrides the global CLAUDE.md
  "create a feature branch" workflow rule, which does not apply to routine work here. Day-to-day
  history is linear on `main`; the only merges are pull-merges from syncing two machines.
- Exception: a feature branch is warranted only when working from a written plan (e.g. a
  `.claude/plan-*.md` file) whose scope is large. Ad-hoc work with no plan never needs a
  branch. Confirm the branch with me when starting such a plan; don't branch unilaterally.
- When making changes to this machine that should persist across machines (installing/removing
  packages, changing tool configs, modifying shell settings, etc.), update the corresponding
  tracked file in this repo (Brewfile, Pipfile, mise.toml, lib/*.zsh, etc.).
- After completing a task, run `git status` to check for uncommitted changes. Only remind me
  to commit if there are actual uncommitted changes in this repo.

## Memory

This repo is worked on from two computers. Don't use Claude's per-machine memory system
for project context — it won't sync. Put persistent context in this repo instead (CLAUDE.md,
`.claude/PLANS.md`, `.claude/notes.md`, or `.claude/context-*.md` files).

## Future Work

See `.claude/PLANS.md` for improvement plans.
See `.claude/notes.md` for the human's backlog of ideas to discuss.
