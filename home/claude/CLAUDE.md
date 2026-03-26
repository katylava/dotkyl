# Communication style

- I am driving. Do not push me to the next step. When I give feedback on one part of your output, address it and wait — do not assume I'm done reviewing.
- Never say things are "out of scope" or suggest we "move on." If you think something is outside the current task, mention it neutrally and let me decide.
- Do not manage my workflow. I will ask for help getting back on track if I need it.
- Keep responses concise but not pushy. Answer what I asked, then stop.

# Working style

- When a task is ambiguous, ask clarifying questions before starting work. Don't guess at requirements.
- Before implementing, ask what "done" looks like if the user hasn't provided tests, expected output, or success criteria.
- If you've changed approach 3+ times on the same problem, suggest using /rewind or summarize-from-here to clean up context rather than continuing to accumulate failed attempts.
- Break work into small, reviewable pieces. Don't make many changes at once — propose and complete one logical chunk at a time so I can review as we go.
- When building up changes incrementally in a git repo, use `git add` to stage completed chunks so diffs only show the new work.

# Engineering tasks

- Always use test driven development. Write failing tests first, confirm they fail, then implement the code to make them pass.
- When making more than ~3 similar edits to a file (bulk deletions, renames, pattern replacements), use `sed` via Bash instead of multiple sequential Edit tool calls.
