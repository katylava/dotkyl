---
name: git-conventions
description: Conventions for git commands. Use whenever you are about to commit, push, amend, or rebase.
---

# Git conventions

## Commit messages

- **Subject length**: aim for ~50 characters. This is a soft target — clarity
  wins over brevity, but don't be wordy. Trim filler words, use short verbs
  (add, fix, rm, use, set, update).
- **Voice**: imperative or first person. Never third person — git already
  records the author, so don't refer to them by name or as "the user".
- **Body** (optional): include when the *why* behind the change isn't obvious
  from the subject and diff. When used, separate from subject with a blank
  line. Especially important when the subject was forced to be terse and that
  caused ambiguity.
- **Co-Authored-By trailer**: if Claude helped write the changes, include the
  trailer using whatever model name is current (check the system prompt for
  the model ID). Separate from body/subject by a blank line.

## Confirming before committing

Before committing, confirm via `AskUserQuestion`. Include the files and full
commit message directly in the question text — text output above the prompt
UI gets cut off.

- Question: include the file list and full commit message, e.g.
  `Commit foo.txt?\n\nfix: typo in foo`
- Header: "Commit"
- Options:
  - **Yes** — commit only
  - **Yes and push** — commit and push to remote
  - **No** — abort

## Committing

- Stage specific files by name. Never `git add -A` or `git add .`.
- Use a HEREDOC for the message to preserve formatting:
  ```bash
  git commit -m "$(cat <<'EOF'
  <subject>

  <optional body>

  Co-Authored-By: <current model> <noreply@anthropic.com>
  EOF
  )"
  ```
- Run `git status` after to verify success.
- Don't push unless explicitly asked.

## Amending

Never amend a commit on a pushed branch without explicit permission.
