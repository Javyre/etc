---
name: writing-for-humans
description: >-
  Writing for human readers: messages, findings and reports, PR descriptions
  and changelogs, tickets and specs, proposals and decision records, guides
  and references. Use when drafting or revising text a person reads as a
  deliverable: a draft to send or paste, a file, a PR or issue body, or
  findings delivered in chat.
---

# Writing for humans

Text for people serves one reader's use of it: to understand, decide, act,
or find something again later. Shape every choice around that reader and
that use.

## Reader

Settle the reader before drafting.

- **Who and what for.** Name the reader and their need: to know, decide,
  act, or look something up. One text serves one reader and one need; split
  texts for unrelated readers. The need picks the shape below.
- **Internal or external.** External readers get no internal detail: no
  internal error messages, names, or private context.
- **Baseline.** Take it from the loaded instructions, project context, and
  memory. Internal teammates default to experts. Users and operators get only
  the prerequisites the text names. External decision makers get domain
  detail only where it moves the decision.

## Shape

The reader's need decides the shape; the destination only sets its limits.

**Argument**, when the reader needs to know or decide. Lead with the claim,
then its support.

- **Message.** The news or the ask in the first line; what you need from the
  reader and by when.
- **Findings.** Every finding has the same shape, in severity order: the
  claim stated plainly, where it is, why it matters, the evidence and your
  confidence, and what to do. State the fix or the fact, not what to avoid.
  Give a reader new to the code enough context to judge each finding. A
  restated report carries the current state of every open finding.
- **Change.** What changes for this reader: users get the visible effect,
  deployers the steps and risks that fall to them. Reviewers get the why
  first, in a sentence; the change in the views that carry it; the one fact
  its safety rests on and how far it is proven; undo, meaning how to back it
  out and what cannot be undone; the blast radius; and what to watch:
  deliberate omissions, surprises, migrations. Never a file-by-file
  changelog.
- **Decision.** Status first: proposed, with the decision requested and any
  deadline, or accepted, with its date. Then the recommendation or decision,
  the problem and its pressures, the alternatives and their consequences (in
  a record, why each lost), and the conditions that reopen it.

**Instrument**, when the reader needs to act or look something up. Shape it
like the task or the object, not like an argument.

- **Steps** (guide, runbook, how-to). Prerequisites and starting state;
  ordered actions, each with its observable result; the success state; the
  expected failures and how to recover from each.
- **Work item** (ticket, spec). The outcome and its observable behavior, why
  it matters, scope and non-goals, how acceptance is judged, and the open
  decisions that block it. Acceptance names signals the reader can observe. Leave the method to the owner unless a constraint
  forces it.
- **Reference** (architecture, design doc). A map of the system: where the
  sources live and who owns them, contracts and invariants, lifecycle and
  failure behavior, safe ways to change it, and hazards the code does not
  reveal. Point to discoverable source rather than restating it.

## Limits

Write the shortest text that serves the reader's need, and match any size
the request names ("two lines"). Cut detail the need does not use, or link to
it. The destination sets the rest:

| Destination | Limits |
|---|---|
| Chat or Slack | a few lines; the first line stands alone |
| PR description | readable in about a minute; plain markdown the host renders; verbatim output only when it is the proof |
| Changelog | one line per visible change, in the user's words |
| Ticket | a title that names the outcome in plain words |
| Repository document | a date or status where it can go stale; supersede a decision instead of rewriting it |
| Text that leaves the repo | permalinks, never relative paths; `path:line` is for chat |

For rendered output (HTML, formatted documents), load `$typesetting`.

## Communication

- **Answer first.** Lead the text, each section, and each paragraph with its
  conclusion; the support follows.
- **Lead with the difference.** When the reader expects a default, open with
  where this departs from it.
- **Linear.** The text reads in one pass from top to bottom and stands alone.
  Introduce each concept before the text leans on it. A new version restates
  what the reader needs; it does not point back to earlier messages.
- **Headings state the claim**, with the information-bearing words first:
  "Promotion can fork the archive", not "Hazard".
- **Chunks.** Keep paragraphs short, with one idea each. Parallel items read
  best as a list; compared items and condition → action branches as a table.
  Items that are not parallel stay in prose.
- **Views.** Show structure, flow, ownership, code, or a change as a view
  when it carries the point faster than prose; load
  [`references/views.md`](references/views.md).
- **Three layers, kept apart.** What to absorb, where it comes from (source
  links), and what people said about it (threads, stated intent, open
  questions) each have their own place.
- **Say it once.** Each fact has one home; elsewhere, link to it.
- **Evidence.** Anchor material claims to code, tests, history,
  measurements, or primary sources. Mark fact, inference, contradiction, and
  open uncertainty apart; keep causal claims no stronger than the evidence.
  Say how far each material claim is proven: stated, cited line, walked
  failure, ran it, or reproduced in the running system. When an example or
  value is missing, ask for it or cut the point; never invent one. State
  known limits and weaknesses where they apply.

## Register

Plain words in short sentences, in a direct voice. `$unslop` covers AI
tells. Use ASD-STE100 on request, and by default for binding or
under-pressure text: specs and runbooks. There it should read like an
aircraft manual, not an article.

## Revising

Change what the request asks and show it as a diff against the draft; write a
new draft only on request. Repair stale truth before extending a document.

## Completion

The reader can put the text to its intended use from the text alone,
without the conversation.
