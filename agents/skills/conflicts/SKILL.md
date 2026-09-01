---
name: conflicts
description: Resolve conflicts after the user manually rebases a JJ stack.
disable-model-invocation: true
---

# Conflicts

The user already performed the rebase. Do not rebase.

## Recover

Start with `jj op log`. Find the rebase operation and the operation immediately
before it. Inspect both states with `jj --at-op`.

Match changes by change ID and recover:

- the original parent and tip
- the new parent and rebased stack
- the current resolution change

Pin old commit IDs when exact tree comparison may help. If the operation is
unclear, inspect its diff, bookmarks, and change evolution before editing. Trace
moved or deleted code before concluding that its local intent became obsolete.

## Resolve

The target is:

```text
original parent + original delta
≈
new parent + translated delta
```

The original delta owns its intent and WIP boundary. The new base owns mechanics
that changed under it. Neither conflict side wins wholesale.

Keep all resolution edits in a top audit change:

```text
@  resolution
×  rebased stack
◆  new parent
```

Create that change if absent. Do not edit, squash, rebase, or describe changes
below it.

Inspect silent auto-merge fallout and affected paths, not only conflict markers.
Preserve deliberate omissions, unfinished work, and local code shape where the
new base does not force a change.

## Decision boundary

Apply mechanical translations when meaning and deliberate code shape stay the
same.

Before applying a translation, raise it for user judgment when it:

- changes behavior, invariants, ownership, persistence, or an API contract
- has more than one credible semantic mapping
- adds, removes, or restores an abstraction
- changes deliberate control flow, helper boundaries, caller layout, item order,
  naming model, or other visual code shape

Show:

```text
original shape
→ new-base constraint
→ proposed resolved shape
```

Explain why the translation is needed, give credible choices, and recommend one.
Continue independent work while the affected translation waits for a decision.

## Review and prove

Compare:

```text
before: original parent → original tip
after:  new parent      → resolved head
audit:  resolution change alone
```

Check that the resolved head is conflict-free, lower changes did not evolve,
and every lost or added semantic difference has an explanation. Review the
audit diff for accidental cleanup, invention, and style drift. Inspect the final
graph for artifacts and apply the normal code proof.

Report inferred intent, nontrivial translations, preserved WIP, approved shape
changes, unresolved forks, and proof gaps. End with brief highlights of what
changed and exact `./path:line` locations worth manual review. Rank nontrivial
translations and shape changes first. Omit mechanical edits unless they carry
risk. Do not absorb the audit change.
