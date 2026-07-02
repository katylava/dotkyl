---
name: tech-writing
description: >-
  Guidance for writing technical prose for an engineering audience — PR
  descriptions, commit message bodies, design docs and RFCs, technical
  explanations, code comments, incident write-ups, and any explanation of how a
  system behaves. Use this skill whenever you draft or revise writing whose
  reader is another engineer, even if the user only says "write up X", "explain
  this", "draft a PR description", or "add a comment". Also use it when asked to
  re-explain or clarify a confusing technical explanation — including phrasings
  like "I don't understand what this means", "explain this more clearly",
  "rewrite this so it makes sense", "explain it to me like a robot", "pretend
  you're a robot and explain again", or "robotify that". These robot-voice and
  re-explain requests should trigger the skill even when you're restating
  something you said earlier in the same conversation. The core idea: write for
  the reader's mental state, and default to a spare, declarative register — the
  fluency you add to "sound human" is the thing that reads as machine-generated.
  Do NOT use this for documentation in a dedicated docs repo (the devdocs-author
  skill covers that when present), and beyond these explicit requests it does not
  govern your default conversational chat voice.
---

# Technical writing

Your reader is an engineer who wants state and causation, not flow. They are
skimming under time pressure, deciding whether your change is correct, or trying
to act on what you wrote. Every principle below serves that reader. None of it
is about making the prose pleasant; it is about getting the reader to an
accurate mental model with the least work.

## Hold the reader's mental state

This is the lens everything else descends from. As you write each paragraph,
keep an active model of the reader:

- What do they know *right now*, at this line?
- How did they arrive here — from the top, from a deep link, from a search hit?
- What have they read so far, and what is still below them that they have not
  reached?
- What did they expect this section to contain when they clicked the heading?

You cannot write assuming they know nothing, and you cannot write assuming they
read every prior sentence. Re-ask these questions per paragraph. Apply the lens
hardest to your own framing and section-intro sentences: by their nature they
describe the document's shape — its parts and how they relate — which a reader
arriving linearly hasn't seen yet, so they are where you most easily assume
knowledge the reader lacks. When a later principle says "don't reference before
you introduce" or "name what will surprise them," it is just this lens applied to
a specific case.

## Default to a spare register — write like a robot

The instinct to "sound human" makes technical writing worse. The blunt fix:
write like a robot. State what was true, what is true now, and what causes what,
in declarative sentences, and let the structure show (prior behavior → cause →
fix → side effect) instead of dissolving it into prose.

What you drop is everything you add to sound human: balanced two-clause
sentences, decorative em-dash asides, vivid verbs ("carries," "races," "quietly
overwrites"), rhetorical turns ("rather than fight it, the fix..."), and
transitional cushioning ("it's worth noting that"). That smoothing is
fluency-performance. It is the layer that reads as machine-generated, and it is
what a technical reader has to wade through to reach the state and causation they
came for.

The effect is counterintuitive but reliable: the robot version reads as *more*
human — like a person who stated the facts and didn't fuss over how they
sounded. The fluency-performing version is the one that reads as the machine.

**Before** (performing fluency):

> When a subscription's stream dies, two code paths inside Google's library race
> to set the result — one carries the real error, the other quietly overwrites
> it with a blank, and on a starved pod the blank usually wins.

**After** (robot / spare):

> When a stream terminates, Google finalizes one result object per stream. Two
> code paths set it and race. One sets the real error; the other, stream
> teardown, sets a blank. The first to complete wins.

The "after" is less obviously authored, carries more information per word, and
is easier to check against the code.

**Metaphors supplement facts; they never carry them alone.** State what the thing
is in plain words first, then add the metaphor as a compact handle on it — most
useful when the plain statement is long or hard to hold. Test: can you delete the
metaphor and still have an account of what the thing *is*? "The queue is a shock
absorber for the pipeline" fails — delete "shock absorber" and nothing about what
the queue does remains. "The queue holds bursts of incoming events so downstream
stages read at a steady rate — a shock absorber for the pipeline" passes: the
plain fact stands, and "shock absorber" gives the reader a memorable grip on that
mouthful.

**Default to robot; add warmth deliberately.** It is easier to add warmth back
than to take it away. So start at the declarative end and add warmth only where the
job needs it — bringing a reluctant reader along, onboarding, persuading. A PR
description, a commit body, an incident write-up, a comment: keep them spare. (A
genuine hands-on tutorial wants more warmth, but that is a different job; see the
note on scope in the description.)

Spare does not mean context-free. The reader-mental-state lens still applies at
full strength: clipped prose with a forward reference or an unexplained term is
worse than warm prose without one.

## Expose structure with labels

When you strip fluency, you also strip the connective prose that used to carry
the structure ("rather than...", "but then...", "what's interesting here is...").
Labels carry it instead. Mark each block with the role it plays:
`Prior behavior:`, `Cause:`, `Fix:`, `Side effect:`, `Problem:`, `Test 1:`,
`Shows:`. A label that tells the reader what they will see before they read it
(a Datadog link followed by `shows ...`) is the same move applied to evidence.

Two reasons this earns its place:

- A reader skimming for one part jumps straight to it. The label states each
  block's role before they commit to reading it.
- Writing the label forces you to know the role. If you can't name what a block
  is doing, it may not belong — or it's two blocks wearing one.

Match the label to the content. Don't force a fixed template where plain prose
is clearer, and don't invent a taxonomy for parts that don't have distinct
roles. Labels work when the content genuinely separates — state vs. cause vs.
fix, claim vs. evidence, link vs. what-it-shows.

## Lead with the answer; let the hedge follow

State the conclusion or recommendation first, then the support, then the
caveats. Don't open with the throat-clearing that led you to the answer, and
don't bury the answer under the conditions on it. A reader who stops after the
first sentence should still have the most important thing.

The caveat section is optional. Include it only when there is a real
qualification; never manufacture one to round out the shape.

## Cut words that perform instead of inform

- **Fluff:** "simply," "just," "easily," "of course." These shift the blame for
  any difficulty onto the reader — "simply do X" makes a stuck reader feel
  stupid when X wasn't simple.
- **Marketing:** "robust," "powerful," "leverage," "seamless," "best-in-class."
  They assert quality instead of showing it.
- **Announcers:** "Here's what's going on," "It's worth noting that," "The key
  thing to understand is." They promise a point instead of making it. Delete the
  announcer and state the point.
- **Pep:** "Great question," "Awesome." Not for this reader.
- **Orienting scaffolding:** a whole sentence that only organizes, previews, or
  cross-references, with no fact of its own — "This section covers the rollout
  plan," "The rest of this doc is organized as follows." The heading and the
  content stand without it; cut it and let the content start.

## Carry the meaning, not the source's vocabulary

Almost everything you write transmits information that started somewhere else — a
proposal, a design doc, an existing system, a conversation — and that's true
whether you're rewriting, summarizing, or drafting fresh. When the source names
something with a coined term or metaphor ("substrate," "walking skeleton"), the
failure is carrying the word across while leaving its meaning behind. The word
is the source's packaging; your reader needs its content. Test: can you state
what the thing is without the source's term? If you can, and the
term is standard for this audience, keep it as shorthand. If you can't, you're
relaying a token you haven't decoded — go find the meaning before you pass it on.

## Introduce before you reference; attribute precisely

Define a term, tool, or concept the first time it appears, or link to where it
is defined. A reader who meets an undefined term either guesses or stops.

Naming a term is not introducing it. "The platform has four stages: ingestion,
enrichment, storage, serving" names the parts and stops. Introducing them says
what each does: ingestion accepts raw events, enrichment joins them against
reference data, storage persists the result, serving answers queries against it.
The names alone hand the reader none of that.

Be precise about *whose* system a behavior lives in. When you describe a
mechanism, the reader needs to know whether it is your code, a dependency, or the
platform — "Google finalizes the result object" and "our subscriber reads it"
carry different review implications, and blurring them sends the reader looking
in the wrong place.

When you attribute a claim, behavior, or design intent to a source — a doc,
another system, another author — you are making a checkable statement about what
that source actually contains. Don't dress an inference as an established fact.
If you reasoned it out rather than read it, say so, or go read it.

Naming a source is not citing it. When the reference itself says what the source
is — "per Google's SRE guidance" — that's enough. When it's an opaque label —
"per [Dapper](url)" — the reader can't place it (a tool? a person? a standard?),
can't weigh it, and can't tell what a click will get them. Give the name its
nature and provenance: "following Dapper, Google's research paper on distributed
request tracing, which showed one propagated trace ID can stitch a request's path
across every service it touches."

## Numbers and claims carry their reasons; don't invent or overclaim

A number without a reason gets copied blindly into the next config or overridden
at random. Pair each one with why it's that value ("evaluation delay: 900s, to
cover metric-collection lag"). If you don't have a real reason — it was just
picked — say that, or omit the rationale. Invented rationale is worse than none,
because the reader trusts it and propagates it.

Invented detail is the same failure. Reaching for concreteness, it's easy to take
a claim you only know in general and split it into particulars you're guessing
at: "the API supports several auth methods" becomes "supports OAuth, API keys,
and SAML," inventing the three when all you had was "several." Enumerate only the
parts you can back; otherwise leave the concept at the level you can support —
here, "several auth methods."

The same restraint applies to confidence. Don't write past what you can back up,
especially when the human reviewing your output can't easily check it. If you're
unsure, surface the uncertainty rather than smoothing over it with an
authoritative tone. A confident sentence the reviewer has to fact-check or delete
costs more than an honest "I'm not certain of this."

## Anticipate the reader

- **Name what will surprise them.** When the actual behavior contradicts the
  assumption the reader walks in with, say so out loud and say why. Listing the
  surface behavior and letting them discover the conflict by failing is the
  costliest path for them.
- **Make applicability concrete.** When a section applies to only some readers,
  give a concrete test for whether it applies to *this* one ("if your handler
  makes HTTP calls...") rather than a vague label ("in rare cases..."). Vague
  likelihood words are honest only when you genuinely can't offer a criterion.

## Use real examples, not placeholders

Real service names, real field names, real values. `placeholder-topic` and
`<your_value_here>` make the reader guess at the actual shape; a real example
teaches it. This matters most where conventions are implicit — the example is
where the reader learns them.

## When revising, write the end state, not the change to it

Revising a text across passes leaves residue that only makes sense against a
version the reader never saw. "The new endpoint," "the config now lives in the
environment," "we switched this to JSON" all frame the current state as a change
from a prior one — but the reader arrives with no history, so "new" and "now"
point at a "before" they don't have. They can't tell whether the old way still
matters, and may go hunting for it. State what is true now, flat: "the endpoint
returns JSON." Keep the delta only when the change itself is the reader's
business — a changelog, a migration guide, or a note on why the code isn't the
obvious way.

## Re-explaining a confusing explanation

When you're handed prose that isn't landing (often another session's
explanation) and asked to make it make sense, don't just rephrase it. Apply this
whole skill to it:

1. Find what the reader is actually stuck on — the specific gap, not the whole
   text.
2. Strip the original's fluency-performance and any jargon the reader doesn't
   have.
3. Rebuild it as state → cause → effect in the spare register.
4. Attribute precisely: whose system does each part of the behavior live in?
5. Name the thing that was surprising — usually the unstated cause that made the
   original confusing.

The original was likely confusing *because* it performed fluency over a gap. Your
job is to find the gap and state it plainly.

## Review pass before you hand it over

Reread once with the reader-mental-state lens, checking specifically for:

- **Forward references** — a pointer to later material ("covered below," "see
  the deploy section"). It earns its place only when it answers a question the
  reader already has *at that line*; when they have no such question yet, it
  raises a concern that wasn't there and sends them looking for nothing. (A term
  used before it's defined, when the reader needs it *now*, is a different
  problem — a gap you fix by introducing the term, not a forward reference.)
- **Jargon outside the audience** — anything this reader might not have.
- **Delta language** — "new," "now," "used to," "we moved/switched X" that frames
  the text as a change from a version the reader never saw (revisions only).
- **Vague applicability** — "sometimes," "rare," "in some cases" where you could
  name who's affected.
- **Invented rationale** — any "because X" you don't actually know to be the
  reason.
- **Words that perform instead of inform** — fluff, marketing, announcers, pep.
- **Performed fluency** — cadence, decorative asides, and vivid verbs that
  smooth the prose without adding information. If a sentence reads as "written
  to sound good," flatten it.
- **Confidence past your knowledge** — anything authoritative you can't point to
  a source for.

Fix what the pass turns up before handing the writing off.
