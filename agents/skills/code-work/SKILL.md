---
name: code-work
description: >-
  Use when designing or changing code or tests, reviewing or cleaning up a diff, or
  explaining how code works or why it has its current shape.
---

# Code Work

Owns code understanding, the coding loop, testing, reader order, locality, diff scope, program shape, names, imports, and code comments.

## Understanding

- How: for a nontrivial change, explicit explanation, or unclear flow or
  ownership, load `./references/how.md`. For change work, carry forward only
  constraints that affect the design.
- Why: for rationale, a strange or deliberate shape, or history that may constrain a change, load `./references/why.md`.

## Testing

For executable-code design or changes, verification decisions, or review of
tests and assertions, load [`references/testing.md`](references/testing.md)
before choosing implementation or test shape.

## Coding Loop

1. Scope: infer intent and design scope from the request and repository
   contracts. Apply Code Work within them. Preserve project behavior unless
   redesign is in scope.
2. System shape: for primitives, ownership, seams, phases, or composition,
   load `./references/systems-design.md` and
   `./references/mechanics.md`. Choose the semantic shape. Use Sketch when the
   shape remains unresolved.
3. Mechanical realization: check that shape against state ownership, data layout,
   movement, control flow, cost, concurrency, and nearby proof. Use code and tests
   to expose mismatches. Fixed-shape mechanical work may start here.
4. Code expression: make the chosen design legible through the shared rules below and
   `./references/rust-code-style.md` or `./references/zig-code-style.md` when
   active. For taste alignment or an expression choice these rules do not settle,
   load `./references/code-expression.md`.
5. Feedback:
   - Awkward composition or unclear ownership returns to System shape.
   - Hidden state, cost, or implementation strain returns to Mechanical realization.
   - Code friction returns to whichever shape it exposes as wrong.
6. Coherence: repeat until system shape, mechanical realization, and code expression
   agree on semantics and mechanics. Ownership, state, control flow, and cost
   must correspond.

Establish the semantic shape before implementation. Use authorized edits and tests
to refine it. Complete this loop before declaring the change ready.

## Sketch

When semantic shape remains unresolved, sketch caller usage, core data,
ownership, seams, key signatures, and control flow in commentary. Compare at
most two credible shapes and recommend one. Proceed on reversible engineering
choices. Ask when product values or irreversible contracts decide the fork.

## Experiments

When trying a code change or comparison is the cheapest way to choose, reject,
or refine a direction, apply `$experiment` and load
[`references/experiments.md`](references/experiments.md).

## Code Expression

- Reader order: lead with policy and minimal types; show the public story
  before machinery. Keep private helpers near the code they serve.
- Logical/physical: explain domain behavior first; then map it to state, movement, control, and cost. Keep the correspondence explicit.
- Local fit: follow established project vocabulary and idioms when the
  engineering choice is otherwise tied.
- Grouping: arrange code around relationships the reader must check.
  Use rows, columns, spacing, and parallel forms when they expose stages,
  correspondence, or differences.
- Density: keep a small choice at its use. Give substantial computation
  enough space and local scope to reveal its steps. Add intermediate names
  when they carry meaning or make the reasoning easier to check.
- Variety: let local judgment produce variety. Keep equivalent operations
  comparable; let different work take different shapes.
- Character: preserve useful character without manufacturing quirks.
  Stop when further changes merely exchange equally suitable forms.

## Behaviour Locality

- Ownership: keep behaviour and policy in the subsystem, phase, or caller that
  owns the decision.
- Special cases: keep ugliness near the phase that needs it.
- Sharing: prefer local duplication when reuse blurs ownership.

## Change Scope

- Tight diff: isolate semantic change from cleanup churn and avoid needless allocs. Scan nearby for the same pattern; report matches before expanding the diff.
- Fallout: after contract changes, scan callers, tests, docs, and change text.
- Internal migration: migrate callers and delete the old path in the same change. Retain compatibility only when an external contract requires it.

## Program Shape

- Caller story: prefer direct, procedural, data-oriented flow; keep policy, phase order, and main dataflow visible.
- Concrete shape: preserve user-named shapes unless asked to redesign them.
- Plain first: check correctness and easy perf wins before compressing med/large work; compress only while semantics stay clear.
- Proof ladder: names, visual symmetry, assertions, then types or helpers. Escalate when risk or ownership earns the weight.
- Deletion test: a helper, type, or layer earns its place through owned state,
  invariants, mechanics, a cheap proof boundary, or caller complexity that
  reappears when removed. Single-use is valid. Reuse adds evidence.
- Abstraction cost: remove layers that obscure owner, control, or cost. Traits, macros, and generation must keep hidden work, seam truth, and cost explicit.
- Defensive code: a guard or catch protects a trust boundary, implements an
  explicit failure contract, or handles an observed failure. Internal uncertainty
  puts pressure on the type or owner.
- Invariant confidence: once the owner proves a state impossible, make the code
  rely on that fact. Extra branches, containers, fallback drains, optionality,
  and recovery paths must represent a reachable state or trust boundary.
  Assertions can check that the invariant continues to hold. Internal doubt
  returns to the model or owner.
- Control flow: keep the successful path visible. Exit early for boundary failures.
- Type truth: parse and validate external values at the boundary. Keep internal types honest; do not weaken them to accommodate implementation friction.

## Names And Imports

- Scope: naming grows with scope. Use short local names when nearby context
  supplies the meaning; use descriptive names across wider scopes.
- Domain language: use source-of-truth terms and established abbreviations.
  Shorten only while distinctions survive.
- Honest names: names reveal waits, retries, allocation, fallback, normalization, and policy.
- Contract drift: treat naming changes that alter the model or hide behaviour as contract changes.
- New concepts: require a distinct meaning. Run names by the user.
- Names as proof: state units and index spaces. Use base-first qualifiers and
  symmetric duals when they expose bad expressions: `source`, `source_words`,
  `source_index`; `source` and `target`.
- Imports: prefer scoped local imports, then go-style imports. Use qualified paths
  when import blocks get noisy.

## Code Comments

- Contribution: let code state what it does. Comments earn space through
  reasoning, constraints, representation keys, useful mental pictures,
  or unresolved judgments the reader would otherwise reconstruct.
  Prefer a name, type, assertion, or structure when it carries that
  contribution more clearly.
- Weight: use the space the explanation needs. Explain where understanding
  first becomes necessary; let later parallel cases use that context.
- Voice: prefer terse, direct language. Preserve an apt phrase or candid
  note when it helps. State uncertainty as uncertainty.
- Placement: keep the explanation with the decision or representation
  it explains.
- Maintenance: when changing the relevant code, check that its comments
  still hold. Remove stale claims; preserve reasons that still constrain
  the change.
