---
name: writing-for-agents
description: Reference for writing skills, agent instructions, and documents agents reach through pointers.
disable-model-invocation: true
---

Write documents that help an agent complete the task within its authority.
**Predictability** means following a repeatable process. Judge that process by
its results and authorized behavior.

These principles apply to skills, `AGENTS.md`, `CLAUDE.md`, and linked reference.
For skill frontmatter, invocation, or routing, read
[`SKILL-MECHANICS.md`](SKILL-MECHANICS.md).

## Context pointers

A **context pointer** names deferred material and the condition for loading it.
A skill description, an instruction-file link, and a reference link all do this.
A **branch** is a distinct case the document handles.

The pointer's wording decides when the agent reaches the material. If required
material is missed, sharpen the pointer first. Inline it only if that fails.

- Front-load the **leading word**, the concept used to request the material.
- Include one trigger per branch. Collapse synonyms for the same branch.
- Identify the material briefly. Leave detail to its body.

## The two loads

**Context load** is the tokens and attention spent on always-loaded material,
including instruction files and discoverable skill descriptions. Prune pointers
harder than their deferred bodies because their cost recurs on every turn.

**Cognitive load** is what the human must remember about available documents and
when to reach them. Spend human attention where judgment or control matters.
Use agent discovery where remembering the document buys neither.

Deferred material costs context when loaded. Its pointer has its own cost.
Material with no discoverable pointer depends on the human to supply it.

## Information hierarchy

A document contains **steps**, **reference**, or both. Steps are ordered actions.
Reference supplies definitions, rules, facts, and conditional instructions.
Arrange each item by when the agent needs it:

1. **In-file steps.** What the agent does, in order.
2. **In-file reference.** Material needed across branches. A flat set of peer
   rules is valid, including a document that is entirely reference.
3. **Disclosed reference.** Material loaded through a context pointer. It can
   live beside the document or elsewhere and can serve several documents.

**Progressive disclosure** moves reference behind pointers. Keep what every
branch needs inline. Disclose what only some branches need. Excess reference
can bury steps; excessive disclosure can hide required instructions.

**Co-location** keeps a concept's definition, rules, and caveats together.
Scattering divides one meaning across locations. **Duplication** repeats it.

**Sprawl** is excess length even when every line is current and unique. Disclose
conditional reference or split the document so each path carries what it needs.
Each split spends context load or cognitive load; it must earn that cost.

## Steps and completion

Each step ends on a **completion criterion**. Make it checkable and exhaustive
where coverage matters. "Every modified model accounted for" states a stronger
bound than "produce a change list."

The criterion's clarity lets the agent distinguish done from unfinished work.
Its demand drives **legwork**, the investigation and proof within the work.
Demand also binds flat reference: "every rule applied" requires coverage without
an ordered sequence.

**Premature completion** means leaving a step before meeting its criterion.
Visible **post-completion steps**, the steps still ahead, can draw attention away
from the current work. Sharpen the criterion first. Only if the bound must remain
fuzzy and the agent still rushes should you split the sequence to hide later work.

That split needs a real context boundary. Dispatching a bounded task to a fresh
agent or handing off to a fresh session can create one. An inline skill call does
not clear later steps from the caller's context. Merging sequences exposes them
again. Split in response to observed failure, not merely because steps exist.

Thin legwork can also occur within a completed step or an all-reference task.
Check the required coverage as well as the stopping condition.

## Leading words

A **leading word** is a compact concept the agent can use while executing a
document or selecting it through a pointer. Prefer established words with the
intended meaning. Define unfamiliar terms once beside their rules.

Repeat the term where useful, rather than repeating its definition. Use the same
term in prompts, documents, and code when it names the same concept. A strong
term may need only one use.

Replace repeated instructions with a term only if it preserves their operational
meaning. For example, _red_ can name a test failing on the target bug. _Tight_
does not establish that a loop is deterministic or cheap; keep such requirements
explicit when they decide acceptance.

**Negation** is a possible failure mode when a prohibition leaves the target
behavior unclear. State the positive target. Keep explicit prohibitions for hard
boundaries and pair them with the permitted behavior.

Treat word choice and negation guidance as heuristics. Their value depends on the
model and task. When observed failures or a behavior-changing comparison warrant
a trial, use `$experiment`; prose alone does not prove improved behavior.

## Pruning

Keep each meaning in a **single source of truth**. A behavior change should
require one edit. Duplication costs maintenance and tokens and can give a rule
more weight than intended.

The environment is a source of truth. A document that repeats config, scripts,
directory layout, or tool help is a **cache**. Prefer a pointer when lookup is
cheap. Cache expensive lookups only when the saved work earns the maintenance
cost; name the source and refresh condition.

Document conventions, reasons, and hazards the environment does not reveal.

Check each line for **relevance**: does it still affect the task? Remove stale
rules and exposition that changes no decision. **Sediment** accumulates when
new instructions remain layered over superseded ones.

Then hunt **no-ops** sentence by sentence. A no-op changes nothing because the
model already follows it by default. A relevant sentence can still be a no-op.
Delete a failed sentence before trying to shorten it. Preserve what changes
behavior, scope, judgment, or proof.

The no-op test is model-relative. When readers disagree about the default, run
the document and observe it. Judge leading words by the same test. Stronger
wording earns its place through changed behavior, not intensity alone.
