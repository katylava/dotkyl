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

Files under `home/` are symlinked into `~/` by `setup/setup-symlinks`. For example, `home/zshrc` becomes `~/.zshrc`, `home/gitignore` becomes `~/.gitignore`.

Subdirectory `home/config/` items are symlinked into `~/.config/`. The nvim config (`nvim/`) is symlinked to `~/.config/nvim`.

### iTerm2 Dynamic Profiles

iTerm profiles live in `iterm/*.json` and are symlinked into `~/Library/Application Support/iTerm2/DynamicProfiles/` by `setup/setup-symlinks`. Profiles use inheritance via `Dynamic Profile Parent Name`. Host-specific profiles (e.g., `*-air.json`) override font sizes for different screens.

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

## Future Work

See `.claude/PLANS.md` for the ordered list of improvement plans.
