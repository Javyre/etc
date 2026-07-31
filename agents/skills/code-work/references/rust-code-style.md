# Rust Code Style Guide

Owns Rust-specific code-style deltas.

Goal: mechanically honest Rust with the least language machinery.

## Posture

- Mechanical truth: correctness, phase truth, ownership, and cost shape outrank boring Rust.
- Boring default: prefer concrete types, funcs, enums, loops, and explicit ownership.
- Earned ugliness: accept local friction when tidier Rust adds clones, allocs, indirection, hidden phases, or weaker proof.
- Local fit: follow project convention on real ties; surface a simpler closed path when divergence has meaningful impact.

## Ownership And Variation

- Borrow pressure: reshape scopes, ownership, and data first. Treat cloning, `Arc`, boxing, dyn dispatch, interior mutability, and `unsafe` as explicit design costs. `unsafe` is the last resort.
- Closed variation: prefer enums, concrete funcs, and composition. Traits earn open variation, ecosystem interop, or a durable seam. `dyn` earns genuine runtime heterogeneity.
- Earned types: use newtypes for identity, units, validated state, and meaningful phases. Keep incidental relations in plain values with local proof.
- Scope: use blocks and early exits to shorten borrows and invalid-state lifetimes.
- Traversal mutation: prefer explicit indexes, work queues, or `retain` when mutation interacts with iteration.

## Failure

- Recovery demand: return `Result` when callers need branchable failure now or reasonably soon.
- Recovery scope: panic, `.unwrap()`, or `.expect()` may be honest when recovery is deliberately outside the program or component scope.
- Preconditions: assertions may enforce internal invariants and documented programmer obligations.
- Debug proof: use `debug_assert!` for dispensable checking cost; never make soundness depend on it.
- Translation: preserve source errors unless domain translation improves control flow or diagnostics.
- Convention: follow neighbouring error style when the semantic choice is tied.

## Representation And Codegen

- Narrow ints: use for representation fidelity; widen ordinary arithmetic when it improves safety or codegen.
- Sentinel state: encode meaningful nullability with types such as `Option<NonZeroU32>`; verify layout when layout is the reason.
- Iteration: use direct loops when iterator chains obscure mutation, allocation, or hot-loop shape.
- Unsafe proof: keep the unsafe region narrow and state its exact validity, aliasing, lifetime, and concurrency obligations.
