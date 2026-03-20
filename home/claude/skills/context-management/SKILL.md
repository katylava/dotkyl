---
name: context-management
description: Guidance on when to use subagents to keep the main conversation context clean. Use this skill when you're about to do research that involves reading many files (5+), exploring unfamiliar parts of a codebase, investigating a bug across multiple modules, or answering a broad question that requires gathering information from scattered sources. Also use when the user asks you to "look into", "investigate", "explore", or "find out how X works" — these are signals that the work is research, not implementation, and a subagent can do it without bloating the main context.
---

# Context Management: When to Use Subagents

The main conversation's context window is a finite, precious resource. Every file you read, every
command you run, every tool result — it all accumulates. When context fills up, performance
degrades: you start forgetting earlier instructions, losing track of decisions, and making mistakes.

Subagents run in their own context window. They can read dozens of files, explore broadly, and
then report back a concise summary. The main conversation only sees the summary.

## When to suggest a subagent

Before starting research that will touch many files, pause and consider whether a subagent would
be more efficient. Signals:

- You're about to read 5+ files to answer a question
- The user asked you to "investigate", "look into", "explore", or "find out how X works"
- You need to search across a codebase for patterns, usages, or conventions
- You're debugging and need to trace a call chain through multiple modules
- The user asked a broad question about how something works

## When NOT to use a subagent

- You already know which 1-2 files to look at
- The user is asking you to implement something (they need the context in the main conversation)
- The research is trivial (a single grep or glob)
- The user is mid-conversation about a topic and the files are already in context

## How to suggest it

Don't just silently spawn a subagent. Mention it briefly:

- "That'll involve reading through several files — I'll use a subagent to investigate and report back."
- "Let me delegate that research to a subagent so we keep this context clean."


## How to structure the delegation

Give the subagent a specific research question, not a vague directive:

**Good**: "Find all places where authentication tokens are refreshed, trace the refresh flow, and
summarize the mechanism including which files are involved."

**Bad**: "Look at the auth code."

The subagent should return a summary with:
- The answer to the research question
- Key file paths and line numbers for reference
- Any decisions or tradeoffs it noticed

## After the subagent reports back

Summarize the findings for the user concisely. Don't dump the full subagent report — distill it
to what's relevant for the current task. The user can ask follow-up questions if they need more
detail.
