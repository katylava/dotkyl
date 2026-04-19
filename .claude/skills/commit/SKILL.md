---
name: commit
description: Create git commits following this repo's conventions. Use whenever the user asks to commit, make a commit, save changes, or any variation of committing work. Always use this skill instead of the default commit behavior.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), AskUserQuestion
model: sonnet
---

# Commit Skill for dotkyl

This repo uses a specific commit message format. Follow these steps to create a commit.

## Step 1: Understand the changes

Run these in parallel:
- `git status` (never use `-uall`)
- `git diff` (staged + unstaged)
- `git log --oneline -5` (for recent style reference)

## Step 2: Review diffs per file

For each changed file, read the diff carefully. You need to determine:
- **What area(s)** of the dotfiles are affected (see area prefixes below)
- **Whether the entire file should be staged**, or only some changes are relevant to this commit

If a file contains changes that belong to different logical commits, show the user the diff hunks and ask which ones to include. Since `git add -p` is not available (interactive commands don't work), stage whole files only when all changes in the file belong together. If only some hunks in a file should go in, tell the user and ask how they'd like to handle it (e.g., they can manually stage, or you can commit the whole file and they can split later).

## Step 3: Determine the area prefix

Commit subjects use the format: `<area>: <description>`

Common area prefixes derived from this repo's history:
- `zsh` — anything in lib/*.zsh, shell config
- `nvim` — neovim config
- `bin` — scripts in bin/
- `git` — git-related config (includes gitconfig, gitignore, etc.)
- `alias` — alias changes (in lib/010-aliases.zsh)
- `crontab` — cron jobs
- `claude` — .claude/ config, CLAUDE.md (but see `skills` below)
- `skills` — Claude skills (under `home/claude/skills/` or `.claude/skills/`)
- `home` — files in home/ (symlinkable dotfiles)
- `iterm` — iTerm2 profiles/config
- `urlwatch` — urlwatch config
- `cheatsheets` — cheatsheet files
- `setup` — setup scripts (manage-symlinks, etc.)
- `docs` — fallback for documentation-only changes (README, plan files, etc.) that aren't tied to a more specific area

Multiple areas can be comma-separated: `zsh, iterm: ...`

The area prefix should reflect what the change is **about**, not just which files were touched. For example, a `.gitignore` change in service of the zsh lib loader is `zsh:`, not `zsh, git:`. Ask "what is this change in service of?" to pick the right prefix.

**If the area isn't obvious, ask the user.** Don't guess.

## Step 4: Draft the commit message

Rules:
- **Subject line**: `<area>: <description in imperative mood>`
- **Subject length**: aim for ~50 characters. This is a soft target — clarity wins over brevity, but don't be wordy. Trim filler words, use short verbs (add, fix, rm, use, set, update).
- **Body** (optional): include when the *why* behind the change isn't obvious from the subject and diff. When used, separate from subject with a blank line. Especially important when the subject was forced to be terse and that caused ambiguity.
- **Co-Authored-By trailer**: if Claude helped write the changes being committed, include the Co-Authored-By trailer. Use whatever model name is current (check system prompt for the model ID). Always separated from body/subject by a blank line.

Examples of good subjects from this repo:
```
zsh: Remove unused GREP_COLORS export
nvim: Add claudecode and diffview plugins
bin: Fix query_roam so LLM can use --help
zsh, iterm: Add light mode support
git: Ignore .claude/settings.local.json
```

## Step 5: Confirm with the user

Before committing, confirm with the user using `AskUserQuestion`. Include the files and commit message directly in the question text so they're visible inside the prompt UI (text output above the prompt gets cut off).

- Question: Include the file list and full commit message in the question string, e.g. "Commit `lib/001-path.zsh`?\n\n`zsh: Add ~/.local/bin to PATH`"
- Header: "Commit"
- Options:
  - **Yes** — commit only
  - **Yes and push** — commit and push to remote
  - **No** — abort

## Step 6: Commit

- Stage specific files by name (never `git add -A` or `git add .`)
- Use a HEREDOC for the commit message to preserve formatting:
  ```bash
  git commit -m "$(cat <<'EOF'
  <subject>

  <optional body>

  Co-Authored-By: <current model> <noreply@anthropic.com>
  EOF
  )"
  ```
- Run `git status` after to verify success
- Do NOT push unless explicitly asked
