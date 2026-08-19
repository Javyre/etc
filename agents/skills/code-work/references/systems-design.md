# Systems Design Guide

Owns system shape: primitives, composition, ownership, seams, policy, truth, layers, phases, lifecycle, and module boundaries.

Goal: find the smallest complete primitive set. Its composition stays simple,
and its owners expose deep, honest interfaces.

## Design Vocabulary

- Primitive: a semantic building block that its consumers treat as indivisible
  within the current scope. It has one stable role, owner, cost, and failure
  contract.
- Primitive set: the smallest set that covers the required behavior. Each member
  has a distinct meaning, and simple composition produces the required behavior.
- Composition: higher behavior should read as simple primitive composition.
  Awkward caller-specific glue puts pressure on the primitive set or seam.
- Owner: the smallest component with enough semantic and mechanical context and
  authority to choose policy and preserve an invariant or lifecycle.
- Seam: a contract crossing where authority, state, phase, visibility, cost, or
  failure moves between owners. Expose the caller intent and mechanical
  constraints that cross it.
- Interface: the full caller contract at a seam. It covers operations, valid
  states, ordering, failure, config, and cost. State domain intent precisely.
  Expose mechanical constraints that callers must choose around. Keep mechanical
  primitives with their owner.
- Depth: caller value per interface fact. Concentrate coherent owner-local
  behavior behind a small interface. Keep mechanics, cost, policy, and phase
  visible where callers must reason about them.
- Canonical truth: minimal state owning legality, identity, and lifecycle.
  Derived state declares its owner, invalidation, and rebuild.
- Layer: admit one when ownership, lifecycle, invalidation, creation, or scope
  creates a boundary. Bias flat.
- Phase: admit one when valid state, authority, visibility, retry semantics, or
  effects require a handoff. Each phase hands off a valid state or a declared
  reduced mode. Account for passes, buffering, sync, latency, and retained state.
- Seal: semantic checkpoint and naming convention. Prefer POD and phase-local
  discipline. Guards must earn their complexity.
- Tie-break: semantic correctness first. When choices are otherwise equal, prefer
  the mechanical minimum, then the smaller primitive set, then caller ease. Run
  primitive-set changes by the user.

## Boundaries

- Config once: resolve partial inputs into one validated config. Pass facts
  downstream.
- Honest seam: expose the phase, state, ownership, blocking, mutation, cost, and
  lifetime constraints that callers need to reason correctly. Keep the remaining
  mechanics with their owner.
- Invocation contract: treat flags, env, harness setup, and selected tool
  targets as boundary inputs. Confirm them before debugging below the boundary.
- Canonical edge: normalize transport, CLI, storage, and user forms into domain
  primitives before core logic.
- Degradation: when full behavior is unavailable, transition into a smaller valid
  contract. State the caller-visible loss.
- Canonical source: reuse source-of-truth types, parsing, and validation. Local
  copies require a narrower or clearer contract.

## Interfaces And Composition

- Depth pressure: repeated caller-side invariant glue is evidence of awkward
  composition. Tolerate minor duplication while it keeps the primitive set
  smaller. Deepen the interface when moving mechanics to their owner removes
  enough caller glue to justify the deeper interface without adding a weak
  primitive.
- Semantic translation: translate once between domain primitives and owner-local
  mechanics. Put the translation at the seam whose owner understands both.
  Change primitive vocabulary only when meaning, invariant, lifecycle, cost, or
  failure changes.
- Policy API: when policy is fixed, expose the caller's concrete intent and let
  the owner map it to mechanics. Avoid arbitrary option combinations and
  caller-side recipes.
- Ergonomic layer: may batch defaults, reduce ceremony, or freeze call shape. It
  must preserve cost, mutation, policy, and phase truth.
- Lower seam: understand the lower contract before shaping the higher interface.
  Keep it reachable when callers need its contract, cost choice, or escape hatch.
- Transparent combinator: after useful repetition, name policy-free choreography.
  Accept minor awkwardness first. Add sparingly.
- Variant seam: keep semantically distinct operations separate until evidence
  establishes a shared contract.
- Coordinator/worker: the coordinator owns order, staging, retry, and shared
  policy. Workers own narrow, deep mechanics.
- Policy owner: retry, fallback, timeout, and readiness stay with the caller or
  coordinator that has enough context and authority to choose them.
- Caller workaround: repeated refresh, retry, ordering, or caveat glue indicates
  a false seam or wrong owner.
- Interchange seam: variable implementations share the smallest stable carrier.
  Implementation mechanics remain local.
- Canonical mutation: shared truth changes through owner-controlled paths. Those
  paths normalize inputs and preserve invariants.
- Local duplication: duplicate small compositions until shared semantics establish
  a primitive with one owner, cost, and failure model.

## Layers And Dependencies

- Dependency direction: pass stable facts downward. Keep higher policy and
  ambient reach-through out of lower owners.
- Dependency scope: place context-wide services with the highest owner responsible
  for their full scope. Keep local dependencies local.

## State And Lifecycle

- Model shape: ownership, lifecycle, invalidation, creation, and scope shape
  subsystem boundaries.
- Identity: centralize canonical identity when dedup, sharing, stable reference,
  or selective recompute requires it.
- Derived truth: split indexes, caches, and analyzed views only when they have
  distinct reuse, invalidation, or staged update rules.
- Retry state: preserve enough state to retry honestly. Distinguish retryable and
  terminal failure.
- Work lifetime: separate one-shot boundary work from persistent work. Retain
  work only when reuse earns it.
- Future-shaped hole: place incomplete work with its eventual owner and dataflow
  seam. Name the missing primitive. Avoid speculative layers and adapters.

## Locality And Modules

- Local mess: keep scratch state, fixups, synthetic objects, and special rules
  with their owner and phase.
- Seam pressure: higher-layer contortions indicate a bad seam. Confine repair or
  translation to the edge owned by the responsible component.
- Extraction: split by ownership of complexity. Reuse alone provides weak evidence.
- Stable import point: use a thin facade when it contains internal churn and
  stabilizes dependency edges.
- Module split: follow ownership and lifecycle boundaries.

## Testing As Design Proof

- Primitive proof: test the invariant, transitions, failure contract, cost
  contract, and clear use in a representative composition.
- Transition proof: exercise edits, retry, invalidation, deletion, rebuild,
  recovery, and publication when present in the model.
- Root proof: make starting state, reachability, invalidation, and rebuild rules
  explicit.
- Proof surface: prefer tests through interfaces used by production callers. Use
  internal access for a distinct mechanical invariant, state-space coverage, or
  materially faster fault localization. If ordinary behavior needs internal
  access, the public interface is weak.
- Proof migration: when a seam moves, delete superseded tests after the new
  interface proves their behavior. Retain lower tests for distinct invariants,
  state-space coverage, or materially faster fault localization.
- Cross-model proof: use implementation parity or model-oracle tests when a seam
  claims shared semantics.
