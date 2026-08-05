# Systems Design Guide

Owns system shape: primitives, composition, ownership, seams, policy, truth, layers, phases, lifecycle, and module boundaries.

Goal: find the minimal complete basis whose composition stays simple and whose owners expose deep, honest interfaces.

## Design Vocabulary

- Primitive: scope-relative semantic building block treated as indivisible by its consumers, with one stable role, owner, cost, and failure contract.
- Primitive set: minimal complete basis for a scope; each member is distinct, and required behavior emerges through simple composition.
- Composition: higher behavior should read as simple primitive composition. Awkward caller-specific glue pressures the primitive set or seam.
- Owner: smallest decision locus with enough semantic and mechanical context and authority to choose policy and preserve an invariant or lifecycle.
- Seam: contract crossing where authority, state, phase, visibility, cost, or failure moves between owners; expose the caller intent and mechanical constraints that cross it.
- Interface: total caller contract at a seam: operations, valid states, ordering, failure, config, and cost. Communicate domain intent precisely; expose the mechanical constraints callers must choose around; keep mechanical primitives owner-local.
- Depth: caller leverage per interface fact; concentrate coherent owner-local behavior behind a small interface that keeps mechanical, cost, policy, and phase truth honest.
- Canonical truth: minimal state owning legality, identity, and lifecycle. Derived state declares owner, invalidation, and rebuild.
- Layer: admit when ownership, lifecycle, invalidation, creation, or scope creates a real boundary. Bias flat.
- Phase: admit when valid state, authority, visibility, retry semantics, or effects require a handoff. Each phase hands off a valid state or explicitly declared reduced mode. Account for passes, buffering, sync, latency, and retained state.
- Seal: semantic checkpoint and naming convention. Prefer POD and phase-local discipline; guards must earn their complexity.
- Tie-break: semantic correctness first. On a genuine tie: mechanical minimum, then minimal basis, then caller ease. Run primitive-set changes by the user.

## Boundaries

- Config once: resolve partial inputs into one validated config; pass facts downstream.
- Honest seam: expose the phase, state, ownership, blocking, mutation, cost, and lifetime constraints callers need to reason correctly; keep remaining mechanics owner-local.
- Invocation contract: treat flags, env, harness setup, and selected tool targets as boundary inputs; confirm them before debugging below.
- Canonical edge: normalize transport, CLI, storage, and user forms into domain primitives before core logic.
- Degradation: when full behavior is unavailable, transition into a smaller valid contract and state the caller-visible loss.
- Canonical source: reuse source-of-truth types, parsing, and validation. Local copies require a narrower or clearer contract.

## Interfaces And Composition

- Depth pressure: repeated caller-side invariant glue is evidence of awkward composition. Tolerate minor duplication while it keeps the primitive basis smaller; deepen when owner-localizing the mechanics materially simplifies composition without adding a weak primitive.
- Semantic translation: translate once between domain primitives and owner-local mechanics, at the seam whose owner understands both. Change primitive vocabulary only where meaning, invariant, lifecycle, cost, or failure changes.
- Policy API: when policy is fixed, expose the caller's concrete intent and let the owner map it to mechanics; avoid arbitrary option combinations and caller-side recipes.
- Ergonomic layer: may batch defaults, reduce ceremony, or freeze call shape while preserving cost, mutation, policy, and phase truth.
- Lower seam: understand the lower contract before shaping the higher interface. Keep it reachable when it carries a real contract, cost choice, or escape hatch.
- Transparent combinator: after useful repetition, name policy-free choreography. Accept minor awkwardness first; add sparingly.
- Variant seam: keep semantically distinct operations separate until shared contract is proven.
- Coordinator/worker: coordinator owns order, staging, retry, and shared policy; workers own narrow, deep mechanics.
- Policy owner: retry, fallback, timeout, and readiness stay with the caller or coordinator able to choose well.
- Caller workaround: repeated refresh, retry, ordering, or caveat glue is evidence of a false seam or wrong owner.
- Interchange seam: variable implementations share the smallest stable carrier; implementation mechanics remain local.
- Canonical mutation: shared truth changes through owner-controlled paths that normalize inputs and preserve invariants.
- Local duplication: duplicate small compositions until shared semantics establish a real primitive with one owner, cost, and failure model.

## Layers And Dependencies

- Dependency direction: pass stable facts downward; keep higher policy and ambient reach-through out of lower owners.
- Dependency scope: place context-wide services at the highest real owner; keep local dependencies local.

## State And Lifecycle

- Model shape: ownership, lifecycle, invalidation, creation, and scope shape subsystem boundaries.
- Identity: centralize canonical identity where dedup, sharing, stable reference, or selective recompute requires it.
- Derived truth: split indexes, caches, and analyzed views only when reuse, invalidation, or staged update is structurally real.
- Retry state: preserve enough state to retry honestly; distinguish retryable and terminal failure.
- Work lifetime: separate one-shot boundary work from persistent work; retain work only when reuse earns it.
- Future-shaped hole: place incomplete work at its eventual owner and dataflow seam; mark the missing primitive explicitly. Avoid speculative layers and adapters.

## Locality And Modules

- Local mess: keep scratch state, fixups, synthetic objects, and special rules with their owner and phase.
- Seam pressure: higher-layer contortions indicate a bad seam; confine repair or translation to the owner-local edge.
- Extraction: split by ownership of complexity. Reuse alone provides weak evidence.
- Stable import point: use a thin facade when it contains internal churn and stabilizes dependency edges.
- Module split: follow ownership and lifecycle boundaries.

## Testing As Design Proof

- Primitive proof: test invariant, transitions, failure and cost contract, plus clean use in a real composition.
- Transition proof: exercise edits, retry, invalidation, deletion, rebuild, recovery, and publication when present in the model.
- Root proof: make starting state, reachability, invalidation, and rebuild rules explicit.
- Proof surface: prefer tests through interfaces used by production callers. Use internal access for distinct mechanical invariants, state-space coverage, or materially faster fault localization. Reliance on internals for ordinary behavior signals a weak interface.
- Proof migration: when a seam moves, delete superseded tests after the new surface proves their behavior. Retain lower tests for distinct invariants, state-space coverage, or materially faster localization.
- Cross-model proof: use implementation parity or model-oracle tests where a seam claims shared semantics.
