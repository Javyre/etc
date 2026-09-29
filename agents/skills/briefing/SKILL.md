---
name: briefing
description: >-
  Briefs that bring a reader to judge a target: a report, article, spec,
  PR, codebase area, or question. Use when asked to brief me, to walk
  through a topic from scratch, to study a document, or to prepare to
  review a PR. Writes linear local HTML pages.
---

# Briefing

Goal: after one linear read, the reader can judge the target on their own.
They can explain its mechanisms, reach the primary source of any claim in one
click, and see where the seed is wrong or stale.

The **seed** (report, PR, URL, spec, question) names the target. It does not
define the content: teach what the reader needs to judge it, from the
mechanism up, and treat each seed claim as a hypothesis to test.

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

- **Framed.** The index states the **frame**: 1 to 5 decision questions, the
  assumed reader baseline, the pins, and the scale and audit setting. The
  baseline comes from the loaded instructions (global and project
  `AGENTS.md`/`CLAUDE.md`), project context documents, and memory; it sets
  what pages skip, the vocabulary, the prose style, and which code is the
  reader's own. When the seed is pinned older than the repository head, the
  index lists the later commits that touch its claims, and claims are judged
  against head.
- **Mapped.** Every decision question and seed claim maps to the pages that
  answer it (a table on the index), and every page serves a question or a
  later page. Pages follow concept dependency: none needs a later page.
- **Sourced.** Every claim traces to a primary source at a pinned revision,
  preferring live system state, then code, then specifications, then official
  documentation, then secondary writing. Where sources disagree, the higher
  one wins and the page says so. Quotes are the source's own text, from the
  file or page itself rather than a tool's summary of it: 3 to 15 lines, with
  the decisive part marked. Fact and inference are marked apart.
- **Linked.** Every reference links to its exact target: code line
  permalinks, specification sections, documentation pages, registry or
  on-chain objects. Identifiers in prose (specification numbers, `path:line`,
  API names, commits, versions) count as references, across the whole set.
  Links point at pushed revisions, or at `file://` with a note when the code
  is local.
- **Consistent.** `facts.md` in the set holds every number, version, date,
  and claim used on more than one page, each with its source. Writers work
  from it and the frame; a correction lands in `facts.md` first, then
  in every page.
- **Judged.** With the audit on, each seed claim has a verdict (holds,
  partly, fixed at head, wrong, unverified) with one line of evidence, on the
  pages it touches.
- **Refuted first.** Every claim survived an attempt to disprove it against
  its source before delivery.

## Teaching

Aids that help novices slow experts down (**expertise reversal**). Size
every aid below to the baseline: cut what the baseline surely covers, and
collapse what it may cover into a "Background" block, one level deep.

- **Why before how.** After a section's claim, give the problem the mechanism
  solves and the constraint that shaped it, then the mechanism, then its
  consequences.
- **Anchor to the known.** Map a new concept to one the baseline holds,
  ideally from the reader's own field, and say where the analogy breaks.
- **Name the wrong model.** Where a tempting misconception exists (in the
  seed, in common writing, or suggested by a name), state it, show the
  evidence against it, then give the right model (**refutation**).
- **One name per concept.** Define each term where it first appears and keep
  that name; no synonyms afterwards. On later pages, link back to it. A
  section that needs more than a few new terms is two sections
  (**segmenting**).
- **No skipped steps.** Each "so" follows from something already on the page
  (**curse of knowledge**). Write a causal chain of three or more links as a
  trace.
- **Real values.** Show mechanisms with real inputs and outputs: measured
  values, actual command output, the numbers from the source. When the reader
  must run a check, give one complete **worked example** with its real output.
- **Keep it together.** Put each explanation next to what it explains: the
  excerpt beside its claim, the label on the figure (**spatial
  contiguity**).
- **Predict, then show.** At the one or two least intuitive results on a
  page, ask the question first and answer it right after, so the reader
  commits to a guess (**pre-questions**).
- **Cut decoration.** Each sentence, figure, and emphasis must change the
  reader's understanding (**coherence**).

## Page contract

- Open with the bottom line: the claim the page proves, in two to four
  sentences. Then the "Needs" line and the contents list.
- Build each section as claim, then one real artifact (excerpt, trace,
  table, figure), then the general rule.
- Put skippable asides in side notes.
- Draw a figure only for a relation that prose hides: a layout, a window, a
  state machine, an order. Label it on the figure; do not restate it in
  prose. Use pseudo stack traces for control flow and before/after pairs for
  changes.
- With the audit on, end with the seed callout, then the source list and the
  pager.
- The decision questions open the set and the verdicts close it; add no
  quiz, homework, or closing question list.

## Output

Write the set to `${XDG_DATA_HOME:-$HOME/.local/share}/briefs/<YYYY-MM-DD>-<slug>/`:
`index.html`, `NN-<slug>.html` per page, `facts.md`, and the kit files
`brief.css`, `brief.js`, and `brief-tune.js` from [`assets/`](assets/),
copied so the set stands alone. Start pages from `assets/template.html` and
the index from `assets/index.html`; `assets/components.html` shows every
block, and its source is the markup to copy. The kit handles layout, themes,
code highlighting, navigation, and reader settings.

Color carries meaning, through kit classes and tokens. The kinds are
`accent`, `neutral`, `ok`, `warn`, and `bad`; a figure paints areas with
`--fill-KIND` and the text on them with `--label-KIND`. Verdict tags: holds
`.ok`, partly `.warn`, fixed at head `.info`, wrong `.bad`, unverified
`.muted`.

Open the index in the default browser. Report the location, the bottom line,
the verdicts with wrong and partly first, what stays unverified, and what you
did not check.

To revise a set, edit it in place and verify the touched claims again.
