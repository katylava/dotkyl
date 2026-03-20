# Context: Palette Profile Switching & Tab Titles

**Branch**: `port-orm-to-main`

## What was fixed (commit `26a75a2`)

- Per-host iTerm profile names via `$DOTKYL_HOST` in `lib/002-colors.zsh` — Air profiles
  were being loaded on the work machine, causing window resizing (different font size)
- One-shot precmd defers `set-iterm-profile` to first prompt on new shell init, so new
  terminals get the correct profile based on the palette state file
- `bin/set-iterm-profile` updated from undocumented `\033]50` to iTerm2's documented
  `\033]1337;SetProfile=...\a` escape sequence

## Known remaining issue: tab title on new tabs

New tabs show the profile name (e.g. "Tomorrow Light Mod (zsh)") until the user presses
enter. The `SetProfile` escape sequence causes iTerm to overwrite the tab title
asynchronously — after precmd hooks have already set it correctly. A one-shot precmd was
tried to defer the profile switch until after `040-titles.zsh` loads, but iTerm still
processes the profile switch after the title escape sequences.

- The old `\033]50` sequence has the same problem — not about which escape sequence
- `Title Components` in the iTerm base profile was tried before and didn't help — the
  window title bleeds into the tab. It was removed and a `claude` wrapper function in
  `040-titles.zsh` was the final solution for the claude-specific title problem
  (session `a291fa17`)
- `_apply_palette` intentionally does NOT call `set-iterm-profile` — the profile switch
  is in `palette` (explicit use) and a one-shot precmd (shell init). This avoids calling
  `title` before `040-titles.zsh` defines it

## Idle tab title reversion

A reported issue where light-mode tab titles revert to "profile name (job)" format after
being idle. Could not be reproduced on 2026-03-20. Only affects light mode (where
`SetProfile` was used). Dark mode tabs (no profile switch) are fine.

## Architecture notes

- `_apply_palette` sets env vars only (bat, vivid, delta, starship, LS_COLORS)
- `palette` function calls `_apply_palette`, switches iTerm profile, reasserts tab title,
  and persists state file
- Shell init calls `_apply_palette` (env vars), then a one-shot precmd handles the iTerm
  profile switch before the first prompt
- SIGUSR1 cross-tab syncing was prototyped (session `a0cd7841`) but removed in commit
  `430d184`. It let `palette` notify other open shells to re-apply env vars via signal trap

## Previous session history

- `a291fa17` — deep-dive on tab title components and iTerm title behavior
- `a0cd7841` — SIGUSR1 palette syncing, starship light mode, palette architecture
