# Mechanics guide

Owns mechanical realization: retained state, layout, flow, concurrency, and
publication. In the coding loop, mechanical realization sits between system
shape and code expression, and pressure from either can reshape it.

Goal: preserve mechanical truth and the important cost shape with the simplest primitives.

## Mechanical truth

- Mechanical truth: shape internal primitives around representation, transitions, invariants, movement, and cost.
- Cost model: structural proof handles obvious passes, allocs, copies, locality, and asymptotics; measure uncertain or material tradeoffs.
- Workload: product use sets priority. Benchmarks settle mechanical ambiguity within it. Confirm inferred use before it changes algorithm or retained state.

## Retained state

- Earned state: recompute by default; retain progress only when cost earns explicit ownership, invalidation, and rebuild.

## Data layout

- Unit-bearing names: expose coordinate space and unit. Prefer `index/count` for items and `offset/size` for bytes; clear domain terms and `len` remain valid.
- Access pattern: shape layout around traversal, mutation, movement, and locality; then minimize footprint. Separate control metadata from bulk payload when their use differs.
- Cheap default: prefer caller-owned, inline, and allocation-free storage; keep flexible storage and indirection explicit.

## Flow

- Surface truth: preserve distinct loop, state, branch, and cost shapes; share only stable mechanical meaning.
- Atomicity: when algorithm and cost are materially unchanged, prefer the clearest transition between valid states.
- Hot path: front-load cheap exits; keep rare failure and hidden allocation, buffering, or finalization outside the core loop.
- Earned staging: preserve natural streaming and single-pass flow. Add buffering,
  passes, or phases for a semantic boundary or credible throughput win. Account
  for memory, latency, sync, and retention. Prefer latency when uncertain.
- Canonical path: default to one operational path. Admit dual paths for structurally distinct cases with proven value; keep their split and shared contract explicit.

## Concurrency and jobs

- Local proof: keep work state self-contained and shared state small so ownership, progress, and failure remain locally provable.
- Scoped context: use a local view or handle when mutation, permission, concurrency, or lifecycle rules apply to one scope; keep the base API narrow.

## Verification

When choosing or reviewing executable checks, load
[Testing](testing.md) for deterministic execution, observation, and coverage.
