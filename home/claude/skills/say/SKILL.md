---
name: say
description: Turn on (or adjust) spoken progress narration via the macOS `say` command, so the user can follow your work by ear while away from the keyboard. The user invokes this with `/say [level]` — they pass a level word as the argument (off, quiet, default, verbose) or nothing for the default level. Narration is off unless invoked. This is user-invoked only; do not trigger it on your own.
---

# Spoken progress narration

The user invoked `/say` to control whether you speak short progress updates out loud with the macOS `say` command. Set the narration level from the argument and keep it for the rest of the session (until the user invokes `/say` again).

## Set the level from the argument

The invocation argument is a single level word. Map it:

- `off` — stop speaking progress entirely.
- `quiet` — speak only at decision points and forks (where you choose an approach), so the user hears the *why* and can redirect.
- `default`, or **no argument** — decision points and forks, plus one short line before you start each step. Don't narrate routine reads and searches.
- `verbose` — add a short line for most actions, including notable reads and searches.

If the argument is anything else, ask which level the user meant rather than guessing.

Acknowledge the new level briefly in text (one line), then follow it from the next action onward.

## How to speak

- Background it — `say "..." &` — so speech never blocks your work. One `say` per update; don't queue several at once.
- Keep each utterance short: a few words to one clause, phrased to be heard, not read. Summarize what's happening; don't read your written output aloud.
- Never speak secrets, tokens, file contents, or anything sensitive.
- Spoken lines are in addition to your normal written output, not a replacement. Don't make your text terser to compensate, and don't repeat in text what you just spoke.

## Not your job

Approval and question alerts are handled by a separate always-on `say` hook (`~/.claude/hooks/say-notify/`). It announces when the user needs to approve something or answer a question, regardless of the narration level — including when narration is off. Don't speak those yourself.
