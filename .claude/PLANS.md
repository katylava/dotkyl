# Dotfiles Improvement Plans

## High priority

### plan-audit-dotfiles.md
Audit `~/` and `~/.config/` to decide what goes in public vs private repo.

## Low priority

### plan-nvim-lua-migration-v2.md
Migrate neovim config from vimscript to lua (second attempt). Fresh
`nvim-lua-v2` branch off main; per-plugin checkpoint conversations to triage
which customizations to port vs. drop. Attempt 1 post-mortem in
`plan-nvim-lua-migration.md` (deprecated).

### plan-nvim-zshrc.md
Alternate zshrc for neovim terminals — skip slow/harmful lib files.
If done before nvim-lua-migration, skip the terminal mapping step there.
