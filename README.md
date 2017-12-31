# dotkyl


my dotfiles (my initials are kyl)


## Contents

### /bin

Half of these are from other people's gists or other uninstallable utils. The
other half are dumb things I wrote.

### /completion

Zsh completion scripts that I couldn't get from homebrew `zsh-completions`. Not
many.

### /home

Actual dot files, without the dot. `bin/setup-dotfiles` symlinks them to home
dir (with the dot).

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
cd ~
git clone git@github.com:katylava/dotkyl.git .dotkyl
.dotkyl/bin/setup-dotfiles
crontab .dotkyl/crontab.txt
mkdir .dotkyl/bookmarks
cp path/to/000-private.zsh .dotkyl/lib/
```

Also there are files in Dropbox/dotkyl-private that I might want to manually
symlink to the home directory.

To finish setting up neovim, open it and do `:PlugInstall`.

## Usage

Some people keep dotfile repos so they can clone them to servers they work with
and have the same settings everywhere. That's not why mine are here. They are
here for sharing and for re-installing after a clean install of Mac OS. I would
not set these up on a server.


## TODO

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

