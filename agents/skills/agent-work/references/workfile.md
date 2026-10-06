# Workfile

Audience: the user and every agent session on one workstream.

Purpose: one small, current record of what the user decided, what is still
open, and where the work stands, so a session can end anytime and the next
one resumes without the user repeating themselves.

## Location and lifecycle

- Live at `.agents/work/<slug>.md` in the nearest `.agents/` at or above the
  work, such as a monorepo subroot's `.agents/`. Ask once when
  two `.agents/` directories compete.
- Create one only when the user asks, or when they start multi-session work
  and agree to one. Announce it in one line, with the path, the moment you
  create it.
- When the work ships or the user drops it, move the file to
  `.agents/work/archive/<YYYY-MM-DD>-<slug>.md` and leave it unchanged. The
  archive is history to search, not context to load.

## Shape

```text
# <slug>: <goal in one line>
Out of scope: …

## Decisions
D1 settled 10-05  Retries stop once the order fills. "once it fills we're
                  done, no more retries" (session 1a2b3c4d, 10-05 16:55)
D2 leaning 10-05  Cancel the paired order when retries start. "I think …"
D3 open           where the cancellation is reported
D4 proposed       report it on the record of the operation that caused it
D5 rejected 10-05 a top-level field for the cancelled order

## Slices
S1 behavioral D1 (stop on fill), D2 (cancel pair)  done: <change>
S2 behavioral D4 (report on cause)                 waits on D3

## Now
<five lines at most: state, blockers, next action>
```

## Rules

- **Index, not store.** Each decision is one line plus a pointer to its detail
  in code, a PR, a brief, or a session. Slices and Now follow the same rule.
- **The user's confidence sets the state.** `settled` means they said it
  plainly or confirmed it. `leaning` keeps their hedge in their words; work
  may build on it, and says so. `open` is a fork. `proposed` is an agent's
  suggestion. `rejected` stays, so nobody proposes it again. Only the user's
  explicit word changes a state.
- **Fidelity.** A decision carries a fragment of the user's words and where
  they said it. Paraphrase loses the hedges.
- **Settling.** When the user settles an open item, change its state in place
  and add their words. When they adopt a proposal, fold it into the decision
  it answers and delete the proposal line. A proposal they turn down becomes
  `rejected`.
- **Supersede, don't rewrite.** When the user changes a settled decision, add
  a new line and shrink the old one to `Dn superseded by Dm`. Slices and Now
  are rewritten in place, with finished slices pruned to one line.
- **Self-describing references.** Wherever you cite a `Dn` or `Sn`, in the
  file or outside it, add its gist: "D1 (stop on fill)", not "D1".
- **Cross-references.** Point to another workfile only where it changes a
  decision in this one.
- **Truth check.** Read the file as claims. Check what your next action
  depends on against code and live state, and fix stale lines.

Complete when every decision made since the last write has a line in its
true state, and Now reflects the current work.
