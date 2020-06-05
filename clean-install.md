## How I do a clean install

Notes for my future self.

### Backup

First I use SuperDuper! to create a bootable backup of my whole drive. That
backup will be overwritten with new backups once I confirm everything is okay,
so I also backup the following to another drive, under
`pre-clean-install-home-folders/<computer name>-<mm>-<yyyy>`.

- ~/Code
- Select directories under ~/Library, some of which I just save _just in case_:
    FontCollections, Fonts, Keychains, LaunchAgents, Messages, Preferences,
    Printers, and StickiesDatabase.
- ~/Documents if there's anything useful there (it's usually empty though)
- ~/Desktop if there's anything useful there (also usually empty)
- Then I go through the hidden files and directories in my home directory and
    backup any of those that look useful.

Then I save lists of installed things to dropbox:

- `ls /Applications > Applications.txt`
- `brew list > brew-list.txt`
- `brew cask list > brew-cask-list.txt`
- `pip freeze > pip-freeze.txt`
- `pip3 freeze > pip3-freeze.txt`
- `ls go/bin > go-bin.txt`
- `tree -L 3 go/src > go-src.txt`

And I copy my .histfile to dropbox too.

Backup iStat menus preferences from "File > Export settings", also in Dropbox.

Before I move on to the clean install, I should make sure I don't have any
uncommited changes in my work repos:

```
for f in ~/Code/Work/*; do cd $f; echo $f; git status; done
```

... and check for uncommitted changes in my dotfiles too.


If I had personal projects, I would check those as well, but... :P.

### Clean install of MacOS

I google this.

### Restore

1. Very first thing is to change some preferences: keyboard, trackpad, and
   display.
2. Then remove all the junk from the Dock.
3. I've got to install Dropbox and get it synced so I can see my lists of
   installed things (maybe I should figure out how to use iCloud for this part).
4. Then I start by going through the lists of installed things and installing
   and configuring what I know for sure I will need the next workday.
5. I restore .histfile from Dropbox as well.
6. After that, `git` will certainly have been installed, so I clone my dotfiles
   and set those up.
7. Clone the work repos I know I'll be working on soon.
8. Contact IT to install security software required by work.
9. Lastly I create a generic admin user, set the same system preferences, and
   install SuperDuper!. After a while I will log in as the admin user and use
   SuperDuper! to overwrite my pre-clean-install backup with regular backups of
   my current system. I do this as a different user so all my usual background
   processes aren't running and probably changing files during the backup.
   Maybe this is silly?

Everything else I install as-needed. Ideally I never need to look at the home
directory things I backed up, but in pratice there is always something, so I
keep my external HD handy.
