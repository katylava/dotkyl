# Dotfiles Improvement Plans

## High priority

### plan-audit-dotfiles.md
Audit `~/` and `~/.config/` to decide what goes in public vs private repo.
Gates `plan-add-dotfile.md` — do this first; its findings scope that task.

## Blocked on the audit

### plan-add-dotfile.md
`mise run add-dotfile` to automate bringing a new dotfile under repo
management. Hand-in-hand with the audit: until that's done we don't know
which features (host routing, secret handling, per-file routing) carry
the value. Scope follows from the audit findings.

## Archived

Completed and abandoned plans have been removed from `.claude/`. See
`archived-plans.md` for the index (with the git commit to recover each).
