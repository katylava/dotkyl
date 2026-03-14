# Plan: Alternate zshrc for Neovim Terminals

**Execute after:** plan-single-branch-dotfiles.md (new zshrc loader must be in place),
plan-remove-old-version-managers.md (`085-versions.zsh` is deleted there — remove it from the
load/skip table below if that plan has already been executed)
**Execute before:** plan-nvim-lua-migration.md (the terminal mapping change from `term://zsh -f`
to `term://zsh` is a step in this plan; the migration assumes it's already done)

## Why a Separate Config Is Needed

nvim sets `$NVIM` (a socket path) in every terminal buffer it spawns. The current `home/zshrc`
unconditionally sources every `lib/*.zsh` file. Several are slow, wasteful, or actively harmful in
a nvim terminal split.

**Things that break or cause visible noise:**
- `040-titles.zsh` — sends OSC escape sequences to set iTerm2 window/tab title. Leak into nvim's
  terminal buffer and conflict with nvim's own title management.
- `020-keybindings.zsh` — enables vi-mode and emits cursor-shape escape sequences on keymap changes.
  These conflict with nvim's cursor handling.
- `090-prompt.zsh` — runs `eval "$(starship init zsh)"`. Starship fires git status queries on every
  prompt; slow and wasted in a narrow split.

**Things that are slow and wasteful:**
- `100-installed.zsh` — runs `brew --prefix` (subprocess) and sources four heavy plugins
  (fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search).
- `015-completion.zsh` — calls `compinit` and sources gcloud completion; slow, rarely needed in split.
- `095-run.zsh` — forks `ssh-add -l`; the nested shell inherits `$SSH_AUTH_SOCK` from parent.
- `085-versions.zsh` — adds a precmd hook that runs `findup` + `nodenv init -` on every prompt.
- `002-colors.zsh` — runs `vivid generate jellybeans` (subprocess). Cosmetic, avoidable.
- `080-bookmarks.zsh` — registers ZLE widget (`@@`) that is meaningless inside nvim.

## Detection

```zsh
[[ -n "$NVIM" || -n "$NVIM_LISTEN_ADDRESS" ]]
```

`$NVIM` is set by current nvim; `$NVIM_LISTEN_ADDRESS` covers older versions.

## Approach A: Single zshrc with Conditionals

Replace the glob loop in `home/zshrc` with a case statement skipping heavy lib files when inside nvim.
Pros: one file. Cons: loader becomes hard to read; skip list is a hidden maintenance burden.

## Approach B: Separate File with Early Return (Recommended)

Create `lib/nvim-zshrc.zsh` as a first-class minimal config. In `home/zshrc`, add an early-return
guard at the top:

```zsh
if [[ -n "$NVIM" || -n "$NVIM_LISTEN_ADDRESS" ]]; then
    source ~/.dotkyl/lib/nvim-zshrc.zsh
    return
fi
```

Why better: the minimal config is self-documenting and independently testable
(`NVIM=/tmp/x zsh -i`). No tangled conditionals in the loader.

## lib File Load/Skip Table

| File | Load in nvim? | Reason |
|---|:---:|---|
| `000-private.zsh` | YES | Env vars/secrets needed everywhere |
| `001-path.zsh` | YES | PATH must be correct |
| `002-colors.zsh` | NO | Runs `vivid` subprocess; cosmetic only |
| `003-locale.zsh` | YES | `LC_ALL`, `TZ` needed everywhere |
| `010-aliases.zsh` | YES | Useful for running commands |
| `015-completion.zsh` | NO | `compinit` + gcloud source; slow, rarely needed |
| `020-keybindings.zsh` | NO | vi-mode + cursor-shape escapes conflict with nvim |
| `030-history.zsh` | YES | Shared history is desirable |
| `040-titles.zsh` | NO | OSC escapes interfere with nvim title management |
| `080-bookmarks.zsh` | NO | ZLE widget irrelevant inside nvim |
| `085-versions.zsh` | NO | `precmd` running version manager init on every prompt |
| `090-prompt.zsh` | NO | Starship is slow; fancy prompt wasted in a split |
| `095-run.zsh` | NO | ssh key already inherited; `ssh-add -l` is redundant |
| `100-installed.zsh` | NO | `brew --prefix` subprocess + 4 heavy plugins |

`~/.miserc-zsh`: YES — mise shims needed for language tools.

## Implementation Steps

**1. Create `lib/nvim-zshrc.zsh`:**

```zsh
# Minimal zsh config for neovim terminal buffers.
# Loaded instead of the full lib/*.zsh stack when $NVIM is set.

for f in \
    ~/.dotkyl/lib/000-private.zsh \
    ~/.dotkyl/lib/001-path.zsh \
    ~/.dotkyl/lib/003-locale.zsh \
    ~/.dotkyl/lib/010-aliases.zsh \
    ~/.dotkyl/lib/030-history.zsh; do
    [[ -f $f ]] && . $f
done

[[ -f $HOME/.miserc-zsh ]] && source $HOME/.miserc-zsh

setopt autocd

# Simple prompt — no starship, no git status
PS1='%F{cyan}%~%f %% '
```

**2. Add early-return guard to `home/zshrc`** (before the `for f in` loop):

```zsh
if [[ -n "$NVIM" || -n "$NVIM_LISTEN_ADDRESS" ]]; then
    source ~/.dotkyl/lib/nvim-zshrc.zsh
    return
fi
```

**3. Test:**

```zsh
NVIM=/tmp/fake.sock zsh -i   # no starship, no fzf-tab, aliases work, PATH correct
unset NVIM; zsh -i            # normal shell unaffected
```

**4. Optional — update nvim terminal mappings in `nvim/init.vim`:**

Current mappings use `term://zsh -f` (bare shell, skips zshrc entirely). After this change,
`term://zsh` will use the fast minimal config instead, giving aliases and correct PATH:

```vim
" Change from:
nnoremap ,tv :vsp term://zsh -f<CR>i
" To:
nnoremap ,tv :vsp term://zsh<CR>i
```

## Branch Strategy

All changes go on the single branch (see plan-single-branch-dotfiles.md).
