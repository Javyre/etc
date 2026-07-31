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

Build an initial source-backed model of the scoped system. Continue Study during Review as forks, seams, and evidence revise that model.

**Fork** — unresolved, user-owned choice whose answers materially change review scope, contract, or conclusion.

**Doubt** — uncertainty that can remain explicit without invalidating the review.

```text
evidence resolves uncertainty confidently → continue Study
Doubt remains                          → mark `q:`, bound claims, continue
Fork remains after available evidence → stop and ask immediately
```

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
The root verifies material evidence, resolves disagreement, owns Forks, and
integrates one System model. Scout work counts as Study only after integration.

**Jurisdiction** — reconstructed intent sets Review's authority. Accepted limits remain constraints; user-requested contract challenges enter scope.

Use source, callers, tests, docs, change text, history, and primary refs as needed. Work descriptively: what exists, how it works, why it exists. Reserve findings, severity, fixes, and redesign for Review.

Study is sufficient to enter Review when the main path can be traced without guessing. Return whenever a finding depends on a new or disputed premise. Resolve it through evidence, Doubt, or Fork.

## Review

Review locally. Split only clear sprawl into non-overlapping lenses; merge into one report.

Apply this seam-first ladder in order:

1. **Seam** — verify ownership, phase, mutation, cost, failure, and valid states are honest.
2. **Contract** — trace changed semantics, invariants, degraded states, and regression paths.
3. **Misuse** — find liar APIs, weak names, hidden ordering, and caller caveats.
4. **Policy** — locate retry, fallback, timeout, readiness, refresh, cache, and default ownership.
5. **Truth** — find workarounds, local copies, hidden bookkeeping, prod/test splits, and derived state lacking an owner, invalidation rule, or rebuild path.
6. **Mechanics** — check passes, allocs, buffering, branches, cache shape, indirection, and streaming.
7. **Proof** — establish each material claim with mechanism, source, repro, counterexample, or cost model.
8. **Simplify** — find fake concepts, future-shaped scaffolds, branchy genericization, stale lying text, dead weight, and diff noise.

Redesign only when the owning seam disproves the user's named shape.

Escalate one seam when a local falsehood exposes a hidden assumption:

```text
falsehood → assumption → callers/tests/siblings → owning seam
```

Stop at the first owner able to choose correctly. Watch for niche edge cases creating global complexity. Report broader out-of-scope issues in one line.

Admit only validated, proof-carrying findings; an exact source anchor may suffice.

Review completes when the ladder has been applied to every material seam and every resulting finding is validated, proof-carrying, and bounded.

## Report

Start with **System model**: the compact result of Study needed to understand the findings. Shape it to the system. Show material ownership, flow, invariants, mechanics, cost, trust, and uncertainty; omit irrelevant lenses. Prefer a small visual and exact source anchors.

When scouts materially shaped Study, name their coverage and unresolved
disagreement in one compact line.

Follow with finding 1. Order findings by impact, then confidence.

Treat a semantic lie as blocker-class when it invalidates caller reasoning, safety, or the claimed cost model.

Top three findings may use up to 30 lines each. Later findings use up to six.

Required finding anatomy:

```md
1. `./path:line`: <claim>. <impact>. <fix>.
   visual prob: <current conceptual shape>
   visual soln: <suggested conceptual shape>
   snippet prob: <current concrete shape>
   snippet soln: <suggested concrete shape>
   proof: <evidence>
```

Use both visual and snippet. Allocate space by explanatory value; expand the most important parts of the top three.

Use `q:` for Doubt. Keep the visual and snippet attached so the bounded claim stays legible.

Keep summary and residual risk brief and after findings. Residual risk means a credible failure left by an untested path, uncertain assumption, environment gap, or out-of-scope dependency. If there are no findings, say so and name material proof gaps.

## Fix

Apply confirmed findings in impact order under the Governing skill. Preserve review scope. Prove each changed contract with the narrowest decisive checks.

Rereview each changed seam. Label implemented findings `applied`.

## Done

Finish when no Fork remains unresolved; the report exposes the source-backed System model; every reported finding is impact-ordered, proof-carrying, owner-local, visual, snippet-backed, and bounded; contract fallout is accounted for; residual risk is named when present; and `review` mode left the workspace unchanged.
