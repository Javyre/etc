# Slices

A **slice** is one implementation step the user reviews: one or two jj
changes, not a PR. Slices exist so the user can keep up and stays
accountable for every line. Each slice limits the **surprise**: the
difference between what the user decided and what they find in the diff.
Lower end-to-end time and user effort is the goal; planning that costs more
than it saves is waste.

## Plan

Before implementing work that needs more than one reviewable step, say so
in one line and give the slice plan: one line per slice, with its kind, the
decisions it expresses (each with its gist), and what it may surprise with.
When a workfile exists, the plan goes in its Slices section.

## Kinds

- **Structural**: changes shape and leaves behavior unchanged.
- **Behavioral**: expresses one decision, or a few that are coupled.

Keep the two kinds in separate slices. Put a structural slice first when it
makes the behavioral slice small enough to audit. A refactor that changes
the design (the model, ownership, or an interface others build on) is a
decision to defend in its own right. A refactor confined to code expression
is not.

Scaffolding lands in use. A slice that adds code nothing calls yet makes a
later slice carry its proof. Merge two slices when splitting them costs more
scaffolding than the surprise it saves.

## Surprise budget

To decide whether something needs the user before code, ask whether their
whiteboard defense of the change would mention it: why this and not that,
where it fails, who relies on it.

- **Usually the agent decides, and the diff shows it:**
  - code expression, private abstractions, helpers, comments
  - mechanical consequences of a settled decision
- **Usually the user decides first, through a preview:**
  - anything other components, persisted data, users, or teammates
    observe or build on, including internal interfaces teammates will
    maintain
  - anything costly to reverse
  - anything that bends a settled decision

Judge by who relies on a thing and what changing it later would cost, not by
its syntax. A private enum variant is free. A variant serialized into a
receipt is not.

## Previews

Preview abstractions as Sketch in `SKILL.md` describes, with rough call sites
from the main caller stories, internal or external, at the rigor the stakes
need. When showing is cheaper than discussing, implement the slice and mark
the item **shown, not decided** at the top of its summary.

## Fallout change

Fallout (see `SKILL.md`) from a central change can force broad mechanical
edits to tests, callers, and fixtures. Keep the change the user audits in
one jj change, and put the fallout in a second change on top of it within
the same slice. Open the fallout change's description with one line per
meaningful edit: what changed and which decision it follows, with that
decision's gist. Group the purely mechanical edits.

To show the user a change in their editor, make it the working copy with
`jj edit <change>`. In a colocated repo, editors diff the working copy
against `@-`.

## End of a slice

A slice is done when:
- it builds and passes the checks agreed for the work
- its summary names what landed and each item that was shown, not decided

After a behavioral slice, pause for the user unless they asked you to carry
on.
