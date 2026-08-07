# General

When you invoke a skill, its instructions override any rule in this file they conflict with. Global rules that don't conflict still apply.

## Preflight (before starting a non-trivial task)

- If I reference an external source (ticket, PR, link, design doc, Slack thread, etc.) and don't paste the contents, fetch and read it before doing any work. If you can't access it, ask me for the contents. The reference is part of the spec — don't infer the spec from the one-line ask.
- When a task is ambiguous, ask clarifying questions **before** starting work. Don't guess at requirements.
- Before implementing, ask what "done" looks like if I haven't provided tests, expected output, or success criteria.
- When you're about to write a script, chain commands together, or compose a multi-step tool sequence, pause first and check the skill listing. If a skill already covers what you're about to build, use it instead.
- Plan any non-trivial work as small reviewable chunks. Do ONE chunk's worth of changes, then stop and wait for me to come back with feedback or confirmation before starting the next chunk. A chunk is the smallest self-contained change that leaves the code working — for TDD that's one failing test plus the minimum code to pass it, even if it spans multiple files, and including any docs/comments that need to change alongside that code. It is NOT the whole feature, NOT several tests with their implementations, and NOT one piece of behavior plus the next one "since they're related." If you can split the work into two passes that each leave tests green, do. When in doubt, smaller. Don't bundle "while I'm here" cleanups, renames, or follow-on edits into the current chunk — surface them as candidates for next chunks and wait.
- Auto mode is on so I don't get bombarded with permission prompts, not so you can work autonomously for an entire task. Pause for review at chunk boundaries the same as you would without auto mode.
- Before starting research or exploration, briefly state what you're looking for, why, and how you plan to search, then proceed — you don't need permission to look something up. I'll redirect if I want to.
- Define what "answered" looks like before you start. When research surfaces a new question you weren't originally asked, stop and surface it. Don't spawn follow-up searches to answer questions I didn't ask. Finish the original thread first, report what you found, then propose the follow-up if it still matters.
- Before launching a subagent, tell me what it will do and why. Keep the scope narrow enough that it won't run for minutes unsupervised.

## Writing for other Claude sessions

- When I ask you to produce a plan, context doc, handoff, spec, or any artifact whose reader is another Claude session, write it Claude-to-Claude — not in my first-person voice. The default mistake is to author it as if I wrote it ("I want to...", "my goal is..."); don't. Frame it as one Claude briefing another: state what was done, what's left, what to watch for, and address the reading agent directly.
- This applies whenever the consumer is a Claude session, even if I phrase the request as "write up X for me." The audience is the next agent, not me. I'm the conduit, not the author.
- Include an attribution line stating the artifact was written by Claude, not me. Put it at the top of the file (or the first line after the first heading, if there is one), in italics. Writing in the Claude-to-Claude voice isn't enough on its own — make it explicit so the reader (and I) can't mistake it for something I authored.
- Doesn't apply to artifacts meant for humans (docs, PR descriptions, messages, anything I'll publish under my own name) — those stay in my voice. If it's ambiguous who the reader is, ask.
- Also doesn't apply to instruction files written in my voice as standing directives to you — CLAUDE.md files, skill instructions, and the like. Those are read by a Claude session but are authored as my rules ("when I ask you to..."), so keep them first-person. The Claude-to-Claude rule is for one-off artifacts handed off between sessions, not for the persistent instructions that configure you.

## Behavior during work

- Don't ask me to look things up or do tasks that you can do faster with your tools. Use your tools — but tell me what you're doing as you go.
- For deep exploration (reading many files, aggregating content), avoid running dozens of compound commands or inline scripts that each need manual approval. Write a reusable script to a file and execute it — the file execution can be allowlisted once.
- When making more than ~3 similar edits to a file (bulk deletions, renames, pattern replacements), use `sed` via Bash instead of multiple sequential Edit tool calls.
- When I ask for output written to a file, put it in the current working directory unless I say otherwise — not your scratchpad. The scratchpad is for your own intermediate/working files, not for deliverables I asked you to produce.
- Never assert the current state of external systems (git, filesystem, processes, remote branches) based on what you remember doing. The user works in other terminals and time passes between turns. If you're about to say "X is uncommitted" or "the file still has Y" or "the server is running" — check first, or phrase it as a question.
- Auto-memory is only worth using for facts specific to the current project (e.g. "this repo's build needs env var X"). General feedback, preferences, or cross-project guidance belongs in an explicit tracked file (this CLAUDE.md, a project CLAUDE.md, update to the relevant skill, a new skill, etc.) — not auto-memory. If in doubt, ask where to put it.
- When the auto-mode classifier blocks a tool call ("not authorized by your plan execution"), tell me what was blocked and ask if I approve. Once I say yes, retry — the classifier learns from my approval and allows it on the retry. Don't retry without asking, and don't fall back to asking me to perform the action manually.
- When you attribute a view, claim, framing, or mental model to someone else ("the other Claude said X", "your model assumes Y", "the PR is arguing Z"), you are making a falsifiable claim about what the source actually contains. If I push back on that attribution — in any form, including just restating my own point differently or quoting the source at you — stop and re-read the source verbatim before responding. Compare what it literally says against what you've been arguing against. If you introduced a distinction, taxonomy, or framing the source didn't contain, name that explicitly and drop it.

# Workflow

_This applies to generated output in a git repo. Do not use this workflow when copying or moving text or files around, or when working in a non-git directory._

- Before starting changes, pull latest main and create a feature branch. Don't edit on `main` directly.
- Before starting a chunked task, run `git status`. If there are unstaged changes from earlier in the session, surface them for review and staging before making new edits — otherwise the next chunk's `git diff` will be polluted with prior work.
- **Reviewing chunks.** Full flow per chunk:
    1. `git add` the previous chunk. Skip only if there is nothing to stage. If there are untracked files, stop and ask me what to do — don't guess whether they're part of the previous chunk. **DO NOT SKIP THIS STEP** when there is tracked work to stage — staging the previous chunk is how the next `git diff` stays clean. This is not a separate step that earns its own pause.
    2. Make the edit for the current chunk. **Do not run `git add` on it.** **Do not commit.**
    3. Stop. Wait for me to come back with feedback or confirmation, then loop back to step 1.

    I review each chunk with `git diff`, and I need that diff to show only the new chunk — not the new chunk plus any prior chunks that I already approved. Staging the previous chunks is what keeps them out of the next `git diff`. Skipping it forces me to mentally separate the current chunk from prior chunks in a cumulative diff, which defeats the whole point of chunked review.

    Announcing the stage as its own turn ("Staged. Ready for the next chunk.") is wasted output — once I confirm a chunk, stage it and proceed into the next edit in the same turn. The chunk loop is for review, not for shipping — committing is a separate, explicit step that I have to ask for.

# Shorthand

Abbreviations the user will use and what they mean.

- qnotc: question not challenge (or question not correction). Just answer the question, don't assume it is pushback or a change request.

# Environment

- Terminal: iTerm2
- Editor: neovim
- tmux is available for terminal emulation by the AI (user does not use it)
