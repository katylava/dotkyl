# Plan: Single-Branch Dotfiles with Per-Host Config

## Overview

Replace the two-branch (`main`/`orm`) model with a single branch. Per-host differences are handled
by file naming conventions. Everything that needs to reach a desired state — symlinks, brew
packages, software installs, migrations, macOS defaults — is a `[[task]]` in `manifest.toml`.
`mise run install` is idempotent and runs automatically on every `git pull` via a post-merge hook.

Private config (secrets, internal aliases, org-specific details) lives in a separate private git
repo cloned alongside the main repo.

## Core Model

Every task follows the same pattern:

| fields present | behavior |
|---|---|
| `check` passes | skip silently |
| `run` only | auto-execute |
| `run` + `prompt` | print notes, confirm, then run |
| `prompt` only | print notes, nothing to run |

`hosts` is optional — omit it and the task runs on all hosts. Specify it to restrict.

## Host Identity

A `[hosts]` section in `manifest.toml` maps real hostnames to semantic names:

```toml
[hosts]
"MacBook-Pro-3.local" = "work"
"Kyls-MacBook-Air.local" = "personal"
```

`setup/apply-manifest` calls `hostname` and looks it up here. If the hostname isn't found,
the script exits with a clear error telling you to add it. No file to create on each machine —
fresh clone + `mise run install` just works.

When you get a new machine, add its hostname to `manifest.toml` and commit.

## Private Config

Private config lives in a separate private git repo (`dotkyl-private`) hosted on GitHub. This
covers anything that must not be public: secrets, API keys, internal aliases, internal hostnames,
org-specific URLs, VPN config, etc.

### Private repo structure

Mirrors the main repo — `lib/` and `home/` only. No `manifest.toml`.

```
dotkyl-private/
├── lib/
│   ├── 000-private.zsh           # secrets, env vars (both machines)
│   ├── 011-aliases--work.zsh      # private work-specific aliases
│   └── 011-aliases--personal.zsh  # private personal aliases
└── home/                         # private dotfiles to symlink into ~/
```

Cloned to `~/.dotkyl/private/` which is gitignored in the main repo:

```
# .gitignore
private/
```

### How the main repo uses it

The zshrc loader and `setup/setup-symlinks` check both locations. The private repo's files are
treated identically to the main repo's files — same host-suffix convention, same numbering, same
symlink logic.

**zshrc loading** — iterates both `lib/` directories, skipping host-specific files not for this host:

```zsh
local _host=$($DOTKYL/setup/get-host 2>/dev/null)
for f in $DOTKYL/lib/*.zsh $DOTKYL/private/lib/*.zsh; do
    # skip host-specific files (name--host.zsh) not for this host
    if [[ "$f" == *--*.zsh && "$f" != *--$_host.zsh ]]; then
        continue
    fi
    . $f
done
unset _host
```

**`setup/setup-symlinks`** — processes `home/` from both repos.

### manifest.toml entry

The private repo is cloned by a task:

```toml
[[task]]
name = "Private dotfiles repo"
check = "test -d ~/.dotkyl/private/.git"
run = "git clone git@github.com:<user>/dotkyl-private.git ~/.dotkyl/private"
```

This task runs as part of `mise run install`. The SSH key must be set up before this task runs
(see Fresh Machine Setup).

## File Naming Convention

Host-specific lib files use a `--<host>` suffix before `.zsh`. The number prefix controls load order:

```
lib/010-aliases.zsh              # both machines
lib/070-kubernetes--work.zsh     # work only
lib/080-icloud--personal.zsh     # personal only
```

## manifest.toml

One file, one format, everything that needs to reach a desired state.

```toml
# manifest.toml

[hosts]
"MacBook-Pro-3.local" = "work"
"Kyls-MacBook-Air.local" = "personal"

# --- Infrastructure ---

[[task]]
name = "Git post-merge hook"
check = "test -x .git/hooks/post-merge && diff -q setup/hooks/post-merge .git/hooks/post-merge >/dev/null"
run = "cp setup/hooks/post-merge .git/hooks/post-merge && chmod +x .git/hooks/post-merge"

[[task]]
name = "Dotfile symlinks"
check = "setup/check-symlinks"
run = "setup/setup-symlinks"

[[task]]
name = "Crontab"
check = "crontab -l 2>/dev/null | diff -q - crontab.txt >/dev/null"
run = "crontab crontab.txt"

[[task]]
name = "Private dotfiles repo"
check = "test -d ~/.dotkyl/private/.git"
run = "git clone git@github.com:<user>/dotkyl-private.git ~/.dotkyl/private"

[[task]]
name = "Brew packages"
check = """
brew bundle check --file Brewfile.shared &&
brew bundle check --file Brewfile.$(setup/get-host)
"""
run = """
brew bundle --file Brewfile.shared
brew bundle --file Brewfile.$(setup/get-host)
"""

# --- Software (auto-install) ---

[[task]]
name = "Espanso"
check = "which espanso"
run = "brew install --cask espanso && espanso service register"

# --- Software (manual) ---

[[task]]
name = "Lungo"
hosts = ["personal"]
check = "test -d /Applications/Lungo.app"
notes = "Install from App Store"

[[task]]
name = "Corp VPN"
hosts = ["work"]
check = "which vpn-cli"
notes = "Request access via IT portal, then follow setup email"

# --- Migrations ---

[[task]]
name = "Dash → Espanso snippet migration"
hosts = ["personal"]
check = "which espanso && ! test -d /Applications/Dash.app"
run = "brew uninstall --cask dash"
notes = """
Export Dash snippets before running:
  Dash → Preferences → Snippets → Export
Then convert: https://espanso.org/docs/migrate-from-dash/
"""

# --- macOS defaults ---

[[task]]
name = "Disable press-and-hold for key repeat"
check = "defaults read NSGlobalDomain ApplePressAndHoldEnabled | grep -q 0"
run = "defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"
```

### Brewfiles

Brewfiles are the source of truth for brew packages — `brew bundle dump` is useful for auditing.

```
Brewfile.shared     # installed on both machines
Brewfile.work       # work only
Brewfile.personal   # personal only
```

### setup/get-host

Prints the semantic host name. Used by shell commands in `manifest.toml`. Implemented as a zsh
script using `yq -p toml` to read `manifest.toml`.

### setup/setup-symlinks

Replaces the old `bin/setup-dotfiles`. Symlinks `home/*` into `~/` and `home/config/*` into `~/.config/`
from both the main repo and `private/`. Idempotent (`ln -sf`).

### setup/check-symlinks

Returns exit 0 if all expected symlinks from both repos exist and point to the right place.

## Task Runner Script

`setup/apply-manifest` — reads `manifest.toml` via `yq -p toml`, processes each entry for the current host.
Implemented as a zsh script. Same core logic: skip tasks not for this host, run check, print
notes, prompt if both run and notes are present.

## mise Tasks

```toml
[tasks.install]
description = "Idempotent: run all tasks (symlinks, brew, software, defaults)"
run = "setup/apply-manifest"
```

## Git Hook

Git hooks are not cloned with the repo. The hook script is stored in `setup/hooks/post-merge` and
installed by a task on first `mise run install`. All subsequent `git pull`s trigger it
automatically.

### setup/hooks/post-merge (tracked by git)

```zsh
#!/usr/bin/env zsh
cd ~/.dotkyl
mise run install
```

## Day-to-Day Workflow

### Making and syncing changes

**On the machine where you make the change:**
```zsh
# edit whatever needs changing
git add -p
git commit -m "description"
git push
```

**On the other machine:**
```zsh
git pull
# post-merge hook runs mise run install automatically
# shell changes take effect in new shell sessions (or: sopr)
```

### What changes where

**Change applies to both machines** — edit shared files (`lib/*.zsh`, `bin/*`, `home/*`,
`Brewfile.shared`, etc.).

**Change applies to one machine only** — edit or create a host-specific file
(`lib/070-k8s--work.zsh`, `Brewfile.work`, etc.) or add a `manifest.toml` entry with `hosts = [...]`.

**Private change (sensitive content)** — edit files in `~/.dotkyl/private/`, commit and push
to `dotkyl-private`. Pull on other machine: `cd ~/.dotkyl/private && git pull`.

**Change you want on both machines but only have on one yet** — commit as shared. On the machine
where it's not ready, `manifest.toml` surfaces the reminder until you act on it.

### Specific scenarios

**Adding a brew package:**
```zsh
# add to Brewfile.shared, Brewfile.work, or Brewfile.personal
git add Brewfile.shared && git commit -m "brew: add ripgrep" && git push
# other machine: git pull → brew bundle installs it automatically
```

**Adding a task (software install, migration, macOS default, etc.):**
```zsh
git add manifest.toml && git commit -m "tasks: add espanso" && git push
# other machine: git pull → task runs automatically or prints reminder
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

Add the new machine's hostname to `[hosts]` in `manifest.toml`, commit and push, then re-run
`mise run install`:

```zsh
hostname  # note this value
# edit manifest.toml: add "new-machine.local" = "work"
git add manifest.toml && git commit -m "hosts: add new machine" && git push
mise run install
```

## Migration from Two-Branch Model

1. **Start from `orm`** (most complete branch).

2. **Identify what's in `main` but not `orm`:**
   ```zsh
   git log orm..main --oneline
   git diff orm..main -- lib/
   ```

3. **Move personal-specific config** into `lib/*--personal.zsh` files.
   Move work-specific config into `lib/*--work.zsh` files.
   Move private config (internal aliases, secrets) into `dotkyl-private/lib/`.

4. **Create Brewfiles:**
   ```zsh
   brew bundle dump --file Brewfile.work      # run on work machine
   brew bundle dump --file Brewfile.personal  # run on personal machine
   ```
   Split shared packages into `Brewfile.shared`.

5. **Create `manifest.toml`** — add `[hosts]` mapping, all infrastructure tasks, and entries for
   software, migrations, and macOS defaults.

6. **Write `bin/bootstrap`**, **`setup/apply-manifest`**, **`setup/get-host`**,
   **`setup/setup-symlinks`**, **`setup/check-symlinks`**.

7. **Add `mise.toml`** with the `install` task.

8. **Add `setup/hooks/post-merge`**.

9. **Update `home/zshrc`** to use the host-aware loader (both repos).

10. **Test on work machine**: `mise run install`, verify shell loads correctly.

11. **Pull on personal machine**, run `mise run install`.

12. **Tag old branches before deleting:**
    ```zsh
    git tag archive/main main
    git tag archive/orm orm
    git branch -d main
    ```
