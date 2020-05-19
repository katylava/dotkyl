# dotkyl


my dotfiles (my initials are kyl)


## Contents

### /bin

Half of these are from other people's gists or other uninstallable utils. The
other half are dumb things I wrote.

### /bookmarks

Empty directory (in git) which will contain symlinks to bookmarked directories.

### /completion

Zsh completion scripts that I couldn't get from homebrew `zsh-completions`. Not
many.

### /home

Actual dot files, without the dot. `bin/setup-dotfiles` symlinks them to home
dir (with the dot).

### /iterm

iTerm2 themes.

### /lib

Files that are sourced by `~/.zshrc`. Coolest thing in here is
[`bookmark`](https://github.com/katylava/dotkyl/blob/master/lib/080-bookmarks.zsh).

### /nvim

Neovim configuration -- init.vim plus some custom syntax and colors. Also
vim-plug.

`bin/setup-dotfiles` symlinks this directory to `~/.config/nvim`.

If you looked at my init.vim, yeah I know, I have too many plugins. Half of
them I don't even use. I'm a plugin hoarder. We could make a TV show about
people like me.

### crontab.txt

I always set my crontab with `crontab crontab.txt` instead of directly with
`crontab -e` so I can keep it under version control. One less thing to
re-figure out on clean install.
[Unrelated](https://www.youtube.com/watch?v=r7ANZ8Osnz4).


## Install

These installation instructions are for my future self. But I guess they could
be useful if you decided to set up your dotfiles like mine.

```
cd ~  # this is important or setup-dotfiles won't work
git clone git@github.com:katylava/dotkyl.git .dotkyl
.dotkyl/bin/setup-dotfiles
cp path/to/000-private.zsh .dotkyl/lib/
```

### Neovim

To set up neovim with python support, install both major versions of
python via homebrew first, then use each version's pip to install python stuff
for neovim. I don't know the perfect setup for neovim+python, but this works
for me, I think because of [these two
lines](https://github.com/katylava/dotkyl/blob/adc90bc8be25a39952b7f24832c62a955149a07f/nvim/init.vim#L1-L2)
in my init.vim. There are probably disadvantages to this method when working in
a virtualenv.

```
brew install python python3 neovim/neovim/neovim
pip install neovim
pip3 install neovim
```

To finish setting up neovim, open it and do `:PlugInstall`.


## Usage

Some people keep dotfile repos so they can clone them to servers they work with
and have the same settings everywhere. That's not why mine are here. They are
here for sharing and for re-installing after a clean install of Mac OS. I would
not set these up on a server.


## How I do a clean install

Also notes for my future self.

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


## TODO

* Add a way to sync relevant ~/.config files and directories (besides `nvim`)
* Add alternate zshrc for use inside nvim terminals.
* Find a way to keep secrets even secreter via keychain. [This looks
  useful](https://github.com/sorah/envchain).
* Terminal palettes – find some way to store and use themes with alternate
  colors which go with the main 8 terminal colors.
* Use Go scripts to build prompt – [like
  powerline-go](https://github.com/justjanne/powerline-go), but:
  - use my terminal colors
  - customize symbol segment from command line
  - special formatting when on dangerous branches
  - left-pointing powerline symbols for right prompt
  - maybe all git statuses in one segment
  - maybe kube current context instead of cluster + namespace
  - only show kube info if current directory has kube folder
* Or use Rust for prompt

