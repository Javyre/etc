---
name: code-work
description: >-
  Code work through system shape, mechanical realization, and source
  expression. Use for code design, implementation, refactoring, review, or
  code-style decisions.
---

# Code Work

Owns the coding loop, reader order, locality, diff scope, program shape, names, imports, and code comments.

## Coding Loop

1. Scope: infer intent and design scope from the request and repository contracts. Apply Code Work within them. Preserve project behavior unless redesign is in scope.
2. System shape: for primitives, ownership, seams, phases, composition, or taste alignment, load `./references/systems-design.md` and `./references/mechanics.md`. Choose the semantic shape.
3. Mechanical realization: pressure that shape through state, layout, movement, flow, cost, concurrency, and nearby proof. Fixed-shape mechanical work may start here.
4. Code shape: express the result through the shared rules below and `./references/rust-code-style.md` or `./references/zig-code-style.md` when active.
5. Feedback:
   - Awkward composition or unclear ownership returns to System shape.
   - Hidden state, cost, or implementation strain returns to Mechanical realization.
   - Code friction returns to whichever shape it exposes as wrong.
6. Coherence: repeat until system shape, mechanical realization, and code shape agree.

Every systems-design change completes this loop before application.

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

## Program Shape

- Caller story: prefer direct, procedural, data-oriented flow; keep policy, phase order, and main dataflow visible.
- Concrete shape: preserve user-named shapes unless asked to redesign them.
- Plain first: check correctness and easy perf wins before compressing med/large work; compress only while semantics stay clear.
- Proof ladder: names, visual symmetry, assertions, then types or helpers. Escalate when risk or ownership earns the weight.
- Deletion test: a helper, type, or layer earns its place through owned state, invariants, mechanics, a cheap proof boundary, or caller complexity that reappears when removed. Single-use is valid; reuse adds evidence.
- Abstraction cost: remove layers that obscure owner, control, or cost. Traits, macros, and generation must keep hidden work, seam truth, and cost explicit.

## Names And Imports

- Domain language: use source-of-truth terms; shorten only while real distinctions survive. Use obvious abbrevs like `tx`, `sigs`.
- Honest names: names reveal waits, retries, allocation, fallback, normalization, and policy.
- Contract drift: treat naming changes that alter the model or hide behaviour as contract changes.
- New concepts: require a real distinction; run names by the user.
- Names as proof: state units and index spaces; use base-first qualifiers and symmetric duals when they expose bad expressions (`source`, `source_words`, `source_index`; `source`/`target`).
- Imports: prefer scoped local imports, then go-style imports; use qualified paths when import blocks get noisy.

## Code Comments

- Voice: terse, blunt, low-grammar.
- Content: say the surprising bit; skip syntax narration.
- Placement: comment where cleanup could break correctness or cost.
