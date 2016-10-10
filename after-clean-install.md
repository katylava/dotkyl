# System Prefs

- Reverse map ctrl/caps-lock
- Configure screensaver to only disable with password (security settings)
- Disable Time Machine (if it's not disabled by default)
- Tweak energy saver settings
- Set up trackpad gestures (three finger drag is in Accessibility > Mouse and Trackpad > Trackpad Options button)
- Sharing > name computer
- Mission Control > turn off dashboard, set up screensaver hot corners
- Accessibility > enable ctrl+scroll to zoom

# Applications

Install Chrome, then install Dropbox. Then look in ~/Dropbox/CleanInstall for a
list of applications and evaluate which ones to install again.

In System Preferences > Keyboard > Shortcuts, add app shortcuts for Airmail
next/previous account (`Shift+Cmd+]` and `Shift-Cmd-[`)

In System Preferences > Security & Privacy > Privacy > Accessibility, select
apps that can control computer (aka "Enable access for assistive devices"). May
have to open each app at least once before they show up there.

## Notes

- Transmit favorites are synced via Dropbox.
- iTerm2 configuration can be synced by reading from Dropbox/SyncedSettings
- All app licenses are in Gmail and/or 1Password

# Packages

Install homebrew, then look in ~/Dropbox/CleanInstall for a list of what to
(maybe) install with brew and other package managers.

# Terminal

After installing zsh via brew, add `/usr/local/bin/zsh` to `/etc/shells` and do `chsh -s /usr/local/bin/zsh`.

Fix `Ctrl+h` in neovim:

```
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
```

# Set up dotfiles

Clone this repo to ~/.dotkyl and run `~/.dotkyl/bin/setup-dotfiles`. Also do
`mkdir -p ~/.tmp/nvim`.

# Migrated Folders and Files

Review ~/Dropbox/CleanInstall files and folders and decide what to copy over.

# Work

- Follow dev runbook.
- Install [Pentaho Data Integration](http://community.pentaho.com/projects/data-integration/).
- Set up Resilio Sync folders.

# Clean Up

Delete the ~/Dropbox/CleanInstall directory.
