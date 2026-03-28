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

## Session 2026-03-28: Personal machine title reversion root cause

### Problem

On the personal machine (dark mode, no palette switch), tab titles revert to the profile
name. iTerm also overwrites the custom title set by the `claude` wrapper. On the work
machine, titles work correctly (peon-ping overwrites claude's title, which is expected).

### Root cause confirmed

The `Title Components: 1` fix is inherited correctly — both machines show "Session Name"
in iTerm's profile settings. The real issue is `_palette_init_profile` (lines 85-96 of
`002-colors.zsh`).

iTerm's default profile GUID (`Default Bookmark Guid` in `com.googlecode.iterm2`) is
`AE5AC02F-6F03-4B82-B72A-1E6838D6E067` = "Tomorrow Dark Mod". On the personal machine,
`_palette_init_profile` switches every new tab to "Tomorrow Dark Mod Air" — a real profile
change that triggers iTerm's async title reset. On the work machine, the default profile
IS "Tomorrow Dark Mod", so dark mode is a no-op — but light mode still triggers a real
profile switch and the same title reset.

On the personal machine, both dark and light mode are affected — Air profile variants
always differ from the default.

### Why escape-sequence-based fixes don't work

- Can't skip the profile switch — Air variants are needed (different font size)
- Can't change the default to one variant — other modes still need a switch
- Can't reliably set the title after `SetProfile` — iTerm processes it asynchronously
  after all shell escapes

### Proposed solutions (not started — compare before implementing)

**Option A: Modify dynamic profile JSON on disk**

Instead of switching between profiles via `SetProfile`, rewrite the active profile's JSON
(e.g. `iterm/3.tomorrow-dark-mod-air.json`) to swap in light/dark colors. iTerm auto-reloads
dynamic profiles from disk, so the current tab's appearance changes without a profile switch
— no async title reset. These files are already tracked in this repo.

Open questions:
- Does iTerm's auto-reload of dynamic profiles also cause a title reset?
- How fast does iTerm pick up the file change?
- The JSON files are version-controlled — need a strategy for generated-vs-committed state

**Option B: Change default profile via iTerm custom settings folder**

iTerm has a "Load settings from a custom folder or URL" feature (Settings → Settings tab).
Currently disabled, previously pointed at `/Users/kyl/Dropbox/SyncedSettings` (Dropbox no
longer installed).

The idea: point this at a folder we control (in this repo or another local path). When
`palette` switches modes, update the `Default Bookmark Guid` in the settings file to the
correct Air variant. New tabs open with the right profile natively — no `SetProfile` escape
on shell init, no async title reset. This also solves the secondary goal of backing up
iTerm settings.

Open questions:
- What format does iTerm write to the custom folder? (likely plist, unverified)
- Does enabling with an empty folder save current settings or load nothing?
- Current tab still needs `SetProfile` for immediate switch — does this still cause title
  reset on the current tab?

**Setup needed for Option B (if chosen):**

1. Back up current settings: `defaults export com.googlecode.iterm2 ~/iterm2-backup.plist`
2. Set the custom folder path (with iTerm closed):
   `defaults write com.googlecode.iterm2 PrefsCustomFolder -string "/path/to/folder"`
3. Enable loading: `defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true`
4. Launch iTerm and verify it saves current settings to the folder
5. Restore from backup if anything goes wrong:
   `defaults import com.googlecode.iterm2 ~/iterm2-backup.plist`

### Relevant defaults keys

```
defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder  # currently 0
defaults read com.googlecode.iterm2 PrefsCustomFolder          # currently /Users/kyl/Dropbox/SyncedSettings
defaults read com.googlecode.iterm2 "Default Bookmark Guid"    # AE5AC02F-6F03-4B82-B72A-1E6838D6E067
```

## Session 2026-03-28: Testing Option A and Option B

### Option A testing: dynamic profile JSON rewrite

**Test 1: Adding a key that doesn't exist in the child profile**

Added `Background Color` (dark red) to `iterm/3.tomorrow-dark-mod-air.json` — the Air
profile didn't have this key, inheriting it from the parent "Tomorrow Dark Mod" profile.

Result: iTerm picked up the change **instantly** — background turned red with no restart
needed. Did not test title reset because titles were already reverting from the existing
`_palette_init_profile` `SetProfile` call (couldn't isolate the signal).

**Test 2: Removing the added key (git stash)**

After reverting the file with `git stash` (removing the `Background Color` key), the
background stayed red — iTerm did **not** fall back to the parent profile's value. New
tabs also opened with the red background. Required iTerm restart to clear.

**Conclusion for Option A:** iTerm's dynamic profile inheritance does not handle key
removal correctly. Once a key is explicitly set in a child profile, removing it does not
cause iTerm to re-inherit from the parent — it caches the last explicit value. This means
Option A only works if you modify existing keys in place, never add or remove them.

**Option A viability:** To make it work, child profiles would need all color keys inlined
(not inherited). This defeats the purpose of inheritance — every color change would need
to be updated in every profile. **Not viable.**

### Option B testing: defaults write to change default profile GUID

**Test:** Changed `Default Bookmark Guid` via `defaults write` while iTerm was running:
```
defaults write com.googlecode.iterm2 "Default Bookmark Guid" "F12D33A3-86B4-4F63-B75F-D6659E2C1718"
```

Result: iTerm **did not pick up the change**. The global preferences UI still showed
"Tomorrow Dark Mod" as the default profile. iTerm holds preferences in memory while
running and ignores external `defaults write` changes. Would only take effect after
iTerm restart, at which point iTerm would likely overwrite it on next quit anyway.

**Conclusion for Option B (via defaults write):** Not viable for live switching. iTerm's
in-memory preferences take precedence over the defaults database while running.

**Option B via custom settings folder:** Not tested. The custom settings folder approach
might behave differently (iTerm may watch the folder for changes), but this is unverified.

### Updated problem statement

The problem is not machine-specific. Any time `SetProfile` switches to a profile that
**differs** from the tab's current profile, iTerm asynchronously resets the tab title.
This affects:
- Personal machine: both dark and light mode (Air variants differ from default)
- Work machine: light mode (default is dark, must switch to light)

A `SetProfile` call to the **already-active** profile is a true no-op — no title reset.
This was confirmed by manually changing the default profile in iTerm's UI on the personal
machine to "Tomorrow Dark Mod Air": new tabs opened correctly and `_palette_init_profile`'s
`SetProfile` to the same profile did not cause a title reset.

### Impact

Tab titles are not cosmetic — they're used to identify which task each tab is working on.
Idle tabs losing their titles means losing track of what's in each tab without switching
to it and running a command.

### Title Components testing

Tested changing `Title Components` in `0.base.json` to see if alternative values prevent
the title reset:

- **`Title Components: 16` (CUSTOM):** Immediately overwrites tab titles with profile name
  "Tomorrow Dark Mod" — worse than the default. After iTerm restart, no tab titles at all.
- **`Title Components: 0`:** Before restart, titles reverted to profile name. After restart,
  no tab titles at all.

Both values prevent escape-sequence titles (OSC 1) from displaying. **Title Components is
a dead end.**

### Root cause clarification: session name vs tab title

**Key insight:** The `title` function in `040-titles.zsh` uses OSC 1 (icon/tab title) and
OSC 2 (window title). Neither of these sets the iTerm **session name**. With
`Title Components: 1` (session name), iTerm displays the session name — OSC 1 is just a
temporary override that iTerm eventually re-evaluates back to the actual session name.

On idle tabs, iTerm isn't "resetting" anything — it's going back to the real session name,
which was always initialized from the profile name on session creation. precmd keeps
papering over it on every prompt via OSC 1.

**This explains the async/delayed behavior:** there is no timer or explicit reset. iTerm
just re-evaluates `Title Components` and the session name (= profile name) takes over when
the temporary OSC 1 override expires or is cleared.

### iTerm source code findings

From the iTerm2 source (gnachman/iTerm2):
- `setProfile:preservingName:` in PTYSession.m — preserves overridden session fields across
  profile switches (but we aren't setting the session name, so there's nothing to preserve)
- `autoNameFormat` — internal variable that stores the session name, initialized from profile
  name. This is what `Title Components: 1` displays.
- **No escape sequence exists to set session name directly.** OSC 1337 does not have a
  SetSessionName command.
- OSC 0 (set both icon name and window title) reportedly updates `autoNameFormat` — **tested
  and disproved.** OSC 0 does NOT set the session name. Titles still revert on idle tabs.

### Bound Hosts (reverted)

Re-added `"Bound Hosts": ["hyperion.lan"]` to `iterm/3.tomorrow-dark-mod-air.json`
(commit `8927772`, reverted). Titles persisted for dark mode, but `Bound Hosts` forces new
tabs to always open with the dark Air profile — `palette light` can switch the current tab
but new tabs revert to dark. Not viable for palette switching.

### OSC 0 test (failed)

Changed `title` function to use `\e]0;$title\a` instead of separate OSC 1 + OSC 2. Result:
no difference — titles still revert on idle tabs after `SetProfile`. OSC 0 does not set
the iTerm session name.

### Key observation: iTerm UI profile switching preserves titles

When switching a tab's profile via iTerm's UI (Edit Session or Profiles menu), the tab
title is **not** reset. This means iTerm's internal profile switching code path handles
titles correctly — the problem is specific to the `SetProfile` escape sequence (OSC
1337;SetProfile=). The escape sequence likely uses a different code path that reinitializes
the session name.

### Next experiment: iTerm Python API for profile switching

The Python API has `session.async_set_profile()` which switches a session's profile
programmatically. It likely uses the same internal code path as the UI (not the escape
sequence), which would mean it preserves titles.

```python
partialProfiles = await iterm2.PartialProfile.async_query(connection)
for partial in partialProfiles:
    if partial.name == "Target Profile":
        full = await partial.async_get_full_profile()
        await session.async_set_profile(full)
```

Requires iTerm's Python API runtime to be enabled. Would replace the `SetProfile` escape
sequence in `set-iterm-profile`.

### Remaining approaches if Python API doesn't work

- **TRAPALRM-based title refresh** — periodic re-set of title even when idle (workaround)
- **AppleScript** — may also use the UI code path for profile switching

## Previous session history

- 2026-03-28 — confirmed root cause: default profile GUID mismatch on personal machine;
  proposed custom settings folder approach
- 2026-03-23 — reproduced idle title reversion on work machine, added Title Components fix
- `a291fa17` — deep-dive on tab title components and iTerm title behavior
- `a0cd7841` — SIGUSR1 palette syncing, starship light mode, palette architecture
- (personal, earlier session) — idle title reversion investigation, commits `c0fad35`
  and `430d184`
