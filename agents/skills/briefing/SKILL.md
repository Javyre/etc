---
name: briefing
description: >-
  Briefs that bring a reader to judge a target: a report, article, spec,
  PR, codebase area, or question. Use when asked to brief me, to walk
  through a topic from scratch, to study a document, or to prepare to
  review a PR. Writes linear local HTML pages.
---

# Briefing

A brief brings a reader to judge a target on their own. The **seed**
(report, PR, URL, spec, question) names the target. It does not define the
content: teach what the reader needs to judge it, from the mechanism up, and
treat each seed claim as a hypothesis to test.

## Ends

The communication succeeds when the reader is:

- **Oriented in a minute.** From the metadata, the bottom line, and the
  headings alone, they know what the target is, what the brief concludes,
  and where the risk sits.
- **Able to judge.** After one linear read, they can explain the mechanisms
  and decide the decision questions without the brief.
- **Able to check.** Every claim reaches its primary source in one click,
  and they can tell fact from inference from the unverified.
- **Calibrated.** They know where the seed and the brief are wrong, weak, or
  stale, and what nobody checked.
- **Able to return.** Later, the headings and the map take them back to any
  point.

Everything below serves these ends. "A finished set" is the acceptance
check, and each item there records a real failure, so meet it. The rest are
defaults that usually serve the ends well. Use judgment, and depart from one
when the brief in hand is better served another way.

## Invocation

- **Seed.** Optional. With only a question, the question is the target.
- **Scale.** Fit the set to the gap between the reader and the target: one
  page (`index.html` only) when one mechanism closes it, an index plus one
  page per mechanism otherwise. "lite", "quick", or "one page" in the request
  forces one page; "full" or "deep" forces a set.
- **Seed audit.** On when the seed makes claims: each claim gets a verdict.
  Off when the request says so in any words ("no audit", "just teach", "skip
  verdicts").
- **PR.** When the seed is a PR, branch, or revision range, also load
  [`references/pr.md`](references/pr.md).

## A finished set

- **Framed.** The index states the **frame**: a metadata block of what the
  reader acts on, in terse values (the seed and its state, the pins, the date
  checked, and the assumed reader baseline), and a few decision questions.
  The baseline (from `$writing-for-humans`) sets what pages skip, the
  vocabulary, the prose style, and which code is the reader's own. When the
  seed is pinned older than the repository head, the index lists the later
  commits that touch its claims, and the brief judges claims against head.
- **Mapped.** Every decision question and seed claim maps to the pages that
  answer it (a table on the index), and every page serves a question or a
  later page. Pages follow concept dependency: none needs a later page.
- **Sourced.** Every claim traces to a primary source at a pinned revision,
  preferring live system state, then code, then specifications, then official
  documentation, then secondary writing. Where sources disagree, the higher
  one wins and the page says so. Quotes are the source's own text, from the
  file or page itself rather than a tool's summary of it, long enough to
  carry the point, with the decisive part marked. Fact and inference are
  marked apart.
- **Linked.** Every reference links to its exact target: code line
  permalinks, specification sections, documentation pages, registry or
  on-chain objects. Identifiers in prose (specification numbers, `path:line`,
  API names, commits, versions) count as references, across the whole set.
  Links point at pushed revisions, or at `file://` with a note when the code
  is local. Line citations go in the source line of the block they support,
  not in its sentences.
- **Consistent.** `facts.md` in the set holds every number, version, date,
  and claim used on more than one page, each with its source. Writers work
  from it and the frame; a correction lands in `facts.md` first, then
  in every page.
- **Judged.** With the audit on, each seed claim has a verdict (holds,
  partly, fixed at head, wrong, unverified) and its evidence, on the pages it
  touches.
- **Refuted first.** Every claim survived an attempt to disprove it against
  its source before delivery.

## Teaching

Aids that help novices slow experts down (expertise reversal). Size
every aid below to the baseline: cut what the baseline surely covers, and
collapse what it may cover into a "Background" block, one level deep.

The baseline cuts explanation, not facts. A reader who knows an area does
not hold its details in mind: restore the specific mechanisms and
invariants the target and the brief's own claims rely on, compactly and
linked, where they will be needed (a **refresher**). Surface the nuances
that decide how to read the seed and the brief: names that mislead,
conditions under which a claim flips, and which claims come from reading
code rather than a run.

- **Why before how.** Give the problem a mechanism solves and the
  constraint that shaped it before the mechanism itself, and its
  consequences after.
- **Anchor to the known.** Map a new concept to one the baseline holds,
  ideally from the reader's own field, and say where the analogy breaks.
- **Name the wrong model.** Where a tempting misconception exists (in the
  seed, in common writing, or suggested by a name), state it, show the
  evidence against it, then give the right model (refutation).
- **One name per concept.** Define each term where it first appears and keep
  that name; no synonyms afterwards. On later pages, link back to it. When a
  section introduces many new terms at once, split it (segmenting).
- **No skipped steps.** Each "so" follows from something already on the page
  (curse of knowledge). A long causal chain often reads best as a trace.
- **Real values.** Show mechanisms with real inputs and outputs: measured
  values, actual command output, the numbers from the source. When the reader
  must run a check, give one complete worked example with its real output.
- **Keep it together.** Put each explanation next to what it explains: the
  excerpt beside its claim, the label on the figure (spatial
  contiguity).
- **Cut decoration.** Each sentence, figure, and emphasis must change the
  reader's understanding (coherence).

## Communication

Write the brief by `$writing-for-humans`. Readers scan the headings and read
the body only under a heading that matters to them (the layer-cake
pattern), so the page should read correctly at both depths.

A brief does jobs: orient, refresh, explain, locate risk, point to sources,
record who said what. Give a job its own section, spread it across the
sections that need it, or put it inline, whichever puts it where the reader
needs it next.

## Page contract

- Open with the metadata and the bottom line: the claim the page proves, as
  briefly as it allows. Then the contents list.
- A section usually works as claim, evidence (an excerpt, trace, table, or
  figure), then the general rule.
- With the audit on, the seed verdicts come last, then the source list and
  the pager. Verdicts use the kit's kind tags: holds `ok`, partly `warn`,
  fixed at head `info`, wrong `bad`, unverified `muted`.
- State each result where it belongs. A brief does not quiz its reader, so it
  has no pre-questions, homework, or closing question list.

## Form

Set the pages by `$typesetting` and build them with its page kit.

## Output

Write the set to `${XDG_DATA_HOME:-$HOME/.local/share}/briefs/<YYYY-MM-DD>-<slug>/`:
`index.html`, `NN-<slug>.html` per page, `facts.md`, and the page kit's
files copied so the set stands alone.

Open the index in the default browser. Report the location, the bottom line,
the verdicts with wrong and partly first, what stays unverified, and what you
did not check.

To revise a set, edit it in place and verify the touched claims again.
