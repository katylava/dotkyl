# Dotfiles Improvement Plans

## High priority

### plan-audit-dotfiles.md
Audit `~/` and `~/.config/` to decide what goes in public vs private repo.

## Medium priority

### plan-bootstrap.md
Fresh machine bootstrap script. Also becoming relevant for existing machines — one-time
install tasks (e.g., peon-ping) accumulate in `mise.toml` and never need to run again.
See `.claude/notes.md` "Separate install from sync commands" for ideas on splitting
install vs sync. See also `.claude/notes.md` for related ideas (pre-new-install,
post-new-install).

## Low priority

### plan-nvim-lua-migration.md
Migrate neovim config from vimscript to lua. Has a branch but not yet merged.

### plan-nvim-zshrc.md
Alternate zshrc for neovim terminals — skip slow/harmful lib files.
If done before nvim-lua-migration, skip the terminal mapping step there.
