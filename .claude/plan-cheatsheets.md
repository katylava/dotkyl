# Plan: Move Cheatsheets from iCloud into Repo

**Execute after:** plan-single-branch-dotfiles.md
**Batch with:** plan-remove-old-version-managers.md (both touch `lib/100-installed.zsh`)

## Current State

- `cheatsheets/` in repo has 18 sheets: apex, bash, brew, date, du, find, git, grep, history,
  ie-vs-eg, mac, markdown, npm, salesforce, vim, vim-substitutions, watch, zsh.
- `cheatsheets/orm` also exists but is `.gitignore`d (work-sensitive).
- Personal sheets live in `~/Library/Mobile Documents/com~apple~CloudDocs/CheatSheets/` (iCloud),
  inaccessible on the work machine.
- `lib/100-installed.zsh` exports `DEFAULT_CHEAT_DIR` pointing to the iCloud path — this is a
  legacy env var for older `cheat` versions and is now unused.
- `home/config/cheat/conf.yml` (the active config for modern `cheat`) already has `personal`
  cheatpath pointing to `~/.dotkyl/cheatsheets/`. No iCloud reference. No changes needed here.

## Options

### A. Add to this repo (recommended)
- Keeps everything in one place.
- Cheatsheets are not sensitive (general reference material).
- Slightly increases repo size, but cheatsheets are tiny text files.

### B. Dedicated repo
- Cleaner separation, easier to share publicly.
- Adds complexity (another repo to clone on fresh machines, another remote to manage).
- Only worth it if the cheatsheet collection becomes very large or you want public sharing.

**Recommendation: Option A.** The collection is small and already partially here.

## Steps

1. On the personal machine, list iCloud cheatsheets:
   ```zsh
   ls ~/Library/Mobile\ Documents/com~apple~CloudDocs/CheatSheets/
   ```

2. Compare against what's already in `cheatsheets/`. Copy new/updated sheets into `cheatsheets/`.

3. Review each new sheet for sensitive content. Add any sensitive ones to `.gitignore`
   (like `orm` already is).

4. Commit all sheets to `orm` only. Work-specific sheets should be `.gitignore`d as usual.

5. Remove the stale `DEFAULT_CHEAT_DIR` export from `lib/100-installed.zsh` (line 9).
   Also consider removing `CHEATCOLORS=true` on the same line — superseded by `conf.yml`.

6. Update `DEFAULT_CHEAT_DIR` in CLAUDE.md to remove the mention of iCloud.

## Notes

- No changes needed to `home/config/cheat/conf.yml` — it already works correctly.
- After migration, iCloud is no longer the source of truth; the repo is.
- Consider adding a note to the personal machine's shell that iCloud cheatsheets are migrated.
- All changes go on the single branch (see plan-single-branch-dotfiles.md).
