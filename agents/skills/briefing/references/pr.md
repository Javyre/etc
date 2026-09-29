# PR briefs

The reader will review the change. The brief gives them the context a
reviewer needs before they read the diff, a reading order, and the questions
most worth asking of this change.

Link every file at the base or head revision.

## Contents, in order

1. **Why.** The problem, what caused it, its impact, and why now. Take it
   from the description, linked issues, and history. When the author gives
   no reason, say so; do not invent one.
2. **Expected solution.** What a reviewer would expect the fix to look like,
   and the alternatives the author dropped or did not mention. The reviewer
   compares the diff against this.
3. **Shape.** Base and head, the logical groups of the change, their sizes,
   and anything unrelated mixed in. Name generated or large files you did not
   read.
4. **Context the diff relies on.** The unchanged code, invariants, APIs, and
   callers the change depends on, as pinned `path:line` links with short
   excerpts.
5. **Reading tour.** The groups in order: one test or usage example as the
   entry point, then the core, then what depends on it, then low-risk
   material. Keep related parts together and put declarations before their
   use. Put the riskiest part early. State the ordering rule you used.
6. **Questions for this change.** Specific ones: completeness, consistency
   with nearby code, risk to other components, interactions far apart in the
   code, whether each part is needed, and whether the tests cover the risk.
   Leave out generic checklists.
7. **Unknowns.** What the brief could not establish.

With the seed audit on, the PR description is the seed: each of its claims
gets a verdict against the diff. Check especially for changes the
description claims but the diff does not make.

## Out of scope

The brief prepares the review; it does not perform it. State no approval and
no overall verdict on the change.
