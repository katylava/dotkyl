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
- `.gnupg/`, `.kube/`, `.terraform.d/`, `.pypirc`, `.vpn/`
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

## Audit Tasks

Claude can only access one machine per session. To audit both:

1. On each computer, run these and save the output to a file in the repo:
   ```
   ls -d ~/.[!.]* | sort > /tmp/dotfiles-audit-$(hostname).txt
   ls ~/.config/ | sort >> /tmp/dotfiles-audit-$(hostname).txt
   ```
2. Bring both files into a Claude session (or paste them) for help categorizing
3. For each entry, decide: public repo / private repo / host-specific / leave untracked
4. Pay special attention to files that exist on one machine but not the other —
   these are likely host-specific and need conditional symlinking

## Process for Adding Files

**To main repo:**
1. Confirm no secrets: `grep -i 'token\|secret\|password\|key\|auth' <file>`
2. Confirm no internal hostnames or org-specific details
3. Copy to `home/` or `home/config/`, delete original, run `setup/manage-symlinks`, verify, commit

**To private repo:**
1. Copy to `~/.dotkyl/private/home/` or `~/.dotkyl/private/lib/`
2. Delete original, `setup/manage-symlinks` handles it (processes both repos), verify, commit to `dotkyl-private`

**Partial-directory case** (e.g. `gh/config.yml` without `hosts.yml`): `setup/manage-symlinks`
symlinks whole directories by default. For partial cases, add explicit per-file symlink logic
to `setup/manage-symlinks`.

## Host-Specific and Per-File Routing

Some dotfiles need more nuance than "public vs private" — they vary per host, or a single
directory contains a mix of public/private/work/personal files.

### Known cases

**`~/.ssh/config`** — different on work vs personal. Both versions should be stored so
either machine can be set up from scratch.
- Option A: `home/ssh/config--personal` and `private/home/ssh/config--work`, with a
  symlink task that picks the right one based on `$DOTKYL_HOST`
- Option B: A shared base `home/ssh/config` with host-specific `Include` directives
  pointing to `~/.ssh/config.d/work` or `~/.ssh/config.d/personal`
- The symlinks system (`setup/manage-symlinks` + `symlinks.yml`) may need to support
  host-conditional entries for cases like this.

**`~/.edgerc`** — private, work-only. Goes in `dotkyl-private/home/edgerc` and should
only be symlinked on the work machine.

**`~/.claude/skills/`** — mixed routing:
- Some skills are personal (both machines, public repo)
- Some are work-only (public repo, `--work` suffix or conditional symlink)
- Some are both (public repo, no suffix)
- Some are private (dotkyl-private)
- Current `setup/symlinks.yml` symlinks whole directories. Need per-file or per-subdirectory
  routing for `.claude/skills/`.

### Implication for symlink tooling

The current `setup/manage-symlinks` + `symlinks.yml` system handles:
- Whole-directory symlinks (`home/config/*` → `~/.config/`)
- No host-awareness or per-file routing

To support the cases above, it needs to gain either:
- Host-conditional entries in `symlinks.yml` (e.g., `only_on: work`)
- Per-file entries for mixed directories
- Or a convention where private repo symlinks override/supplement public ones per host

This should be designed as part of this audit, not deferred.

## Decision Rule

> Would this reveal anything about internal O'Reilly systems, infrastructure, or tooling to
> someone outside the org? If yes → `dotkyl-private`. If no → main repo. If it has auth
> tokens or credentials → leave untracked entirely.
