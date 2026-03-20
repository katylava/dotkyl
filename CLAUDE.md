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
setup/manage-symlinks
```

## Architecture

### Zsh Loading Order

`~/.zshenv` sources `lib/010-aliases.zsh` only (runs for all zsh instances).
`~/.zshrc` sources all `lib/*.zsh` and `private/lib/*.zsh` files in numeric order, skipping
host-specific files (named `*--<host>.zsh`) that don't match the current host.

#### Host-specific files

Files named `*--<host>.zsh` (e.g., `010-aliases--work.zsh`) are only loaded when `get-host`
returns that host name. This allows per-machine overrides without branching. Current hosts:
`personal`, `work`.

#### File list

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
- `095-run.zsh` — ssh-agent identity loading
- `100-installed.zsh` — config for installed tools (fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, etc.)

### Dotfile Symlinking

Symlinks are declared in `setup/symlinks.yml` and applied by `setup/manage-symlinks`.
Rules (in order):

1. `home/*` (excluding `config/`) → `~/` with a `.` prefix (e.g., `home/zshrc` → `~/.zshrc`)
2. `home/config/*` → `~/.config/` (e.g., `home/config/starship.toml` → `~/.config/starship.toml`)
3. `nvim/` → `~/.config/nvim`
4. `iterm/*.json` → `~/Library/Application Support/iTerm2/DynamicProfiles/`

### iTerm2 Dynamic Profiles

iTerm profiles live in `iterm/*.json`. Profiles use inheritance via `Dynamic Profile Parent Name`. Host-specific profiles (e.g., `*-air.json`) override font sizes for different screens.

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

### Neovim Config (`nvim/`)

The neovim config is written in Lua. Entry point is `nvim/init.lua`, which loads modules in order:

1. `lua/options.lua` — vim options, settings, leader key
2. `lua/functions.lua` — FileDir, lightline components, theme (ApplyDark/ApplyLight), window swap
3. `lua/plugins.lua` — lazy.nvim bootstrap + all plugin specs with inline config
4. `lua/autocommands.lua` — filetype detection, filetype settings, CoC augroups, trailing whitespace
5. `lua/mappings.lua` — all keymaps, user commands, CoC mappings

Plugin manager is **lazy.nvim** (auto-bootstraps on first launch; run `:Lazy install`).

Other nvim files:
- `after/ftplugin/javascript.lua` — JS-specific formatoptions
- `colors/my-monokai.vim` — custom colorscheme (inactive; catppuccin used)
- `pcthemes/kyl.vim` — PaperColor overrides (inactive)
- `syntax/*.vim` — custom syntax files (apex, ejs, tinytower, visualforce)
- `coc-settings.json` — CoC LSP configuration

### Shell Script Convention

Prefer `#!/usr/bin/env zsh` over `#!/usr/bin/env bash` for new scripts whenever zsh features
would make the script easier to read or maintain. This is a zsh-centric dotfiles repo on macOS —
no need to stay POSIX-portable.

### Custom Scripts (`bin/`)

All scripts in `bin/` are on `$PATH`. Notable ones:
- `claude-statusline` — Claude Code status line renderer (reads JSON from stdin)
- `findup` — walk up directory tree looking for a file
- `get-host` — print semantic host name (`personal`, `work`) based on hostname
- `git-cleanup` — prune merged branches
- `set-iterm-profile` — switch iTerm profile via escape sequence

### Machine Setup (`setup/`)

- `manage-symlinks` — creates/checks symlinks defined in `symlinks.yml` (supports `--dry-run`)
- `symlinks.yml` — declarative symlink manifest
- `Brewfile.shared`, `Brewfile.personal`, `Brewfile.work` — Homebrew bundle files, split by host
- `Pipfile.shared` — shared Python packages
- `hooks/` — git hooks (e.g., post-merge runs `mise run sync`)

### Crontab

Crontab entries live in `crontab.txt` (personal) and `crontab--work.txt` (work). These are
installed by a mise task, not automatically.

### Cheatsheets (`cheatsheets/`)

Markdown cheatsheets for quick reference, used with the `cheat` tool via `home/config/cheat/`.

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
