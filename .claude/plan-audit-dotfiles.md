# Plan: Audit ~/. for Repo Inclusion

**Execute after:** plan-single-branch-dotfiles.md (private repo must exist first)

## Goal

Decide what in `~/` and `~/.config/` should be tracked in git, and where:
- Public, non-sensitive config → main repo (`home/` or `home/config/`)
- Private or org-sensitive config → `dotkyl-private/home/` or `dotkyl-private/lib/`
- Tool state, secrets, or auto-generated files → leave untracked

## What Is Already Managed

**Main repo (`home/`):**
`dwdiffrc`, `gitattributes`, `gitconfig`, `gitignore`, `inputrc`, `psqlrc`, `pyhooks/`,
`urlwatch/`, `vale.ini`, `zshenv`, `zshrc`

**Main repo (`home/config/`):**
`cheat/`, `starship.toml`

**Special case:** `nvim/` → `~/.config/nvim`

## Categories and Routing

**Tool-generated state** (`.cache/`, `.nvm/`, `.fzf/`, `.histfile`, `.viminfo`, etc.)
→ leave untracked

**Contain plaintext secrets or auth tokens — never commit anywhere:**
- `.npmrc` (has live GCP OAuth tokens)
- `.edgerc`, `.ssh/`, `.gnupg/`, `.kube/`, `.terraform.d/`, `.pypirc`, `.vpn/`
- `~/.config/gh/hosts.yml`

**Contains sensitive but not secret org info (internal hostnames, internal tool config)**
→ `dotkyl-private`

**Work-specific tool data** (`.akamai-cli/`, `.chassis/`, `.cagent/`, `.cisco/`)
→ evaluate per tool: if config is worth tracking, `dotkyl-private/home/`

**Editor/IDE state** (`.cursor/`, `.windsurf/`, `.codeium/`, `.vim/`) → leave untracked

## Recommended Additions

### Main repo (public, non-sensitive)

| File | Repo path | Notes |
|---|---|---|
| `~/.editorconfig` | `home/editorconfig` | Small generic config, zero risk |
| `~/.config/mise/config.toml` | `home/config/mise/config.toml` | Global tool versions, no secrets |
| `~/.config/git/ignore` | `home/config/git/ignore` | Audit overlap with `home/gitignore` first |
| `~/.config/gh/config.yml` | `home/config/gh/config.yml` | Safe prefs; leave `hosts.yml` untracked |
| `~/.bashrc` | `home/bashrc` | Read first; add if generic |

### Private repo (`dotkyl-private`, sensitive but worth tracking)

| File | Repo path | Notes |
|---|---|---|
| `~/.boto` | `home/boto` | May contain org-specific endpoints |
| `~/.config/iterm2/` | `home/config/iterm2/` | Check for scripts with internal URLs |
| Work tool configs | `home/<toolname>rc` | Review per tool |

### Leave untracked (secrets or auto-generated)

`.npmrc`, `.edgerc`, `.ssh/`, `.gnupg/`, `.kube/`, `.terraform.d/`, `.pypirc`, `.vpn/`,
`~/.config/gh/hosts.yml`, `~/.claude.json`

## Process for Adding Files

**To main repo:**
1. Confirm no secrets: `grep -i 'token\|secret\|password\|key\|auth' <file>`
2. Confirm no internal hostnames or org-specific details
3. Copy to `home/` or `home/config/`, delete original, run `bin/setup-symlinks`, verify, commit

**To private repo:**
1. Copy to `~/.dotkyl/private/home/` or `~/.dotkyl/private/lib/`
2. Delete original, `bin/setup-symlinks` handles it (processes both repos), verify, commit to `dotkyl-private`

**Partial-directory case** (e.g. `gh/config.yml` without `hosts.yml`): `bin/setup-symlinks`
symlinks whole directories by default. For partial cases, add explicit per-file symlink logic
to `bin/setup-symlinks`.

## Decision Rule

> Would this reveal anything about internal O'Reilly systems, infrastructure, or tooling to
> someone outside the org? If yes → `dotkyl-private`. If no → main repo. If it has auth
> tokens or credentials → leave untracked entirely.
