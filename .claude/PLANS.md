# Dotfiles Improvement Plans

## High priority

### plan-audit-dotfiles.md
Audit `~/` and `~/.config/` to decide what goes in public vs private repo.

## Low priority

### plan-nvim-lua-migration.md
Migrate neovim config from vimscript to lua. Branch `nvim-lua-wip` has first
attempt — works but has nerdtree icon issues. Needs plugin modernization
(nerdtree→nvim-tree, etc.) before merging. Detailed lessons learned in plan.

### plan-nvim-zshrc.md
Alternate zshrc for neovim terminals — skip slow/harmful lib files.
If done before nvim-lua-migration, skip the terminal mapping step there.
