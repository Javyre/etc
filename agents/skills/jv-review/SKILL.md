---
name: jv-review
description: >-
  Seam-first, proof-carrying review for Javyre standards. Use for review,
  review-driven fixes, or when another skill names it as its review engine.
---

# jv-review

Active instructions set bounds. This skill owns the review loop.

**Governing skill** — the one skill explicitly named as review law.

```text
review law = active instructions + Governing skill
```

`$code-work` governs when unnamed. Apply `$writing-artifacts` to the report.

Default to `review` (`readonly`, audit, report): inspect and report; workspace unchanged. Enter `fix` on any explicit edit request.

Flow:

- `review`: Scope, Study ⇄ Review, Report.
- `fix`: Scope, Study ⇄ Review, Fix, Report.

Infer scope silently: touched seam, owner, named responsibility, and env/CLI contract. Surface only ambiguity that changes the conclusion. Name blockers immediately.

## Study

Build an initial source-backed model of the scoped system. Continue Study during Review as premises, seams, and evidence revise that model.

**Premise** — a fact or user-owned choice on which a review conclusion depends.

Investigate unresolved premises using available context. Carry remaining
questions to Report as `q:`. Do not ask during the pass. Continue independent
work; report any coverage or fixes blocked by an unresolved premise.

1. **Intent** — reconstruct desired outcome, constraints, tradeoffs, and contract.
2. **Map** — trace owners, callers, data, state, control, errors, and external effects.
3. **Mechanics** — understand algorithms, invariants, lifecycle, concurrency, recovery, and degraded states.
4. **Cost** — model time, space, allocs, I/O, locks, caching, buffering, and scaling where present.
5. **Trust** — map boundaries, authority, inputs, validation, secrets, and blast radius where present.

### Scouts

**Scout** — readonly Study worker for a bounded evidence question.

```text
bounded + independent + verifiable → Scout
coupled path or shared judgment     → root Study
```

Dispatch scouts when parallel reading saves root context without fragmenting the
main model. Give each a neutral question, exact scope, and required source
anchors; omit candidate conclusions.

Scouts return observed shape, evidence, uncertainty, and unresolved seams.
The root verifies material evidence, resolves disagreement, tracks premises, and
integrates one System model. Scout work counts as Study only after integration.

**Follow the behavior.** When ownership moves, trace the old cases through the
new path. Verify their final result and state which cases remain unproven.

**Jurisdiction** — reconstructed intent sets Review's authority. Accepted limits remain constraints; user-requested contract challenges enter scope.

Pre-existing behavior remains in scope when the diff changes its preconditions,
owner, lifecycle, or effect. Re-evaluate it before exclusion.

Use source, callers, tests, docs, change text, history, and primary refs as needed. Work descriptively: what exists, how it works, why it exists. Reserve findings, severity, fixes, and redesign for Review.

Study is sufficient to enter Review when the main path can be traced without
guessing. Return whenever a finding depends on a new or disputed premise.
Establish the premise from evidence or make the conclusion conditional on it.

## Review

Review locally. Split only clear sprawl into non-overlapping lenses; merge into one report.

Apply this seam-first ladder in order:

1. **Seam** — verify ownership, phase, mutation, cost, failure, and valid states are honest.
2. **Contract** — trace changed semantics, invariants, degraded states, and regression paths.
3. **Clarity** — compare claimed reachable states with the types and control flow
   that express them. Find machinery whose only purpose is to tolerate an
   invariant the owner already proves.
4. **Misuse** — find liar APIs, weak names, hidden ordering, and caller caveats.
5. **Policy** — locate retry, fallback, timeout, readiness, refresh, cache, and default ownership.
6. **Truth** — find workarounds, local copies, hidden bookkeeping, prod/test splits, and derived state lacking an owner, invalidation rule, or rebuild path.
7. **Mechanics** — check passes, allocs, buffering, branches, cache shape, indirection, and streaming.
8. **Proof** — establish each material claim with mechanism, source, repro, counterexample, or cost model.
9. **Simplify** — find fake concepts, future-shaped scaffolds, branchy genericization, stale lying text, dead weight, and diff noise.

Redesign only when the owning seam disproves the user's named shape.

Escalate one seam when a local falsehood exposes a hidden assumption:

```text
falsehood → assumption → callers/tests/siblings → owning seam
```

Stop at the first owner able to choose correctly. Watch for niche edge cases creating global complexity. Report broader out-of-scope issues in one line.

Admit confirmed findings only with validated evidence; an exact source anchor
may suffice. A `q:` requires an evidenced mechanism and a specific consequence
under its unresolved premise.

Before leaving Review, give every candidate and scout disagreement one
disposition: confirmed finding, source-backed exclusion, or `q:`. An exclusion
names the evidence, contract, or explicit authority that resolves or excludes
the concern.

Review completes when every scoped change and affected contract is accounted
for, every applicable ladder item has been checked across the scoped seams,
and every candidate has a disposition. Confirmed findings must be validated,
proof-carrying, and bounded. Unresolved premises may remain in `q:` items.

Finding count and severity do not end the pass. If coverage remains incomplete,
name what remains unchecked and why.

## Report

Start with **System model**: the compact result of Study needed to understand the findings. Shape it to the system. Show material ownership, flow, invariants, mechanics, cost, trust, and uncertainty; omit irrelevant lenses. Prefer a small visual and exact source anchors.

When scouts materially shaped Study, name their coverage and unresolved
disagreement in one compact line.

Follow with finding 1. Order findings by impact, then confidence.

Treat a semantic lie as blocker-class when it invalidates caller reasoning, safety, or the claimed cost model.

Report every confirmed in-scope finding and admitted `q:`, including minor
findings. Group repeated instances under their shared cause and identify the
affected locations.
Top three findings may use up to 30 lines each. Later findings use up to six.
These limits govern presentation, not review coverage or finding count.

Confirmed finding anatomy:

```md
1. `./path:line`: <claim>. <impact>. <fix>.
   prob: <current conceptual and concrete shape>
   soln: <suggested conceptual and concrete shape>
   proof: <evidence>
```

Show the conceptual change and concrete before/after. One representation may carry
both; separate them when each adds distinct information. Allocate space by
explanatory value; expand the most important parts of the top three.

Use `q:` for a conditional finding. State the unresolved premise, observed
mechanism, and how the answer changes the conclusion. Attach source evidence
and make any suggested fix conditional on that answer.

```md
q: <question that resolves the premise>
   observed: <mechanism and source anchor>
   if <answer>: <consequence and suggested change>
   otherwise: <how the conclusion changes>
```

Keep summary and residual risk brief and after findings. Residual risk means a credible failure left by an untested path, uncertain assumption, environment gap, or out-of-scope dependency. If there are no findings, say so and name material proof gaps.

## Fix

Complete Review before applying fixes. Apply confirmed findings in impact order
under the Governing skill. Preserve review scope. Prove each changed contract
with the narrowest decisive checks.

Resolve a `q:` premise before applying its dependent fix. Continue independent
fixes while the premise remains unresolved.

Rereview each changed seam and its affected contracts using Review's completion
criterion. Continue until every confirmed finding is `applied` or blocked by
a named dependency, missing authority, or user decision.

## Done

Review's completion criterion must be met in both modes. In `fix` mode, every
confirmed finding must also have a fix disposition.

Finish when the report exposes the source-backed System model; reported
findings meet Report's evidence and presentation rules; contract fallout is
accounted for; residual risk is named when present; and `review` mode left the
workspace unchanged.
