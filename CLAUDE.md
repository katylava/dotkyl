# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository (`~/.dotkyl`) for macOS (Apple Silicon). It manages zsh configuration, custom scripts, neovim config, iTerm2 profiles, and crontab.

## Branch Strategy (being retired)

- `main` — personal machine dotfiles (this branch)
- `orm` — work machine dotfiles

The goal is to merge into a single branch with per-host config. See `.claude/PLANS.md` for the plan.

## Applying Changes

After editing files, reload the shell to pick up changes:

```zsh
sopr   # alias for: source ~/.zshrc
```

To set up symlinks on a fresh machine (links `home/*` files to `~/`):

```zsh
setup/setup-symlinks
```

## Architecture

### Zsh Loading Order

`~/.zshenv` sources `lib/010-aliases.zsh` only (runs for all zsh instances).
`~/.zshrc` sources all `lib/*.zsh` files in numeric order.

Files in `lib/` are numbered to control load order:
- `000-private.zsh` — secrets/private config (not in repo)
- `001-path.zsh` — PATH setup; custom scripts in `~/.dotkyl/bin` and `~/.local/bin` come first
- `002-colors.zsh` — palette switching (light/dark mode) and color setup
- `003-locale.zsh` — locale settings
- `010-aliases.zsh` — all aliases
- `015-completion.zsh` — zsh completion config; custom completions go in `completion/`
- `020-keybindings.zsh` — vi-mode keybindings
- `030-history.zsh` — history settings
- `040-titles.zsh` — terminal title config
- `080-bookmarks.zsh` — named directory bookmark system
- `090-prompt.zsh` — starship prompt + custom `MYPWD` variable
- `100-installed.zsh` — config for installed tools (fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, etc.)

### Dotfile Symlinking

Files under `home/` are symlinked into `~/` by `setup/manage-symlinks`. For example, `home/zshrc` becomes `~/.zshrc`, `home/gitignore` becomes `~/.gitignore`.

Subdirectory `home/config/` items are symlinked into `~/.config/`. The nvim config (`nvim/`) is symlinked to `~/.config/nvim`.

### iTerm2 Dynamic Profiles

iTerm profiles live in `iterm/*.json` and are symlinked into `~/Library/Application Support/iTerm2/DynamicProfiles/` by `setup/manage-symlinks`. Profiles use inheritance via `Dynamic Profile Parent Name`. Host-specific profiles (e.g., `*-air.json`) override font sizes for different screens.

### Palette Switching (`lib/002-colors.zsh`)

The `palette` command switches between light and dark modes across iTerm, bat, vivid (LS_COLORS), delta (git diff), and starship prompt. State persists across shell sessions via `~/.local/state/terminal-palette`.

Usage: `palette light`, `palette dark`, `palette status`

iTerm profile names are configured via `ITERM_DARK_PROFILE` and `ITERM_LIGHT_PROFILE` vars at the top of the file — set per-host.

### Bookmark System (`lib/080-bookmarks.zsh`)

Named directories stored as symlinks in `~/.dotkyl/bookmarks/`. Commands:
- `s <name>` — save bookmark for current directory
- `b` / `l` — list bookmarks
- `d <name>` — delete bookmark
- `@@` in ZLE — inserts `~-` prefix for tab-completing bookmarks

### Shell Script Convention

Prefer `#!/usr/bin/env zsh` over `#!/usr/bin/env bash` for new scripts whenever zsh features
would make the script easier to read or maintain. This is a zsh-centric dotfiles repo on macOS —
no need to stay POSIX-portable.

### Custom Scripts (`bin/`)

All scripts in `bin/` are on `$PATH`. Notable ones:
- `findup` — walk up directory tree looking for a file
- `git-cleanup` — prune merged branches
- `set-iterm-profile` — switch iTerm profile via escape sequence

### Runtime Version Management

This machine uses mise as its sole version manager.

### Mise Tasks (`mise.toml`)

`mise run install` ensures the machine is in the correct state. `mise run sync` runs just the
fast tasks (used by the post-merge hook). Individual tasks can be run with `mise run <task>`.

Each task uses inline check-or-run logic for idempotency:
```toml
[tasks.example]
run = "check-command || fix-command"
```

Echo output uses emoji to indicate state:
- ⏭️ check passed, already done
- ✅ ran successfully
- ❌ failed
- 👉 manual action needed

**Confirm tasks must not be dependencies.** Mise's `confirm` field hides output from other
parallel tasks, making it hard to see what happened. Instead, create two tasks: the confirm task
itself, and a reminder task that `sync`/`install` depends on. The reminder should include a
check so it only prints when the action hasn't been done yet.

```toml
# The actual task (run manually: mise run migrate-espanso)
[tasks.migrate-espanso]
confirm = "Export Dash snippets first (Dash → Preferences → Snippets → Export). Ready?"
run = "brew install espanso && brew uninstall dash"

# The reminder (safe to depend on)
[tasks.migrate-espanso-reminder]
run = "which espanso >/dev/null || echo '👉 Run: mise run migrate-espanso'"
```

## Future Work

See `.claude/PLANS.md` for the ordered list of improvement plans.
