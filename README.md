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

iTerm2 themes (dynamic profiles). Symlinked to where iTerm2 looks for such
things by `mise run install`.

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

These installation instructions are for my future self.

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
4. **mise and 1Password CLI**:
   ```zsh
   brew install mise 1password-cli
   ```

### Bootstrap

Run the bootstrap script (fetches via curl before the repo is cloned):

```zsh
curl -fsSL https://raw.githubusercontent.com/katylava/dotkyl/main/setup/bootstrap | zsh
```

Or if you've already cloned the repo:

```zsh
cd ~/.dotkyl
setup/bootstrap
```

This will generate an SSH key, register it with GitHub via 1Password, clone the
repos, and run `mise run install`.

### After bootstrap

1. Add your machine's hostname to `bin/get-host`
2. Commit and push
3. Run `mise run install` again (so host-specific tasks pick up the new hostname)
4. Open nvim and run `:PlugInstall`


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


## Claude

*This section was also written by Claude.*

A lot of the recent work in this repo was done collaboratively with
[Claude Code](https://claude.ai/code) (Anthropic's CLI agent). Commits with
a `Co-Authored-By: Claude` trailer were pair-programmed in this way — Claude
proposes changes, the repo owner reviews and approves each commit.

Claude has project-level context via `CLAUDE.md` (repo conventions, architecture,
file layout) and persistent memory across sessions (user preferences, project
state, feedback). It also has two custom skills for this repo:

- **commit** — creates commits following the repo's `<area>: <description>`
  format, stages files explicitly, and confirms the message before committing.
- **write-script** — writes or refactors shell scripts in `bin/`, applying the
  repo's style conventions.

Renovation plans live in `.claude/plan-*.md`. These are living documents that
Claude and the repo owner work through together — Claude updates them as work
is completed and decisions change.

*A note from the human.*

I don't let Claude run wild here. I use it to help me brainstorm and write and
refine plans. Lot's of refining. Almost every action and every change requires
my approval (by which I mean I haven't auto-approved much). I don't commit
anything I don't understand (though sometimes it has to explain things to me).

Oh, I guess that's not entirely true. There a few things I just let Claude do
without thinking much:

* The query_roam.py script was like 80% vibe coded. I needed results fast. I
  hope to refactor someday.
* The palette switching in lib/002-colors.zsh was 100% written by Claude. I was
  in a hurry to work outside to protect a feral kitten from a mean old tomcat
  (!), and I needed light mode to work reliably for that. As part of that it
  also wrote the iTerm tomorrow-light profiles. Happy to let it write iTerm
  profiles for me in the future because it's so much easier than doing it
  through the iTerm settings and exporting them.
* When I'm ready to do the neovim vimscript->lua conversion, I think Claude
  will be doing a lot work that I don't understand.

There's other stuff in here that I didn't write and don't fully understand, but
it was written by other humans in the pre-LLM era.

_(!) The kitten has since since been trapped and as I'm writing this on March
15, 2026, she is scheduled to be spayed tomorrow, so don't worry for her!_

<img src="https://lh3.googleusercontent.com/pw/AP1GczMKU0sKJuuHlJ4EVSJt9RUlVATfn4QRRsROqlSA_nsVzPGZQePXqw8IYYsBIVet6E3X229Adz8NwH4GopE-mWNaQ2HbrfdJQRfQR0kDPZZjSyF9eR29mp78bBTvu3z3MwZgO2ZS0W_eDfEv7_A0Bttc=w1186-h1576-s-no-gm" alt="Tempo" width="400">
