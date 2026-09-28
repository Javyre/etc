# Zig code style guide

Owns Zig-specific code-style deltas.

Goal: mechanically honest Zig using native idioms. On a mechanical tie, follow Zig convention.

## Source and admission

- Pinned source: when syntax, std API, or semantics are uncertain, inspect the project's Zig version and its compiler or stdlib source.
- Idiom map: retain stable idioms that justify their context cost through
  recurring model misses or verified semantic risk. Avoid version-note sediment.

## Control and values

- Value flow: use labeled blocks and loops to yield required values directly.
- Valid state: declare values where they become valid; avoid optional or `undefined` staging when an expression can yield the value.
- Phase scope: use blocks to scope temporary resources and `defer`, then yield one fully initialized value.
- Context typing: state the result type once and let literals inherit it.
- Index walk: prefer `for (a..b) |i|` for plain ranges; use `while` when mutation or progression is part of the algorithm.

## Failure

- Error union: use for runtime failure that callers can branch on.
- Assertion: use for internal invariants and documented programmer preconditions. Violations are illegal behavior.
- Unreachable: use only after local proof.
- Panic: reserve for fatal program failure.
- Error source: preserve source errors unless translation adds domain value. Capacity exhaustion may honestly remain `error.OutOfMemory`.
- Runtime safety: change safety scope locally and deliberately; every removed check needs proof.

## Types and layout

- Earned nominal: use `enum(N)` wrappers for identity, units, handles, and meaningful layout state.
- Sentinel: add sentinel states only when the domain or representation defines
  them.
- Struct defaults: use field defaults only when callers can independently
  override them. For one canonical initial state, leave fields without defaults
  and put the values in a declaration such as `const empty: Self = .{ ... };`,
  following `ArrayList.empty`.
- Layout proof: enforce meaningful size, alignment, and cache-boundary contracts inside `comptime` blocks. Derive incidental padding; avoid freezing unrelated offsets.

## Comptime and shape

- Static mechanics: use `comptime` for layout proof, type/value derivation, and
  parameters whose variation changes the static program shape.
- Uniform fill: use `@splat(value)` with a contextual array or vector type.
  Zig 0.17 no longer supports the old `array ** count` syntax.
- Generic machinery: admit it when it improves primitive composition and
  leaves generated control and cost visible.
- File prelude: put imports and aliases first.

## Reflow pass

After Zig edits, audit changed lines against the repo width limit, which
defaults to 80. A clean audit ends the pass.

Reflow each overlong line at a meaningful boundary. Use layout controls the
formatter supports, including trailing commas, to preserve useful grouping.
Keep diagnostic strings searchable as complete text. Where repository
policy permits, keep such a string intact beyond the default width.

Format, then reread each changed hunk.

```text
code expression → mechanics → system shape
```

Follow new pressure upward while evidence holds. Resolve local pressure locally.
Report broader pressure at its owning seam before expanding scope.

Done: scoped lines fit the applicable width rule or its permitted
searchability exception; format is stable; each hunk was reread; pressure
is resolved or reported; mechanics remain accounted for; diff checks and
checks required by the underlying change pass.
