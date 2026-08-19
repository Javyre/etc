# Glossary — Building Great Skills

The domain model for skill quality. A skill steers a stochastic system toward a
predictable process. **Predictability** is the root virtue, and every term below
acts on it. This is the disclosed reference for
[`writing-great-skills`](SKILL.md).

The terms are grouped by axis. **Invocation** covers how a skill is reached.
**Information Hierarchy** covers how its content is arranged. **Steering** covers
runtime behavior. **Pruning** keeps the skill lean. Each **failure mode** appears
beside the lever that cures it.

**Bold terms** in any definition are themselves defined in this glossary; find them by their heading.

## Predictability

The degree to which a skill makes the agent follow the same process on every run.
The output may vary. For example, a brainstorming skill should diverge
predictably, with varying tokens and stable behavior. Every other term supports
this root virtue. Cost and maintainability provide evidence about predictability.
Predictability remains the root criterion.

_Avoid_: consistency, reliability, robustness, output-determinism

## Invocation

How a skill is reached and which load the choice imposes.

### Model-Invoked

A skill that keeps its **description** field. The agent can discover it, other
skills can invoke it, and the user can still name it. There is no model-only
state. A description adds agent discovery without removing user access. It
imposes **context load** on every turn. A model-invoked skill can also hold shared
**reference** because other skills can reach it. Use this form only when the
agent or another skill must reach the skill.

_Avoid_: ability, tool, capability

### User-Invoked

A skill whose **description** is hidden from the agent. Only the user can invoke
it by name. It has no **context load**, but the agent and other skills cannot
reach it.

_Avoid_: procedure, workflow, command

### Description

The skill's machine-readable trigger. It is the one **context pointer** that a
**model-invoked** skill keeps loaded on every turn. Keep the description and the
agent or another skill can invoke the skill. Hide it and only the user can invoke
the skill. The description creates the skill's **context load**.

_Avoid_: frontmatter, summary

### Context Pointer

A reference in the agent's context that names deferred material and the condition
for loading it. The **description** is the top-level context pointer from the
context window to the skill. Pointers to disclosed files work one level down.
The wording decides when and how reliably the agent loads the target. A weak
pointer to required material creates variance. Sharpen the wording first. Inline
the material only if sharpening fails.

_Avoid_: link, reference, import

### Context Load

The tokens and attention spent on a **model-invoked** skill's always-loaded
**description**. **User-invoked** skills avoid this cost. Context load limits how
many model-invoked skills should exist.

_Avoid_: token cost, context bloat

### Cognitive Load

The skills and triggers that a human must remember. The human is the index for
**user-invoked** skills. **Model-invocation** removes this cost through agent
discovery. Cognitive load limits how many user-invoked skills a person can use.
It also preserves human agency. Spend it where human judgment matters. Remove it
where human judgment does not matter.

_Avoid_: human index, burden, overhead

### Router Skill

A **user-invoked** skill that names other user-invoked skills and when to use
them. The human remembers one router instead of many skills. The router can point
to those skills but cannot invoke them because they have no **description**. Use
a router when the catalog creates too much **cognitive load**.

_Avoid_: dispatcher, menu, registry, index, router procedure

### Granularity

How finely you divide skills. More **model-invoked** skills spend **context load**
through their descriptions. More **user-invoked** skills spend **cognitive load**
because the human must remember them. Two cuts guide the division. Split by
**invocation** when a distinct **leading word** should trigger a skill on its own.
Split by **sequence** when visible **post-completion steps** cause the agent to
rush the current step. Merging those sequences exposes the later steps again.

_Avoid_: chunking, modularity

## Information Hierarchy

How a skill arranges its content and how far down the ladder each item sits.

### Information Hierarchy

A ranking based on when the agent needs each item. Two choices produce the
ladder. Material lives in the file or behind a pointer, and it acts as a step or
reference. The rungs:

- **Steps**, in-file and primary
- **Reference**, in-file and secondary
- **Reference**, disclosed behind a **context pointer**

A skill with no **steps** uses the bottom two rungs. A flat set of peer rules, such
as review checks, is valid. The hierarchy does not determine invocation. A skill
can be model-invoked or user-invoked whether it contains steps, reference, or
both. In a skill with steps, excess in-file reference can bury those steps and
make attention unreliable. Keep the top of the ladder legible. Move conditional
reference down.

_Avoid_: structure, organization, layout

### Steps

The ordered actions an agent performs. When present, they are the primary content
of `SKILL.md`. A skill can contain only steps, only **reference**, or both. For
example, TDD can be all steps and a review can be all reference. This choice does
not determine invocation. Every step ends on a **completion criterion**.

_Avoid_: workflow, instructions, choreography

### Reference

Material the agent consults on demand, including definitions, facts, parameters,
examples, and conditional instructions. In a skill with **steps**, reference is
secondary. In a skill without steps, it is the whole body. Reference may also
live outside the skill. See **External Reference**. It is the main candidate for
**progressive disclosure** through **context pointers**.

_Avoid_: supporting material, docs, background

### External Reference

**Reference** that lives outside the skill system in a plain file. It has no
**description** or **steps**, so it cannot be invoked. Any skill can point to it.
Use it for shared reference that does not need its own trigger. It is also the
shared home available to two **user-invoked** skills because neither can invoke
the other.

_Avoid_: doc, resource, knowledge base

### Progressive Disclosure

Moving **reference** out of `SKILL.md` and behind a **context pointer** so the top
stays legible. This protects the **information hierarchy**. Token savings are
secondary. **Branching** decides what to disclose. Keep material needed by every
branch inline. Disclose material needed by some branches. If a pointer loads
required material unreliably, sharpen its wording. Move the material inline only
if that fails.

_Avoid_: lazy loading, chunking

### Co-location

Keeping a concept's definition, rules, and caveats under one heading. The
**Information Hierarchy** decides how far down material sits. Co-location decides
what sits together there. A body of **reference** should read as documentation
for the agent. Group material that the agent needs at the same time.
**Duplication** repeats one meaning. Scattering divides one meaning across the
file.

_Avoid_: grouping, clustering, cohesion

### Sprawl

_Failure mode._ A skill is too long even though every line is current and unique.
The agent reads more before acting, attention spreads across the excess, and each
line adds maintenance and token cost. Use the **information hierarchy** to move
**reference** behind **context pointers**. Split by **branch** or sequence so each
path carries only what it needs. **Sediment** comes from stale material.
**Duplication** repeats meaning. Sprawl is excess length itself.

_Avoid_: bloat, length, size, verbosity

## Steering

The levers that shape runtime behavior toward **Predictability**.

### Branch

A distinct way to use a skill. Different branches take different paths through
the skill. A skill with many steps may have many branches. A linear skill has
none.

_Avoid_: path, case, fork

### Leading Word

A compact concept, also called a _Leitwort_, already present in the model's
training. The agent uses it while running the skill. Examples include _lesson_,
_proximal zone of development_, _fog of war_, and _tracer bullets_. Use the token
in varied contexts across the skill. Define it explicitly once. These uses build
its meaning and anchor related behavior. A new word can work if defined clearly,
but it brings no trained associations. Prefer an existing word.

A leading word supports **predictability** twice. In the body, it anchors
**execution** and focuses attention on the same class of checks. In the
**description**, it anchors **invocation**. Using the same word in prompts, docs,
and code helps the agent connect that language to the skill. Put the words you
use to request the skill in its description.

_Avoid_: keyword, term, motif

### Completion Criterion

The condition that tells the agent a unit of work is done. Its **clarity** lets the
agent distinguish done from unfinished work. A vague condition such as
"understanding reached" invites **premature completion** between steps. Its
**demand** determines the required **legwork**. "Every modified model accounted
for" demands more coverage than "produce a change list." Demand also binds flat
reference through conditions such as "every rule applied." Strong completion
criteria are checkable and exhaustive.

_Avoid_: done condition, exit condition, stopping rule

### Legwork

The work an agent does within one step, such as reading files, exploring code,
making changes, and finding evidence. The agent chooses and performs this work
instead of offloading it to the user. Legwork stays within a step.
**Post-completion steps** act between steps. The skill does not list legwork as a
separate step. Its wording and completion criterion imply the work. A **leading
word** such as _comprehensive_ or a demanding **completion criterion** increases
legwork. The same demand can require coverage across flat reference. Legwork goes
thin when demand is weak or **premature completion** cuts the step short.

_Avoid_: scope, effort, diligence, coverage

### Post-Completion Steps

The **steps** that follow the current step. When visible, they can pull the agent
into **premature completion**. More visible later steps create a stronger pull.
Hide them by splitting the sequence when this failure appears.

_Avoid_: horizon, fog of war, lookahead

### Premature Completion

_Failure mode._ The agent leaves a step before meeting its completion criterion.
This failure requires **steps**. A skill without steps that stops early has thin
**legwork** instead. Visible **post-completion steps** pull attention forward. A
clear **completion criterion** resists that pull. Sharpen the criterion first. If
it must remain fuzzy and the agent still rushes, hide later steps across a context
boundary. A user-invoked handoff or subagent dispatch creates such a boundary.
An inline model-invoked call does not. Premature completion can cause thin
legwork, though legwork can also remain thin through a completed step.

_Avoid_: premature closure, the rush, rushing, shortcutting

### Negation

_Failure mode._ A prohibition puts the forbidden behavior into context and makes
it easier to reproduce. For example, _don't think of an elephant_ activates the
elephant, and _never write verbose comments_ activates verbose comments. The
named behavior becomes the **leading word**, while negation remains a weak
modifier. State the **positive** target, such as "write one-line comments." Keep
a prohibition only for a hard guardrail with no safe positive form. Pair it with
the target behavior.

_Avoid_: ironic rebound, don't-prompting, the pink elephant

## Pruning

Keeping a skill lean by pairing each remedy with the failure it cures.

### Single Source of Truth

The state where each meaning has one authoritative location. Changing behavior
requires one edit. **Duplication** violates this rule.

_Avoid_: home, canonical location

### Duplication

_Failure mode._ The same meaning appears in more than one authoritative location.
Each copy costs tokens and must change with the others. Repetition also gives the
meaning more weight than intended. A **leading word** repeats one token to raise
attention on purpose. It does not repeat the full meaning.

_Avoid_: repetition, redundancy

### Relevance

Whether a line still affects the skill's task. A line lacks relevance when it
never bears on the task. Examples include mere exposition and a conditional
**branch** that belongs behind a pointer. A line can also go stale as the behavior
or world changes. Shorter skills make each line cheaper to check. Relevance asks
whether a line bears on the task. **No-op** asks whether it changes behavior.

_Avoid_: load-bearing, staleness, freshness

### Sediment

_Failure mode._ Stale and irrelevant lines accumulate because adding feels safer
than removing. Readers must dig through old material to find current instruction.
Pruning prevents this erosion of **relevance**. **Duplication** is a separate
failure that repeats meaning.

_Avoid_: accretion, bloat, cruft, rot

### No-Op

_Failure mode._ An instruction changes nothing because the model already follows
it by default. It spends load without changing behavior. Test each line against
the default. A line can be **relevant** and still be a no-op. The trained
associations that make a **leading word** useful can make an obvious instruction
worthless.

A leading word is a technique. No-Op is a verdict on a line. A weak leading word
such as _be thorough_ may fail to change the default. Replace it with a stronger
word such as _relentless_ or delete it. The No-Op test also grades whether a
leading word earns its repetitions. This test is relative to the model's default
behavior. When readers disagree about that default, run the skill and observe it.

_Avoid_: redundant instruction, restating the obvious, belaboring
