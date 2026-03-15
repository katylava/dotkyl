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

## Fresh Machine Setup

### Goal

Clone both repos and run one command. Prerequisites must be in place first.

### Prerequisites (manual, in order)

1. **Xcode Command Line Tools** — provides `git`, `make`, etc.:
   ```zsh
   xcode-select --install
   # follow the GUI prompt
   ```

2. **Homebrew**:
   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **1Password app** — install from https://1password.com and sign in.

4. **mise and 1Password CLI**:
   ```zsh
   brew install mise 1password-cli
   ```

### Bootstrap script

Run `bin/bootstrap` (or fetch and run via curl before the repo is cloned):

```zsh
curl -fsSL https://raw.githubusercontent.com/<user>/.dotkyl/main/bin/bootstrap | zsh
```

`bin/bootstrap` does the following (stored in the main repo, runnable standalone):

```zsh
#!/usr/bin/env zsh
set -e

# Generate a new SSH key for this machine
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

# Register the new key with GitHub using a token from 1Password
GITHUB_TOKEN=$(op read "op://Personal/GitHub Token/credential")
curl -sf -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user/keys \
  -d "{\"title\":\"$(hostname)\",\"key\":\"$(cat ~/.ssh/id_ed25519.pub)\"}"

# Clone both repos
git clone git@github.com:<user>/.dotkyl.git ~/.dotkyl
git clone git@github.com:<user>/dotkyl-private.git ~/.dotkyl/private

# Run install
cd ~/.dotkyl
mise run install
```

### After bootstrap

Add the new machine's hostname to `bin/get-host`, commit and push, then re-run
`mise run install`:

```zsh
hostname  # note this value
# edit bin/get-host: add case for new hostname
git add bin/get-host && git commit -m "hosts: add new machine" && git push
mise run install
```

## Migration from Two-Branch Model

1. **Test on work machine**: `mise run install`, verify shell loads correctly.

2. **Pull on personal machine**, run `mise run install`.

3. **Tag old branches before deleting:**
    ```zsh
    git tag archive/main main
    git tag archive/orm orm
    git branch -d main
    ```
