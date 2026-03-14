# Dotfiles Improvement Plans — Execution Order

Execute plans in this order. Each plan notes what it depends on and what it affects downstream.

## 1. plan-single-branch-dotfiles.md
**Foundation — do this first.**
Establishes the single-branch model, `manifest.toml`, `dotkyl-private` repo, bootstrap script, and
host-aware zshrc loader. Everything else assumes this is in place.

## 2. plan-audit-dotfiles.md
With the private repo now available, audit `~/` and `~/.config/` to decide what goes in the
public repo vs `dotkyl-private`. Do this before restructuring individual config areas so you have
a complete picture.

## 3. plan-remove-old-version-managers.md + plan-cheatsheets.md
Batch these together — both touch `lib/100-installed.zsh`. Cleans up stale asdf/nodenv/pyenv
refs and removes the stale `DEFAULT_CHEAT_DIR` export in the same pass.

## 4. plan-nvim-lua-migration.md
Last in the required sequence — largest change. By this point:
- asdf refs already removed from `nvim/init.vim` (step 3)
- `lib/085-versions.zsh` already deleted (step 3)
Remove those items from the migration checklist before starting.

---

## Optional / low priority (no required order, may never be done)

### plan-nvim-zshrc.md
Can be done any time after plan-single-branch-dotfiles.md. If done before
plan-nvim-lua-migration.md, the terminal mapping change (`term://zsh -f` → `term://zsh`) will
already be complete — skip that step in the migration.

### plan-terminal-palettes.md
Independent. Can be done any time after plan-single-branch-dotfiles.md.
