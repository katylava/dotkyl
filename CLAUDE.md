# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository (`~/.dotkyl`) for macOS (Apple Silicon). It manages zsh configuration, custom scripts, neovim config, iTerm2 profiles, and cheatsheets.

## Branch Strategy

- `main` — personal/general dotfiles (used on personal machine)
- `orm` — work-specific dotfiles (this branch); contains work tools, aliases, and scripts not relevant to personal use

Changes flow between branches via selective cherry-picks (historically committed as "Patch merge from main/orm"). When making changes, consider whether they belong in `orm` only or should also be patched into `main`.

## Applying Changes

After editing files, reload the shell to pick up changes:

```zsh
sopr   # alias for: source ~/.zshrc
```

To set up symlinks on a fresh machine (links `home/*` files to `~/`):

```zsh
bin/setup-dotfiles
```

## Architecture

### Zsh Loading Order

`~/.zshenv` sources `lib/010-aliases.zsh` only (runs for all zsh instances).
`~/.zshrc` sources all `lib/*.zsh` files in numeric order.

Files in `lib/` are numbered to control load order:
- `000-private.zsh` — secrets/private config (not in repo)
- `001-path.zsh` — PATH setup; custom scripts in `~/.dotkyl/bin` and `~/.local/bin` come first
- `010-aliases.zsh` — all aliases
- `015-completion.zsh` — zsh completion config; custom completions go in `completion/`
- `020-keybindings.zsh` — vi-mode keybindings
- `030-history.zsh` — history settings
- `080-bookmarks.zsh` — named directory bookmark system
- `085-versions.zsh` — lazy-init nodenv on `chpwd` when `.node-version` is found
- `090-prompt.zsh` — starship prompt + custom `MYPWD` variable
- `095-run.zsh` — ssh-agent setup
- `100-installed.zsh` — config for installed tools (fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, etc.)

### Dotfile Symlinking

Files under `home/` are symlinked into `~/` by `bin/setup-dotfiles`. For example, `home/zshrc` becomes `~/.zshrc`, `home/gitignore` becomes `~/.gitignore`.

Subdirectory `home/config/` items are symlinked into `~/.config/`. The nvim config (`nvim/`) is symlinked to `~/.config/nvim`.

### Bookmark System (`lib/080-bookmarks.zsh`)

Named directories stored as symlinks in `~/.dotkyl/bookmarks/`. Commands:
- `s <name>` — save bookmark for current directory
- `b` / `l` — list bookmarks
- `d <name>` — delete bookmark
- `@@` in ZLE — inserts `~-` prefix for tab-completing bookmarks

### Custom Scripts (`bin/`)

All scripts in `bin/` are on `$PATH`. Notable ones:
- `findup` — walk up directory tree looking for a file
- `git-cleanup` — prune merged branches
- `ksc` / `kssh` — kubernetes context switching

### Runtime Version Management

mise is used for managing runtime versions. Activated via `~/.miserc-zsh` if present. References to asdf, nodenv, and pyenv remain in some config files but are being phased out.

### Cheatsheets

Plain-text cheatsheets in `cheatsheets/` are used with the `cheat` CLI tool. `DEFAULT_CHEAT_DIR` points to iCloud, but iCloud is not available on the work machine, so only the cheatsheets committed in this repo are accessible here. Personal cheatsheets currently stored in iCloud are not synced to the work machine.

## Future Work

- Remove remaining asdf, nodenv, and pyenv references from config files now that mise is the version manager
- Move personal cheatsheets from iCloud into this repo (or a dedicated repo) so they are available on both personal and work machines; update `DEFAULT_CHEAT_DIR` accordingly
- Audit `~/` for dotfiles/config that can be safely added to this public repo, including `~/.config` subdirectories beyond `nvim`
- Add alternate zshrc for use inside nvim terminals
- Store secrets via keychain instead of `lib/000-private.zsh` (e.g. [envchain](https://github.com/sorah/envchain))
- Terminal palettes — find a way to store and use themes with alternate colors that go with the main 8 terminal colors
- Migrate neovim config from vimscript to lua
