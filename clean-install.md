# Clean Install

"Clean install" means both: wiping existing computer and starting over;
installing on a new computer for the first time.

## Backup

Make a SuperDuper! bootable backup of the whole drive first. That backup
will get overwritten once the new install is confirmed good, so also back
up the following to an external drive under
`pre-clean-install-home-folders/<computer name>-<mm>-<yyyy>`:

- `~/code`
- Selected dirs under `~/Library` (just in case): FontCollections, Fonts,
  Keychains, LaunchAgents, Messages, Preferences, Printers, StickiesDatabase
- `~/Documents` and `~/Desktop` if non-empty
- Useful hidden files/dirs from `~/` (scan and pick)
- `~/.histfile`
- iStat Menus preferences (File → Export settings)

Check for uncommitted changes in git repos and dotfiles.

## Clean install of macOS

Google the current method.

## Restore

1. Set system preferences: keyboard, trackpad, display.
2. Clean up the Dock.
3. Install prerequisites (see below) and run the bootstrap script — this
   clones dotfiles and sets up the machine.
4. Restore `~/.histfile` from the external drive.
5. Clone work repos I'll need soon.
6. Contact IT for required security software.
7. Create a generic admin user, mirror my system prefs, and install
   SuperDuper!. Later, log in as admin and use SuperDuper! to overwrite
   the pre-clean-install backup with regular backups. Running as a
   different user keeps background processes from changing files
   mid-backup. (Maybe silly?)

Install everything else as needed. Ideally the home-dir backups on the
external drive go untouched, but in practice there's always something.

### Prerequisites (manual, in order)

1. **Xcode Command Line Tools** — provides `git`, `make`, etc.:
   ```zsh
   xcode-select --install
   ```
2. **Homebrew**:
   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. **1Password app** — install from https://1password.com and sign in.
4. **GitHub personal access token** stored in 1Password at
   `Personal/GitHub Token/credential`, with the `admin:public_key` scope
   (needed to register SSH keys).
5. **mise and 1Password CLI**:
   ```zsh
   brew install mise 1password-cli
   ```

### Bootstrap

Run this — it fetches via curl before the repo is cloned:

```zsh
curl -fsSL https://raw.githubusercontent.com/katylava/dotkyl/main/setup/bootstrap | zsh
```

It generates an SSH key, registers it with GitHub via 1Password, clones
the repos, and runs `mise run install`. Follow the "Next steps" it prints.
