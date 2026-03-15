# dotkyl


my dotfiles (my initials are kyl)


## Contents

### /bin

Half of these are from other people's gists or other uninstallable utils. The
other half are dumb things I wrote.

### /bookmarks

Empty directory (in git) which will contain symlinks to bookmarked directories.

### /cheatsheets

Cheatsheets for [`cheat`](https://github.com/cheat/cheat).

### /completion

Zsh completion scripts that I couldn't get from homebrew `zsh-completions`. Not
many.

### /home

Actual dot files, without the dot. Symlinked to home dir (with the dot)
by `mise run install`.

### /iterm

iTerm2 dynamic profiles. Symlinked to where iTerm2 looks for such things by
`mise run install`.

### /lib

Files that are sourced by `~/.zshrc`. Coolest thing in here is
[`bookmark`](https://github.com/katylava/dotkyl/blob/master/lib/080-bookmarks.zsh).

### /nvim

Neovim configuration -- init.vim plus some custom syntax and colors. Also
vim-plug.

Symlinked to `~/.config/nvim` by `mise run install`.

If you looked at my init.vim, yeah I know, I have too many plugins. Half of
them I don't even use. I'm a plugin hoarder. We could make a TV show about
people like me.

### /setup

Artifacts that `mise run install` uses to keep the machine in the right state.

### mise.toml

Task definitions for `mise run install` (symlinks, brew packages, crontab,
git hooks, etc.) and `mise run sync` (fast subset for the post-merge hook).

### crontab.txt

I always set my crontab with `crontab crontab.txt` instead of directly with
`crontab -e` so I can keep it under version control. One less thing to
re-figure out on clean install.
[Unrelated](https://www.youtube.com/watch?v=r7ANZ8Osnz4).


## Install

These installation instructions are for my future self. But I guess they could
be useful if you decided to set up your dotfiles like mine... unfortunately, I
have revamped this repo recently and haven't yet created the bootstrapping
script, so I don't even know the installation steps right now. Need to
implement the plan in .claude/plan-bootstrap.md first.

Neovim plugins: open nvim and do `:PlugInstall`.


## How It Works

*This section was written by Claude (Opus 4.6).*

The central idea is that `mise run install` brings any Mac into the desired
state. Every task is idempotent — it checks whether work needs to be done
before doing it, so the command is always safe to re-run.

### mise as a task runner

[mise](https://mise.jdx.dev) is primarily a dev tool version manager, but it
also has a built-in task runner. `mise.toml` defines tasks for symlinks, brew
packages, crontab, git hooks, and more. Each task uses inline check-or-run
logic so that passing checks result in a skip:

```toml
[tasks.crontab]
run = """
crontab -l 2>/dev/null | diff -q - crontab.txt >/dev/null \
  && echo "⏭️ already ok" \
  || { crontab crontab.txt && echo "✅ installed"; }
"""
```

There are two entry points: `mise run install` runs all tasks (including
slow ones like brew), and `mise run sync` runs only the fast tasks.

### Automatic sync via post-merge hook

A git post-merge hook (`setup/hooks/post-merge`) runs `mise run sync` after
every `git pull`. The workflow across machines is: push on one, pull on the
other, and the hook takes care of the rest.

### Host-specific configuration

This repo is shared across a personal and a work machine. Files that should
only apply to one host use a `--<host>` suffix:

```
lib/010-aliases.zsh              # both machines
lib/070-kubernetes--work.zsh     # work only
```

`bin/get-host` maps the machine's hostname to a semantic name (`personal` or
`work`). The zshrc loader uses this to skip files not meant for the current
host. Brew packages follow the same pattern with `setup/Brewfile.shared`,
`setup/Brewfile.work`, and `setup/Brewfile.personal`.

### Private configuration

Secrets and org-specific config live in a separate private repo, cloned to
`~/.dotkyl/private/`. Its `lib/` and `home/` directories are loaded and
symlinked alongside those from the main repo.
