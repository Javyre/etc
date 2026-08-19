---
name: code-work
description: >-
  Use when designing or changing code, reviewing or cleaning up a diff, or
  explaining how code works or why it has its current shape.
---

# Code Work

Owns code understanding, the coding loop, reader order, locality, diff scope, program shape, names, imports, and code comments.

## Understanding

- How: for a nontrivial change, explicit explanation, or unclear flow or ownership, load `./references/how.md`. For change work, carry forward only constraints that affect the design.
- Why: for rationale, a strange or deliberate shape, or history that may constrain a change, load `./references/why.md`.

## Coding Loop

1. Scope: infer intent and design scope from the request and repository contracts. Apply Code Work within them. Preserve project behavior unless redesign is in scope.
2. System shape: for primitives, ownership, seams, phases, composition, or taste alignment, load `./references/systems-design.md` and `./references/mechanics.md`. Choose the semantic shape. Use Sketch when the shape remains unresolved.
3. Mechanical realization: pressure that shape through state, layout, movement, flow, cost, concurrency, and nearby proof. Fixed-shape mechanical work may start here.
4. Code shape: express the result through the shared rules below and `./references/rust-code-style.md` or `./references/zig-code-style.md` when active.
5. Feedback:
   - Awkward composition or unclear ownership returns to System shape.
   - Hidden state, cost, or implementation strain returns to Mechanical realization.
   - Code friction returns to whichever shape it exposes as wrong.
6. Coherence: repeat until system shape, mechanical realization, and code shape agree.

Every systems-design change completes this loop before application.

## Sketch

When semantic shape remains unresolved, sketch caller usage, core data,
ownership, seams, key signatures, and control flow in commentary. Compare at
most two credible shapes and recommend one. Proceed on reversible engineering
choices. Ask when product values or irreversible contracts decide the fork.

## Reader Order

- Lead with policy and minimal types; show the public story before machinery.
- Logical/physical: explain domain behavior first; then map it to state, movement, control, and cost. Keep the correspondence explicit.

## Behaviour Locality

- Ownership: keep behaviour and policy in the real subsystem, phase, or caller.
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
- Deletion test: a helper, type, or layer earns its place through owned state, invariants, mechanics, a cheap proof boundary, or caller complexity that reappears when removed. Single-use is valid; reuse adds evidence.
- Abstraction cost: remove layers that obscure owner, control, or cost. Traits, macros, and generation must keep hidden work, seam truth, and cost explicit.
- Defensive code: a guard or catch protects a trust boundary, implements an explicit failure contract, or handles an observed failure. Internal uncertainty pressures the type or owner.
- Control flow: keep the successful path visible. Exit early for boundary failures.
- Type truth: parse and validate external values at the boundary. Keep internal types honest; do not weaken them to accommodate implementation friction.

## Names And Imports

- Domain language: use source-of-truth terms; shorten only while real distinctions survive. Use obvious abbrevs like `tx`, `sigs`.
- Honest names: names reveal waits, retries, allocation, fallback, normalization, and policy.
- Contract drift: treat naming changes that alter the model or hide behaviour as contract changes.
- New concepts: require a real distinction; run names by the user.
- Names as proof: state units and index spaces; use base-first qualifiers and symmetric duals when they expose bad expressions (`source`, `source_words`, `source_index`; `source`/`target`).
- Imports: prefer scoped local imports, then go-style imports; use qualified paths when import blocks get noisy.

## Code Comments

- Voice: terse, blunt, low-grammar.
- Default: let code state what it does.
- Content: comment only a surprising external cause, invariant, or hidden cost. Try a better name, type, assertion, or structure first.
- Placement: comment where cleanup could break correctness or cost.
