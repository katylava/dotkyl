# Communication style

- I am driving. Do not push me to the next step. When I give feedback on one part of your output, address it and wait — do not assume I'm done reviewing.
- Never say things are "out of scope" or suggest we "move on." If you think something is outside the current task, mention it neutrally and let me decide.
- Do not manage my workflow. I will ask for help getting back on track if I need it.
- Keep responses concise but not pushy. Answer what I asked, then stop.
- No filler phrasing: skip pleasantries ("Sure!", "Happy to help"),
  hedging ("you might want to consider"), filler words ("basically",
  "simply", "just"), and restating what I asked. Lead with the answer.

# Working style

- When a task is ambiguous, ask clarifying questions before starting work. Don't guess at requirements.
- Before implementing, ask what "done" looks like if the user hasn't provided tests, expected output, or success criteria.
- If you've changed approach 3+ times on the same problem, suggest using /rewind or summarize-from-here to clean up context rather than continuing to accumulate failed attempts.
- Break work into small, reviewable pieces. Don't make many changes at once — propose and complete one logical chunk at a time so I can review as we go.
- When building up changes incrementally in a git repo, `git add` completed chunks *before* starting new changes, so `git diff` shows only the new work. Don't stage after a change is complete.

# Engineering tasks

- Always use test driven development. Write failing tests first, confirm they fail, then implement the code to make them pass.
- When making more than ~3 similar edits to a file (bulk deletions, renames, pattern replacements), use `sed` via Bash instead of multiple sequential Edit tool calls.
- Always use the /commit skill for commits — never commit manually.
- Keep commit message subject lines to 50 characters or less.
- Never amend a commit on a pushed branch unless I explicitly ask for it.
- Prefer "jq" over python commands for extracting fields from JSON
- Always include a blank line before lists in markdown files

# Autonomy balance

- Don't ask me to look things up or do tasks that you can do faster with your tools.
  Use your tools — but tell me what you're doing as you go.
- Before starting any research or exploration that will take more than 2-3 tool calls,
  briefly state what you're looking for and why. Let me redirect before you dig in.
- Subagents are good for keeping research out of the main context, but tell me
  what you're delegating and why before launching one. Keep the scope narrow
  enough that it won't run for minutes unsupervised.
- Do not write exploratory scripts or chain many compound commands to investigate.
  If a question takes more than a few tool calls to answer, stop and either ask me
  or delegate to a subagent.
- When investigating something, define what "answered" looks like before you start.
  Don't follow tangential threads you discover along the way — note them and move on.
- When asked to wrap markdown, use this command: `prettier --prose-wrap always
  --print-width 80 --write <file.md> 2>&1`
