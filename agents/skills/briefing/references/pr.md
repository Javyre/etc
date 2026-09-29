# PR briefs

The reader will review the change. After the brief, they can:

- say what the change does and why, and what they expected it to look like;
- recall the invariants it touches without opening the code;
- tell the risky parts from the routine ones, and know what to read first;
- ask the questions most worth asking of this change;
- see which earlier review threads still stand.

Link every file at the base or head revision.

## Functions

A PR brief usually does the jobs below. Shape them to the change: a job can
take a section, spread across several, fold into another, or shrink to
nothing when the change does not need it.

- **Why.** The problem, its cause and impact, and why now, from the
  description, linked issues, and history. When the author gives no reason,
  say so rather than invent one.
- **Refresh.** The unchanged code, invariants, APIs, and callers the change
  and this brief rely on, as they stand at base, linked. Place it where it
  best restores recall, often next to the change that depends on it. Note
  where a nuance decides how to read the diff, the description, or this
  brief.
- **Expected solution.** What a reviewer would expect the fix to look like,
  and the alternatives the author dropped or did not mention, so the reader
  can compare the diff with it.
- **Shape.** The logical groups of the change and their sizes (the kit's `+`
  and `−` columns), anything unrelated mixed in, and the generated or large
  files you did not read.
- **The change.** What each risky group does at head, measured against the
  refreshed invariants, and its consequences.
- **Reading tour.** An order to read the diff in, with the reason for it.
  An entry point such as a test, the core before what depends on it, and
  the riskiest part early usually serve well.
- **Questions for this change.** Specific ones, never a generic checklist:
  completeness, consistency with nearby code, risk to other components,
  interactions far apart in the code, whether each part is needed, whether
  the tests cover the risk.
- **Review ledger.** When the PR has earlier discussion: each thread, its
  status at head, the evidence, and the author's stated intent. Other parts
  of the brief may link to it.
- **Unknowns.** What the brief could not establish.

With the seed audit on, the PR description is the seed: each of its claims
gets a verdict against the diff. Check especially for changes the
description claims but the diff does not make.

## Out of scope

The brief prepares the review; it does not perform it. State no approval and
no overall verdict on the change.
