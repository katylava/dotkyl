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

## Session 2026-03-23: Title Components fix attempt

### Reproduced on work machine in light mode

Steps to reproduce:
1. Start iTerm (single tab, dark mode default)
2. Run `palette light` — theme and title look correct
3. Open 3+ new tabs — all have light theme, titles correct
4. Work in one tab for a while
5. Inactive tab titles revert to iTerm's default title format (e.g. "Tomorrow Dark Mod (zsh)")
6. Switching to an affected tab and running a command fixes its title (precmd fires)

The colors on affected tabs are still light (profile switch worked), but the tab title
shows the **dark** profile name — "Tomorrow Dark Mod (zsh)". This is because iTerm's
default profile for new tabs is dark. The `SetProfile` escape sequence changes the
appearance but iTerm still uses the original profile name for its default title.

### Root cause

No `Title Components` key was set in the iTerm dynamic profiles, so iTerm used its
built-in default: **34** (Profile Name + Job = 32 + 2). That's why inactive tabs showed
"Tomorrow Dark Mod (zsh)" — iTerm was actively maintaining a title based on profile name.

### iTerm Title Components reference

The `Title Components` field is a bitmask stored as an integer in iTerm profiles:

| Value | Meaning            |
|-------|--------------------|
| 1     | Session Name       |
| 2     | Job                |
| 4     | Working Directory  |
| 8     | TTY                |
| 16    | Custom             |
| 32    | Profile Name       |
| 64    | Profile & Session  |
| 128   | User               |
| 256   | Host               |
| 512   | Command Line       |
| 1024  | Size               |

Source: iTerm2 source `iterm2/profile.py` TitleComponents enum.

Previous attempts (session `a291fa17`, set on base profile):
- **3** (Session Name + Job) — window title bled into tab
- **6** (Job + Working Directory) — window title bled into tab

### Fix applied

Added `"Title Components": 1` to `iterm/0.base.json` (the base dynamic profile that all
other profiles inherit from). Value 1 = Session Name only, which is what `\e]1;` sets —
so iTerm should show only what the shell's `title` function sets and nothing else.

### iTerm dynamic profiles location

Profiles are defined in `/Users/klavallee/.dotkyl/iterm/*.json` and symlinked to
`~/Library/Application Support/iTerm2/DynamicProfiles/` via `setup/symlinks.yml`.
Inheritance chain: Base → Tomorrow Dark/Light Mod → Air variants (per host).
iTerm picks up dynamic profile changes automatically (no restart needed).

### If this reverts or doesn't work

- Check `iterm/0.base.json` still has `"Title Components": 1`
- If window title bleeds into tab (like previous attempts with 3 and 6), the issue
  is that iTerm is using `\e]2;` (window title) for the tab. Try value 16 (Custom)
  or investigate whether `\e]1;` vs `\e]2;` matters for Session Name
- The open question about skipping `_palette_init_profile` for dark mode is still
  unresolved (see above) — if title issues persist, try removing the one-shot precmd
  entirely and see if new tabs still get the right profile
- `040-titles.zsh` sets both window (`\e]2;`) and tab (`\e]1;`) titles in the `title`
  function — if Session Name picks up the window title instead of tab title, that
  could cause the same bleed-through seen with values 3 and 6

## Previous session history

- 2026-03-23 — reproduced idle title reversion on work machine, added Title Components fix
- `a291fa17` — deep-dive on tab title components and iTerm title behavior
- `a0cd7841` — SIGUSR1 palette syncing, starship light mode, palette architecture
- (personal, earlier session) — idle title reversion investigation, commits `c0fad35`
  and `430d184`
