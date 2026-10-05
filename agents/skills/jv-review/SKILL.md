---
name: jv-review
description: >-
  Seam-first, proof-carrying review for Javyre standards. Use for review,
  review-driven fixes, or when another skill names it as its review engine.
---

# jv-review

Active instructions set bounds. This skill owns the review loop.

The **Governing skill** sets review standards. Use the one explicitly
designated. Otherwise load `$writing-for-agents` for skills, agent instructions,
and their linked reference documents, or `$code-work` for code and tests.

Default to `review` (`readonly`, audit, report), which inspects and reports and
leaves the workspace unchanged. Enter `fix` on any explicit edit request.

Flow:

- `review`: Scope, Study ⇄ Review, Report.
- `fix`: Scope, Study ⇄ Review, Fix, Report.

## Scope

The Governing skill defines the applicable review scopes. Named scopes are
required and additive unless the user says `only`. With no named scope, cover
all applicable scopes, correctness first.

The default scope vocabulary is:

- **Correctness.** Result, state transition, or failure behavior.
- **Design.** Ownership, lifecycle, seam shape, or abstraction.
- **Performance.** Time, memory, I/O, concurrency, scaling, or resource use.
- **Clarity.** Names, layout, comments, and code expression.
- **Verification.** Tests, evidence, callers, docs, or untested paths.
- **Security.** Trust, authority, validation, and exposure.
- **Operations.** Startup, shutdown, recovery, observability, and deployment.

Named scopes may require separate passes when they need different evidence.

Infer the local seam, owner, named responsibility, and environment contract.
Raise only ambiguity that changes the conclusion. Name blockers immediately.

## Study

Build an initial model of the scoped system, grounded in source. Continue Study
during Review as premises, seams, and evidence revise that model.

A **premise** is a fact or user-owned choice on which a review conclusion
depends.

Investigate unresolved premises using available context. Carry remaining
questions to Report as `q:`. Do not ask during the pass. Continue independent
work; report any coverage or fixes blocked by an unresolved premise.

1. **Intent.** Reconstruct the desired outcome, constraints, tradeoffs, and
   contract.
2. **Map.** Trace owners, callers, data, state, control, errors, and external
   effects.
3. **Mechanics.** Understand algorithms, invariants, lifecycle, concurrency,
   recovery, and degraded states.
4. **Performance.** Model time, space, allocs, I/O, locks, caching, buffering,
   and scaling where present.
5. **Security.** Map boundaries, authority, inputs, validation, secrets, and
   blast radius where present.

### Scouts

A **Scout** is a readonly Study worker for a bounded evidence question.

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

**Jurisdiction** is Review's authority, set by reconstructed intent. Accepted
limits remain constraints. Contract challenges the user requests enter scope.

Pre-existing behavior remains in scope when the diff changes its preconditions,
owner, lifecycle, or effect. Re-evaluate it before excluding it.

Use source, callers, tests, docs, change text, history, and primary refs as
needed. Work descriptively: what exists, how it works, why it exists. Reserve
findings, severity, fixes, and redesign for Review.

Study is sufficient to enter Review when you can trace the main path without
guessing. Return to Study whenever a finding depends on a new or disputed
premise. Establish the premise from evidence or make the conclusion conditional
on it.

## Review

Review locally. Split only clear sprawl into non-overlapping lenses; merge into
one report.

Apply this seam-first ladder in order:

1. **Seam.** Verify that ownership, phase, mutation, cost, failure, and valid
   states are honest.
2. **Contract.** Trace changed semantics, invariants, degraded states, and
   regression paths.
3. **Clarity.** Compare claimed reachable states with the types and control flow
   that express them. Find machinery whose only purpose is to tolerate an
   invariant the owner already proves.
4. **Misuse.** Find APIs that lie, weak names, hidden ordering, and caller
   caveats.
5. **Policy.** Locate retry, fallback, timeout, readiness, refresh, cache, and
   default ownership.
6. **Truth.** Find workarounds, local copies, hidden bookkeeping, prod/test
   splits, and derived state lacking an owner, invalidation rule, or rebuild
   path.
7. **Mechanics.** Check passes, allocs, buffering, branches, cache shape,
   indirection, and streaming.
8. **Proof.** Establish each material claim with mechanism, source, repro,
   counterexample, or cost model.
9. **Simplify.** Find fake concepts, structure built for hypothetical future
   needs, genericization that adds branches, stale lying text, dead weight, and
   diff noise.

Redesign only when the owning seam disproves the user's named shape.

Escalate one seam when a local falsehood exposes a hidden assumption:

```text
falsehood → assumption → callers/tests/siblings → owning seam
```

Stop at the first owner able to choose correctly. Watch for niche edge cases
that create global complexity. Report broader out-of-scope issues in one line.

Merge findings by cause. When several symptoms trace to one owner or design
pressure, report one finding: the cause, the symptoms it explains, and one
remedy that resolves them together. Keep a symptom separate only when its fix is
independent. When remedies constrain each other, such as names in one
vocabulary, a set of primitives, or a type split, propose them as one design the
reader can judge whole.

Consider every candidate and scout disagreement before Review ends, then give
each one a disposition: confirmed finding, exclusion grounded in source, or
`q:`. Confirmed findings are bounded and carry proof; an exact source anchor may
suffice. A `q:` names the mechanism the evidence shows and its consequence. An
exclusion names the evidence, contract, or authority that resolves or excludes
the concern.

Review completes when the resulting report covers every applicable and requested
scope, every candidate has a disposition, and every material claim has evidence
or a named proof gap. Unresolved premises may remain in `q:` items. The report
must name blocked scopes and proof gaps.

## Report

Before writing the report, load `$writing-for-humans`; the report follows it.

Start with the **System model**, the compact result of Study that the reader
needs to understand the findings. Shape it to the system. Show material
ownership, flow, invariants, mechanics, performance, security, and uncertainty;
omit irrelevant lenses. Prefer a small visual and exact source anchors.

When scouts materially shaped Study, name their coverage and unresolved
disagreement in one compact line.

Follow with finding 1. Order findings by impact, then confidence.

Treat a semantic lie as a blocker when it invalidates caller reasoning,
safety, or the claimed performance model.

Report every confirmed in-scope finding and admitted `q:`, including minor
findings, merged by cause, with the affected locations. The top three findings
may use up to 30 lines each. Later findings use up to six. These limits govern
presentation, not review coverage or finding count.

Prefix each finding with its primary scope. Put the prefix before the source
location, as in `correctness: ./path:line`.

Confirmed finding anatomy:

```md
1. correctness: `./path:line`: <claim>. <impact>. <fix>.
   prob: <current conceptual and concrete shape>
   soln: <suggested conceptual and concrete shape>
   proof: <evidence>
```

Show the conceptual change and the concrete before/after. One representation may
carry both; separate them when each adds distinct information. Allocate space by
explanatory value; expand the most important parts of the top three.

For a conditional finding, use `q:`. Keep the conclusion and any suggested fix
conditional on the unresolved premise:

```md
q: <question that resolves the premise>
   observed: <mechanism and source anchor>
   if <answer>: <consequence and suggested change>
   otherwise: <how the conclusion changes>
```

Keep the summary and residual risk brief, and put them after the findings.
Residual risk means a credible failure left by an untested path, uncertain
assumption, environment gap, or out-of-scope dependency. If there are no
findings, say so and name material proof gaps.

## Fix

Complete Review before applying fixes. Apply confirmed findings in impact order
under the Governing skill. Preserve review scope. Prove each changed contract
with the narrowest decisive checks.

Resolve a `q:` premise before applying its dependent fix. Continue independent
fixes while the premise remains unresolved.

Fix completes when every confirmed finding is `applied` or blocked by a named
dependency, missing authority, or user decision, and the resulting change meets
Review's completion criterion.

## Done

Meet Review's completion criterion and Report's requirements. In `fix` mode,
also meet Fix's completion criterion. Account for contract fallout.
In `review` mode, verify that the workspace is unchanged.
