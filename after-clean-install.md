# System Prefs

- Reverse map ctrl/caps-lock
- Configure screensaver to only disable with password
- Disable Time Machine
- Tweak energy saver settings
- Set up trackpad gestures
- Sharing > name computer
- Mission Control > turn off dashboard, set up screensaver hot corners
- Accessibility > check zoom settings

# Applications

Install Chrome, then install Dropbox. Then look in ~/Dropbox/CleanInstall for a
list of applications and evaluate which ones to install again.

In System Preferences > Keyboard > Shortcuts, add app shortcuts for Airmail
next/previous account (`Shift+Cmd+]` and `Shift-Cmd-[`)

In System Preferences > Security & Privacy > Privacy > Accessibility, select
apps that can control computer (aka "Enable access for assistive devices"). May
have to open each app at least once before they show up there.

# Packages

Install homebrew, then look in ~/Dropbox/CleanInstall for a list of what to
(maybe) install with brew and other package managers.

# Terminal

- After install iTerm2, set it to read preferences from ~/Dropbox/SyncedSettings.
- After installing zsh via brew, do `chsh -s /bin/zsh`.

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
