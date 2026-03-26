---
name: pr-dashboard
description: >
  Show a prioritized dashboard of open PRs that need attention. Covers PRs
  authored by the user, PRs they've commented on, and keyword-matched PRs
  across oreillymedia. Use when Katy asks about open PRs, what needs review,
  what's going on, or wants a PR status check. Also trigger on "my PRs",
  "what needs my attention", "PR dashboard", or "check PRs".
allowed-tools: Bash(pr-dashboard *), Bash(gh pr view * | tee *), Bash(gh api * | tee *), Bash(mkdir -p /tmp/pr-dashboard-cache)
---

## Step 1: Gather PRs

Run the `pr-dashboard` script. Pass through any keywords the user provided
as-is (do not expand or modify them).

```
pr-dashboard [keyword ...]
```

## Step 2: Triage each PR

For each PR in the output, fetch details directly (do NOT use subagents).
Save each result to `/tmp/pr-dashboard-cache/` so the user can ask
follow-up questions without re-fetching. Run these as parallel Bash calls
(multiple tool calls in one message):

```
mkdir -p /tmp/pr-dashboard-cache
gh pr view <number> --repo <owner/repo> --json title,body,comments,reviews,statusCheckRollup,reviewRequests \
  | tee /tmp/pr-dashboard-cache/<owner>-<repo>-<number>.json
gh api repos/<owner>/<repo>/pulls/<number>/comments \
  | tee /tmp/pr-dashboard-cache/<owner>-<repo>-<number>-review-comments.json
```

Both calls for the same PR can run in the same Bash call (joined with `&&`).
The review comments include line-level code review comments, which are
needed to accurately determine whether feedback has been addressed.

When the user asks a follow-up question about a specific PR, read from the
cache first (`/tmp/pr-dashboard-cache/`) instead of fetching again.


Determine what action (if any) is needed:

**My PRs:**
- **approved** — ready to merge
- **changes requested** — address feedback (summarize what's asked)
- **review comments** — respond to comments (summarize the thread)
- **awaiting review** — no action needed, just waiting
- **CI failing** — fix the build

**Commented / Keyword matches:**
- New comments or activity since the user's last comment — summarize what changed
- Review requested from the user personally (not just their team) — needs review
- Team review requested — informational only, not action needed
- No new activity — skip (don't include in output)

Note: The user's GitHub login is `katylava` and their team is
`oreillymedia/systems-engineering`. `reviewRequests` in the gh JSON
includes both individual and team requests. Only requests for `katylava`
specifically count as personal review requests. Requests for
`systems-engineering` or any other team are much lower priority.

## Step 3: Present a todo list

Output a markdown list grouped by urgency — NOT by the script's groups
(authored/commented/keyword). A PR from any script group can land in any
urgency section. Use the full PR URL from the script output (these are
correct `/pull/` URLs — do not construct your own).

Do NOT use `#number` format (e.g. `#42`) — terminals auto-link it to the
current repo's issues. Use `repo PR number` instead (e.g. `my-service PR 42`).

IMPORTANT — sections MUST appear in exactly this order. Do not rearrange:
1. Action needed
2. Ready to merge
3. Waiting
4. Keyword matches
5. Team review requested (short summaries only — 1 sentence)
Omit empty sections but never change the relative order.

Every PR in every section MUST include:
- The last updated date (from the script output) in the first line
- Its full URL on the line after the summary
No exceptions.

Summaries for sections 1-4 should be 2-4 sentences — enough to know
what's going on and decide whether to click through, but not a full recap
of the PR. Section 5 (team review requested) should be 1 sentence only.

```
### Action needed
- **my-service PR 42** (2d ago) — address review feedback from @reviewer:
  "..." Two reviewers approved but @other flagged a concern about the
  config change. CI passing.
  https://github.com/org/my-service/pull/42

### Ready to merge
- **my-service PR 55** (today) — approved by @reviewer, CI passing.
  Straightforward bugfix, no open threads.
  https://github.com/org/my-service/pull/55

### Waiting
- **my-service PR 78** (3d ago) — awaiting review, CI passing. No activity.
  https://github.com/org/my-service/pull/78

### Keyword matches
- **other-service PR 99** (today) — @coworker migrating consumers to
  pub/sub. Awaiting review from their team, has some discussion about
  error handling.
  https://github.com/org/other-service/pull/99

### Team review requested
- **shared-service PR 12** (yesterday) — @someone adding a new feature.
  https://github.com/org/shared-service/pull/12
```
