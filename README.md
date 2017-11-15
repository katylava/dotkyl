# dotkyl

my dotfiles (kyl is my initials)

### /bin

Half of these are from other people's gists or other uninstallable utils. The other half are dumb things I wrote.

### /completion

Zsh completion scripts that I couldn't get from homebrew `zsh-completions`. Not many.

### /home

Actual dot files, without the dot. `bin/setup-dotfiles` symlinks them to home dir (with the dot).

### /lib

Files that are sourced by `~/.zshrc`. Coolest thing in here is [`bookmark`](https://github.com/katylava/dotkyl/blob/master/lib/080-bookmarks.zsh).

### /nvim

Neovim configuration -- init.vim plus some custom syntax and colors. Also vim-plug. 

If you looked at my init.vim, yeah I know, I have too many plugins. Half of them I don't even use. I'm a plugin hoarder. We could make a TV show about people like me.

### crontab.txt

I always set my crontab with `crontab crontab.txt` instead of directly with `crontab -e` so I can keep it under version control. One less thing to re-figure out on clean install. [Unrelated](https://www.youtube.com/watch?v=r7ANZ8Osnz4).
