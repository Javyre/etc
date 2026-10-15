---
name: code-work
description: >-
  Use whenever the subject is code, including its names and comments,
  alongside any other skill the task loads.
---

# Code Work

Owns code understanding, the coding loop, testing, reader order, locality, diff scope, program shape, names, imports, and code comments.

## Understanding

- How: for a nontrivial change, explanation of behavior, or unclear flow or
  ownership, load `./references/how.md`.
- Why: for rationale, a strange or deliberate shape, or history that may constrain a change, load `./references/why.md`.

## Testing

For executable-code design or changes, verification decisions, or review of
tests and assertions, load [`references/testing.md`](references/testing.md)
before choosing implementation or test shape.

## System shape

Before proposing or reviewing primitives, APIs, ownership, seams, phases, or
composition, in code or in design discussion, load
[`references/systems-design.md`](references/systems-design.md) and
[`references/mechanics.md`](references/mechanics.md).

## Coding loop

1. Scope: infer intent and design scope from the request and repository
   contracts. Apply Code Work within them. Preserve project behavior unless
   redesign is in scope.
2. System shape: choose the semantic shape (see System shape). Use Sketch
   when the shape remains unresolved.
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
to refine it. Readiness requires Coherence and, after contract or
model changes, completed Fallout.

Slices: before implementing work that needs more than one reviewable step,
or when the user asks how to split it, load
[`references/slices.md`](references/slices.md).

## Sketch

When semantic shape remains unresolved, sketch caller usage, core data,
ownership, seams, key signatures, and control flow in commentary. Derive each
shape from first principles: the system's own state, invariants, and costs.
Precedent checks the derivation for missed constraints; it never justifies the
shape on its own. Compare at most two credible shapes and recommend one.
Proceed on reversible engineering choices. Ask when product values or
irreversible contracts decide the fork. Before an abstraction others rely on
lands, preview its call sites in chat, even as a rough or fake snippet, so
the diff holds no design surprise.

## Experiments

When trying a code change or comparison is the cheapest way to choose, reject,
or refine a direction, load `$experiment` and
[`references/experiments.md`](references/experiments.md).

## Code expression

- Reader order: lead with policy and minimal types; show the public story
  before machinery. Keep private helpers near the code they serve.
- Logical/physical: explain domain behavior first; then map it to state, movement, control, and cost. Keep the correspondence explicit.
- Local fit: follow established project vocabulary and idioms when the
  engineering choice is otherwise tied.
- Grouping: arrange code around the cases and relationships the reader must
  check. Preserve independently reasoned cases even when their bodies match.
  Use rows, columns, spacing, and parallel forms when they expose stages,
  correspondence, or differences.
- Density: keep a small choice at its use. Give substantial computation
  enough space and local scope to reveal its steps. Add intermediate names
  when they carry meaning or make the reasoning easier to check.
- Variety: let local judgment produce variety. Keep equivalent operations
  comparable; let different work take different shapes.
- Character: preserve useful character without manufacturing quirks.
  Stop when further changes merely exchange equally suitable forms.

## Behaviour locality

- Ownership: keep behaviour and policy in the subsystem, phase, or caller that
  owns the decision.
- Special cases: keep ugliness near the phase that needs it.
- Sharing: prefer local duplication when reuse blurs ownership.

## Change scope

- Tight diff: isolate semantic change from cleanup churn and avoid needless allocs. Scan nearby for the same pattern; report matches before expanding the diff.

### Fallout

After contract or model changes, trace affected callers, state, control flow,
tests, docs, and change text. Follow retired assumptions through everything
they previously justified, including sites outside the initial diff.

Reconsider each affected site's role under the resulting design. Reshape,
migrate, simplify, or remove it so its owner, interface, names, and mechanics
express the current contract. Follow those changes through their dependents
within scope. Keeping behavior working through adapters or renamed remnants
does not by itself complete the change.

Migrate internal callers and remove the superseded path in the same change.
Retain compatibility only when an external contract requires it. History may
explain a constraint; the current design must explain how the pieces fit.

Complete when affected sites have a current justification, compose coherently,
and preserve the required behavior and cost contracts. Report deferred fallout
with its scope and impact.

## Program shape

- Caller story: prefer direct, procedural, data-oriented flow; keep policy, phase order, and main dataflow visible.
- Explicit inputs: take what callers may vary as arguments, rather than
  deriving it from another input, discovering it, closing over it, or
  retaining it. Deriving what is a true function of an input is fine; retained
  state must earn its place, as a retained allocator sometimes does.
- Concrete shape: preserve user-named shapes unless the user asks to redesign them.
- Plain first: check correctness and easy perf wins before compressing medium or large work; compress only while semantics stay clear.
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

## Names and imports

A name is the first explanation a reader gets, and they trust it. A good name
gives them the right model of the thing and of how it relates to its
neighbors. A wrong one sends them building the wrong model, which costs more
than no hint at all, so fix a false name first.

Name the system, not the word. Names make sense as a set: see the flow they
live in, name each part for what defines it, and let neighbors confirm each
word. A name chosen alone, against a checklist, fits locally, clashes
globally, and does not stay accepted.

Several pressures act on every name and often pull apart. Weigh them for the
name at hand:

- Defining property: name what the thing is, not one use it serves: a queue
  that holds any item is `Queue`, not `JobQueue`. Name its role rather than
  its type or container: `open_files`, not `registry: Registry` or
  `files_vec`. Pick the least surprising word whose associations hold:
  "group" suggests members chosen ad hoc; "literal" suggests a source-code
  literal.
- Relationships: give related concepts related words so the relation shows
  (`Find`/`Found`, `Cache`/`Caching`, `Parser.Error`), and unrelated concepts
  distinct ones. Hiding a real relation misleads as much as suggesting a false
  one. A brand-new word announces a brand-new concept; save it for one.
  Separate modules keep meanings apart.
- Call site: a name reads right where callers write it, qualifier included:
  `testing.parse` leaves the reader asking "parse what?". Operations are
  imperative verbs; API names match the user-facing names for the same action.
- Familiarity: use what the domain, upstream tool, or docs call it, with its
  established abbreviations. A precedent's word carries its precedent's
  expectations; borrow it when they hold here.
- Brevity: short, plain words, kept while the distinctions survive.
- Proof: state units and index spaces; base-first qualifiers and duals
  expose bad expressions: `source`, `source_words`, `source_index`; `source`
  and `target`.
- Honesty: names reveal waits, retries, allocation, fallback, normalization,
  and policy.

Reach sets the weights: how far a name travels from the code that explains
it. Inside a ten-line loop, `i`, `r`, and `p01` are clear and brevity wins. A
field read three files away carries its meaning alone: `span.style` reads
there, while `span.patch` needs the patch's target in view. A short verb like
`apply` or `run` is clear on a well-named receiver beside its arguments, and
opaque elsewhere.

Opposites: duals help when both sides are peers (`source`, `target`). When
one case is ordinary and the other special, the ordinary one keeps the plain
name: `items` and `pinned_items`, not `normal_items`.

- Contract drift: a rename that changes the model or hides behaviour is a
  contract change. Run new concept names by the user.
- Naming work: for a rename, a naming review, or naming a new design, load
  [`references/naming.md`](references/naming.md).
- Imports: prefer scoped local imports, then go-style imports. Use qualified paths
  when import blocks get noisy.

## Code comments

- Contribution: let code state what it does. Comments earn space through
  reasoning, constraints, representation keys, useful mental pictures,
  or unresolved judgments the reader would otherwise reconstruct.
  Prefer a name, type, assertion, or structure when it carries that
  contribution more clearly.
- Weight: use the space the explanation needs. Explain where understanding
  first becomes necessary; let later parallel cases use that context.
- Voice: prefer terse, direct language. Preserve an apt phrase or candid
  note when it helps. State uncertainty as uncertainty.
- Audience: a comment speaks to whoever reads this code later, at any
  revision, with only the code in front of them: what holds and why it
  must, in the register of documentation. A doc comment speaks to callers
  who will not read the body: the contract, not the implementation. What
  the code replaced and why belongs to the commit message, read against
  its diff. Talk with the user stays in chat; a question for their review
  is a SPONGE.
- Placement: keep the explanation with the decision or representation
  it explains.
- Maintenance: when changing the relevant code, check that its comments
  still hold. Remove stale claims; preserve reasons that still constrain
  the change.
