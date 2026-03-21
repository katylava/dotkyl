# Context: Palette Profile Switching & Tab Titles

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

Reported on personal machine (dark mode, commit `c0fad35`) — tab titles revert to the iTerm
profile name after being idle, then fix themselves when the user runs a command (triggering
precmd/preexec). The root cause was `_apply_palette` calling `set-iterm-profile` on every
shell init, which reset the tab title. The `title` call added afterward was a no-op because
`002-colors.zsh` loads before `040-titles.zsh` defines the `title` function.

Also reported on work machine in light mode — titles revert to "profile name (job)" format.
Could not be reproduced on 2026-03-20 on work machine.

Fix history (chronological):
- `c0fad35` (personal, earlier session) — added `title` call after `set-iterm-profile`
  in `_apply_palette` (helped for `palette` command but was no-op during shell init due to
  load order)
- `430d184` (personal, earlier session) — moved `set-iterm-profile` from
  `_apply_palette` into `palette` only, eliminating the profile switch on shell init entirely
- `26a75a2` (work) — added one-shot precmd to defer the profile switch to first prompt, after
  `040-titles.zsh` loads. iTerm still processes the switch asynchronously after title escapes

## Architecture notes

- `_apply_palette` sets env vars only (bat, vivid, delta, starship, LS_COLORS)
- `palette` function calls `_apply_palette`, switches iTerm profile, reasserts tab title,
  and persists state file
- Shell init calls `_apply_palette` (env vars), then a one-shot precmd handles the iTerm
  profile switch before the first prompt
- SIGUSR1 cross-tab syncing was prototyped (session `a0cd7841`) but removed in commit
  `430d184`. It let `palette` notify other open shells to re-apply env vars via signal trap

## Open question

The one-shot precmd (lines 78-91 of `002-colors.zsh`) still calls `set-iterm-profile` on every
new shell init for both dark and light mode. On the personal machine, dark is the default and
the profile is already correct for new tabs — this call may be unnecessary for dark mode and
could be causing the same title-reset issue that `430d184` tried to fix. Need to test whether
skipping the init profile switch on both machines causes any problems.

## Previous session history

- `a291fa17` — deep-dive on tab title components and iTerm title behavior
- `a0cd7841` — SIGUSR1 palette syncing, starship light mode, palette architecture
- (personal, earlier session) — idle title reversion investigation, commits `c0fad35`
  and `430d184`
