# Plan: Remove asdf, nodenv, and pyenv References

**Execute after:** plan-single-branch-dotfiles.md
**Batch with:** plan-cheatsheets.md (both touch `lib/100-installed.zsh`)
**Execute before:** plan-nvim-zshrc.md (deletes `085-versions.zsh` which that plan references),
plan-nvim-lua-migration.md (removes asdf refs from `nvim/init.vim` so migration starts clean)

## Summary

mise is now the sole version manager. References to asdf, nodenv, and pyenv remain in 7 files.
Most are already dead code (commented out), but two cases actively affect shell behavior: the asdf
shims PATH entry in `lib/001-path.zsh` and the nodenv lazy-init hook in `lib/085-versions.zsh`.

## File-by-File Breakdown

**`lib/001-path.zsh` (lines 4, 12)**
- Line 4: Delete stale comment `# shims for nodenv an pyenv are added later by their init commands`
- Line 12: Remove `${ASDF_DATA_DIR:-$HOME/.asdf}/shims` from the path array. Mise handles this via
  its activate hook. Verify mise activation is in place before removing.

**`lib/085-versions.zsh` (entire file)**
- The whole file implements a precmd hook that lazily evals `nodenv init -` when `.node-version` is
  found. Mise handles this automatically when activated. Delete the entire file. Also remove its
  description from CLAUDE.md.

**`lib/100-installed.zsh` (lines 45–56)**
- Entirely commented-out pyenv and nodenv evals, plus one active but no-op line:
  `export PYENV_VIRTUALENV_DISABLE_PROMPT=1`. Delete all 12 lines.

**`lib/015-completion.zsh` (line 19)**
- Remove `${ASDF_DATA_DIR:-$HOME/.asdf}/completions` from the fpath assignment.
- Optionally generate mise completions: `mise completion zsh > ~/.dotkyl/completion/_mise`.

**`lib/010-aliases.zsh` (lines 52–53)**
- Delete `alias epyenv='eval "$(pyenv init -)"'` and `alias enodenv='eval "$(nodenv init -)"'`.

**`nvim/init.vim` (lines 1–2)**
- Remove `let g:python_host_prog='~/.asdf/shims/python'` and
  `let g:python3_host_prog='~/.asdf/shims/python'`. Let neovim find Python via PATH (mise shims).
- Run `:checkhealth provider` before and after to confirm Python 3 is still detected.

**`nvim/coc-settings.json` (line 8)**
- Remove `"python.formatting.blackPath": "~/.asdf/shims/black"`. Rely on PATH resolution.
- Note: `coc-python` is deprecated; this setting may already be a no-op.

**`home/config/starship.toml` (line 136)**
- Remove `${pyenv_prefix}` from the Python module format string. With mise, this token is always
  empty.

**`crontab.txt` (line 2)**
- Remove `:/Users/klavallee/.asdf/shims` from the PATH line.
- Update the live crontab separately via `crontab crontab.txt`. This is orm-only.

## Risks and Non-Trivial Decisions

- **Verify mise activation first.** Before removing asdf from PATH and deleting `085-versions.zsh`,
  confirm `mise activate zsh` (or `~/.miserc-zsh` sourcing) is present in `lib/100-installed.zsh`.
  Run `mise doctor` to validate.
- **neovim Python host is the highest-risk change.** Run `:checkhealth provider` before and after.
- **Branch strategy:** All changes go on the single branch (see plan-single-branch-dotfiles.md).
  Most changes affect shared files (both machines). The `crontab.txt` change is work-only — add
  it to a `crontab.work.txt` or handle via a `tasks.toml` entry with `hosts = ["work"]`.

## Suggested Order

1. Verify mise is active in the shell (check `lib/100-installed.zsh`)
2. `lib/010-aliases.zsh` — remove `epyenv`/`enodenv` aliases (lowest risk)
3. `lib/100-installed.zsh` — delete the commented-out block (lines 45–56)
4. `lib/001-path.zsh` — remove asdf shims entry and stale comment; reload shell and test
5. `lib/085-versions.zsh` — delete the file; update CLAUDE.md; test `.node-version` still activates
6. `lib/015-completion.zsh` — remove asdf completions fpath entry
7. `home/config/starship.toml` — remove `${pyenv_prefix}` from Python format
8. `crontab.txt` — remove asdf shims from PATH; reload live crontab
9. `nvim/coc-settings.json` — remove `blackPath`; verify black formatting still works
10. `nvim/init.vim` — remove `python_host_prog` lines; run `:checkhealth provider`
