# CLAUDE.md

Personal dotfiles repo (`~/.dotkyl`) for macOS (Apple Silicon).
See `README.md` for a full description of the repo's contents and directory structure.

## Applying Changes

- Reload shell after edits: open a new terminal tab
- Apply symlinks: `setup/manage-symlinks` (supports `--dry-run`)

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

Symlinks are declared in `setup/symlinks.yml` and applied by `setup/manage-symlinks`.
The `private/` submodule mirrors the `home/` structure for sensitive files.

### Shell Scripts

Prefer `#!/usr/bin/env zsh` over bash for new scripts. This is a zsh-centric repo on macOS —
no need to stay POSIX-portable. All scripts in `bin/` are on `$PATH`.

### Mise Tasks (`mise.toml`)

`mise run install` ensures the machine is in the correct state. `mise run sync` runs just the
fast tasks (used by the post-merge hook).

`setup/mise.toml` holds graduated one-time per-machine installs. After the initial
bootstrap, run `cd setup && mise run install` to install them on a new machine.

One-time per-machine install tasks get created in root `mise.toml`, then graduate
into `setup/mise.toml` via `mise run graduate <name>` after running on the second
machine. Use the `add-install-task` skill to create new ones.

Each task uses inline check-or-run logic for idempotency:
```toml
[tasks.example]
run = "check-command || fix-command"
```

Echo output uses emoji to indicate state:
- ⏭️ already done — ✅ ran successfully — ❌ failed — 👉 manual action needed

**Confirm tasks must not be dependencies.** Mise's `confirm` field hides output from other
parallel tasks. Instead, create two tasks: the confirm task itself (run manually), and a
reminder task that `sync`/`install` depends on. The reminder should include a check so it
only prints when the action hasn't been done yet.

```toml
# The actual task (run manually: mise run migrate-espanso)
[tasks.migrate-espanso]
confirm = "Export Dash snippets first (Dash → Preferences → Snippets → Export). Ready?"
run = "brew install espanso && brew uninstall dash"

# The reminder (safe to depend on)
[tasks.migrate-espanso-reminder]
run = "which espanso >/dev/null || echo '👉 Run: mise run migrate-espanso'"
```

## Workflow

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
