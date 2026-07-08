---
name: commit
description: Create git commits following the workflow and message conventions. Use whenever the user asks to commit, make a commit, save changes, or any variation of committing work. Always use this skill instead of the default commit behavior.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git reset:*), Bash(git commit:*), Bash(GIT_EDITOR=false git commit:*), Bash(git push:*), Bash(cat "$(git rev-parse --show-toplevel)/.git/COMMIT_EDITMSG":*), Bash(rm "$(git rev-parse --show-toplevel)/.git/CLAUDE_COMMIT_MSG":*), Write, Read(~/.dotkyl/home/claude/skills/tech-writing--personal/SKILL.md)
---

# Commit

The commit workflow puts the drafted message, file list, and diff into a
single file (`.git/CLAUDE_COMMIT_MSG`) for review before committing.

If the repo's CLAUDE.md has commit conventions, follow them; they override
the rules below where they conflict.

## Step 1: Understand the changes

Run in parallel:

- `git status` (never use `-uall`)
- `git diff` (staged + unstaged)
- `git log --author="$(git config user.email)" --oneline -10` for the
  current user's recent style. Filter to the user's own commits — other
  authors may use conventions the user has moved away from or that the
  repo doesn't require.
- `git rev-parse --show-toplevel` to get the repo root, `<root>`. Use it
  rather than assuming the cwd is the root — sometimes the cwd is a
  subdirectory.

## Step 2: Decide what to stage

Review each changed file's diff. For each, decide whether the whole file
belongs in this commit.

If a file's changes belong to different logical commits, since `git add
-p` isn't available, surface the diff hunks to the user and ask how to
handle it. Don't guess.

## Step 3: Draft the message

- **Subject**: aim for ~50 characters. Clarity wins over brevity, but
  trim filler words. Use short verbs (add, fix, rm, use, set, update).
- **Subject case**: sentence case. Capitalize the first word, lowercase
  the rest (except proper nouns).
- **Voice**: imperative or first person. Never third person — git
  records the author, so don't refer to them by name or as "the user".
- **Body** (optional): include when the *why* behind the change isn't
  obvious from the subject and diff. Separate from the subject with a
  blank line. Especially important when the subject was forced to be
  terse and that caused ambiguity. When you write a body, first Read
  `~/.dotkyl/home/claude/skills/tech-writing--personal/SKILL.md` and apply
  its guidance to the body prose.
- **Co-Authored-By trailer**: if Claude helped write the changes,
  include the trailer with the current model name (check the system
  prompt for the model ID). Separate from body/subject with a blank
  line.

## Step 4: Stage the files

Stage by name. Never `git add -A` or `git add .`.

## Step 5: Generate the verbose template

Run `GIT_EDITOR=false git commit -v || true`. Git writes the verbose
template to `.git/COMMIT_EDITMSG` (message area + file list + diff),
then aborts because `false` exits non-zero. The `|| true` suppresses
that expected non-zero exit so it isn't surfaced as a tool error.

## Step 6: Build the review file

Use the Write tool to write the drafted subject, body, and co-author
trailer to the review file at `<root>/.git/CLAUDE_COMMIT_MSG` (the
Step 1 `<root>` with `/.git/CLAUDE_COMMIT_MSG` joined on — not the cwd,
not a bare `/.git/...`). Then append the verbose template:

    cat "$(git rev-parse --show-toplevel)/.git/COMMIT_EDITMSG" >> "$(git rev-parse --show-toplevel)/.git/CLAUDE_COMMIT_MSG"

Don't use Edit on `.git/CLAUDE_COMMIT_MSG` — exact-match against the
template's empty message area is fragile and leaves stray blank lines.

## Step 7: Wait for review

Tell the user the message is ready for review. Mention the file path
(`.git/CLAUDE_COMMIT_MSG`) and the `edit.cm` alias (opens it in nvim). End
with the two ways to continue:

> Reply `lgcc` to commit as-is, or `upcc` if you edited the file.

Stop.

The user may:

- Reply `lgcc` ("looks good, commit as-is") or `upcc` ("I updated it,
  commit my version") — both are go-aheads. Proceed to Step 8. Either way
  you commit whatever the file now contains; the two differ only in what
  the user is telling you they did, not in what you do.
- Edit the file directly.
- Ask questions about the message or the diff.
- Ask you to rewrite the message — if so, repeat Step 6: Write the new
  message to `.git/CLAUDE_COMMIT_MSG` (this clobbers the appended
  template too), then re-append `.git/COMMIT_EDITMSG`. Then wait again.

Don't assume the next user message is a go-ahead. Wait for `lgcc`, `upcc`,
or another explicit confirmation.

## Step 8: Commit

Re-run `git status` first in case staging changed during the wait.

Commit:

    git commit -F "$(git rev-parse --show-toplevel)/.git/CLAUDE_COMMIT_MSG" -v --cleanup=strip

`git commit` reports success or failure through its exit code and the
short summary it prints. That output is the confirmation. If it exits 0,
the commit worked — do **not** run `git log`, `git cat-file`, `git show`,
or any other command to re-verify the commit contents. That's wasted
tokens.

Do not compare the committed message against what was drafted. The user
edits `.git/CLAUDE_COMMIT_MSG` directly — that's the entire point of the
review file. A subject, body, or prefix that differs from your draft is
the user's deliberate edit, never a bug to investigate or "fix" by
amending. The committed message is whatever the file said; leave it.

Then:

- Delete the review file and template so stale files aren't reused next
  time:

      rm "$(git rev-parse --show-toplevel)/.git/CLAUDE_COMMIT_MSG" "$(git rev-parse --show-toplevel)/.git/COMMIT_EDITMSG"
- Run `git status` **only** to check whether the branch is ahead of its
  remote tracking branch. This is not for verifying the commit — it's so
  that if there are unpushed commits, you can tell the user how many,
  since this skill doesn't prompt for pushing. If the branch isn't ahead,
  there's nothing to report.
- Don't push unless explicitly asked.
