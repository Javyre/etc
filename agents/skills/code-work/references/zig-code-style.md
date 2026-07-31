# Zig Code Style Guide

Owns Zig-specific code-style deltas.

Goal: mechanically honest Zig using native idioms. On a mechanical tie, follow Zig convention.

## Source And Admission

- Pinned source: when syntax, std API, or semantics are uncertain, inspect the project’s Zig version and its compiler or stdlib source.
- Idiom map: retain stable, high-leverage idioms backed by observed model misses or verified semantic risk. Avoid version-note sediment.

## Control And Values

- Value flow: use labeled blocks and loops to yield required artifacts directly.
- Valid state: declare values where they become valid; avoid optional or `undefined` staging when an expression can yield the value.
- Phase scope: use blocks to fence temporary resources and `defer`, then yield one valid artifact.
- Context typing: state the result type once and let literals inherit it.
- Index walk: prefer `for (a..b) |i|` for plain ranges; use `while` when mutation or progression is part of the algorithm.

## Failure

- Error union: use for branchable runtime failure.
- Assertion: use for internal invariants and documented programmer preconditions. Violations are illegal behavior.
- Unreachable: use only after local proof.
- Panic: reserve for fatal program failure.
- Error source: preserve source errors unless translation adds domain value. Capacity exhaustion may honestly remain `error.OutOfMemory`.
- Runtime safety: change safety scope locally and deliberately; every removed check needs proof.

## Types And Layout

- Earned nominal: use `enum(N)` wrappers for identity, units, handles, and meaningful layout state.
- Sentinel: add sentinel states only when they are genuine domain or representation states.
- Layout proof: force meaningful size, alignment, and cache-boundary contracts inside `comptime` blocks. Derive incidental padding; avoid freezing unrelated offsets.

## Comptime And Shape

- Static mechanics: use `comptime` for layout proof, type/value derivation, and genuine static parameters.
- Array repetition: use `@splat(value)` with a contextual array or vector type.
  The old `array ** count` syntax is gone.
- Generic machinery: admit it when primitive composition improves and generated control and cost remain visible.
- File order: imports and aliases first; then state, types, public API, and deep machinery. Keep private helpers near their owner.

## Reflow Pass

After Zig edits, audit changed lines against the repo width limit; default 80.
A user request expands scope to named files. A clean audit ends the pass.

Reflow each offender. Use trailing commas for `zig fmt`-stable breaks. Format,
then reread each changed hunk.

```text
code shape → mechanics → system shape
```

Follow new pressure upward while evidence holds. Resolve local pressure locally.
Report broader pressure at its owning seam before expanding scope.

Done: scoped lines fit; format is stable; each hunk was reread; pressure is
resolved or reported; mechanics remain accounted for; tests and diff checks
pass.
