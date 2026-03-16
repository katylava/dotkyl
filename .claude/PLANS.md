# Dotfiles Improvement Plans — Execution Order

Execute plans in this order. Each plan notes what it depends on and what it affects downstream.

## 1. plan-single-branch-dotfiles.md
**Foundation — do this first.**
Establishes the single-branch model, `mise.toml`, `dotkyl-private` repo, bootstrap script, and
host-aware zshrc loader. Everything else assumes this is in place.

## 2. plan-audit-dotfiles.md
With the private repo now available, audit `~/` and `~/.config/` to decide what goes in the
public repo vs `dotkyl-private`. Do this before restructuring individual config areas so you have
a complete picture.

## 3. plan-remove-old-version-managers.md + plan-cheatsheets.md
Batch these together — both touch `lib/100-installed.zsh`. Cleans up stale asdf/nodenv/pyenv
refs and removes the stale `DEFAULT_CHEAT_DIR` export in the same pass.

## ~~4. plan-nvim-lua-migration.md~~ DONE
Completed. Neovim config fully migrated from Vimscript to Lua:
- Entry point is `nvim/init.lua` loading modular Lua files
- Plugin manager switched from vim-plug to lazy.nvim
- All options, mappings, autocommands, and functions in Lua modules
- Plugin config consolidated into lazy.nvim specs
- `nvim/init.vim` and `nvim/autoload/plug.vim` deleted

---

## Optional / low priority (no required order, may never be done)

### plan-nvim-zshrc.md
Can be done any time after plan-single-branch-dotfiles.md. The terminal mapping
(`term://zsh -f`) was not changed during the Lua migration — this plan can still update it.

### plan-terminal-palettes.md
Independent. Can be done any time after plan-single-branch-dotfiles.md.
