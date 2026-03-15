# Plan: Single-Branch Dotfiles with Per-Host Config

## Overview

Replace the two-branch (`main`/`orm`) model with a single branch. Per-host differences are handled
by file naming conventions. `mise run install` is idempotent and runs automatically on every
`git pull` via a post-merge hook.

## File Naming Convention

Host-specific lib files use a `--<host>` suffix before `.zsh`. The number prefix controls load order:

```
lib/010-aliases.zsh              # both machines
lib/070-kubernetes--work.zsh     # work only
lib/080-icloud--personal.zsh     # personal only
```

## Day-to-Day Workflow

### Making and syncing changes

**On the machine where you make the change:**
```zsh
git add -p
git commit -m "description"
git push
```

**On the other machine:**
```zsh
git pull
# post-merge hook runs mise run sync automatically
# shell changes take effect in new shell sessions (or: sopr)
```

### What changes where

**Change applies to both machines** — edit shared files (`lib/*.zsh`, `bin/*`, `home/*`,
`Brewfile.shared`, etc.).

**Change applies to one machine only** — edit or create a host-specific file
(`lib/070-k8s--work.zsh`, `Brewfile.work`, etc.) or add a host-specific mise task.

**Private change (sensitive content)** — edit files in `~/.dotkyl/private/`, commit and push
to `dotkyl-private`. Pull on other machine: `cd ~/.dotkyl/private && git pull`.

### Specific scenarios

**Adding a brew package:**
```zsh
# add to setup/Brewfile.shared, setup/Brewfile.work, or setup/Brewfile.personal
git add setup/Brewfile.shared && git commit -m "brew: add ripgrep" && git push
# other machine: git pull → mise run install picks it up
```

**Adding a task (software install, migration, macOS default, etc.):**
```zsh
# add task to mise.toml
git add mise.toml && git commit -m "tasks: add espanso" && git push
# other machine: git pull → task runs on next mise run install
```

**Checking what still needs attention on this machine:**
```zsh
mise run install
```

## Migration from Two-Branch Model

Requires both machines. Do on a Friday.

1. **Test on work machine**: `mise run install`, verify shell loads correctly.

2. **Pull on personal machine**, run `mise run install`.

3. **Tag old branches before deleting:**
    ```zsh
    git tag archive/main main
    git tag archive/orm orm
    git branch -d main
    ```
