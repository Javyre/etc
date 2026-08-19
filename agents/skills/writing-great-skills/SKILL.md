---
name: writing-great-skills
description: Reference for writing and editing predictable skills. Defines the vocabulary and principles behind them.
disable-model-invocation: true
---

A skill steers a stochastic system toward a predictable process.
**Predictability** means the agent follows the same process on every run. Its
output may vary. Every lever below supports predictability.

**Bold terms** are defined in [`GLOSSARY.md`](GLOSSARY.md). Look them up there for
the full meaning.

## Invocation

Invocation trades one cost for another:

- A **model-invoked** skill keeps a **description**. The agent can fire it, other
  skills can reach it, and the user can still name it. Its description adds
  **context load** on every turn. Omit `disable-model-invocation`. Write the
  description for the model and include one trigger for each branch.
- A **user-invoked** skill hides its description from the agent. Only the user can
  invoke it. It adds no context load, but it spends **cognitive load** because the
  user must remember it. Set `disable-model-invocation: true`. Write the
  `description` as a one-line summary for the user.

Choose model invocation when the agent or another skill must reach the skill. If
the skill fires only by hand, make it user-invoked and pay no context load.

When user-invoked skills become hard to remember, add a **router skill**. The
router names the other skills and when to use each one.

## Writing the description

A model-invoked **description** identifies the skill and names the **branches**
that trigger it. Every word increases **context load**, so prune the description
harder than the body:

- **Front-load the skill's leading word.** The description is where the word does
  its invocation work.
- **One trigger per branch.** Synonyms that rename one branch are **duplication**.
  "Build features using TDD" and "asks for test-first development" describe one
  branch. Collapse them. Keep distinct branches.
- **Cut identity that's already in the body.** Keep the description to triggers
  and any reach clause for another skill.

## Information hierarchy

A skill contains **steps**, **reference**, or both. Place each item on the
**information hierarchy** according to when the agent needs it:

1. **In-skill step.** An ordered action in `SKILL.md`. Each step ends on a
   **completion criterion** that tells the agent when the work is done. Make the
   criterion checkable. Make it exhaustive when coverage matters. "Every modified
   model accounted for" is exhaustive. "Produce a change list" is vague and
   invites **premature completion**.
2. **In-skill reference.** A definition, rule, or fact in `SKILL.md` that the agent
   consults on demand. A flat set of peer rules is valid. For example, every rule
   of a review may sit on one rung. This skill is all reference.
3. **External reference.** Reference stored outside `SKILL.md` and loaded through
   a **context pointer**. Disclosed reference, such as `GLOSSARY.md`, remains part
   of the skill. Other external reference may live outside the skill system.

A demanding completion criterion drives **legwork** within a step. It also binds
flat reference. "Every rule applied" demands coverage without a step sequence.

Keep shared instructions near the top. Move branch-specific reference down. Too
little disclosure bloats the top. Too much hides instructions the agent needs.

**Progressive disclosure** moves **reference** out of `SKILL.md` and behind a
**context pointer**. Branching supplies the main test. Keep instructions shared by
every branch inline. Put branch-specific reference in a `.md` file named for its
contents. For example, this skill discloses its full definitions to `GLOSSARY.md`.
A **branch** is one distinct way to use the skill. The pointer wording decides
when and how reliably the agent loads its target.

The hierarchy decides where material lives. **Co-location** decides what lives
together. Keep a concept's definition, rules, and caveats under one heading.

## When to split

**Granularity** is how finely you divide skills. Each split spends context load or
cognitive load. Use two tests:

- **By invocation.** Split off a **model-invoked** skill when a distinct **leading
  word** should trigger it or another skill must reach it. The new description
  adds **context load**, so independent reach must earn that cost.
- **By sequence.** Split a run of **steps** when visible
  **post-completion steps** cause **premature completion**. Hiding later steps
  keeps attention on the current step and its **legwork**.

## Pruning

Keep each meaning in a **single source of truth**. A behavior change should
require one edit.

Check every line for **relevance**: does it still bear on what the skill does?

Then hunt **no-ops** sentence by sentence. Test each sentence in isolation. If it
changes no behavior, delete it. Most failed prose should go instead of being
rewritten.

## Leading words

A **leading word** is a compact concept already present in the model's training.
The agent uses it while running the skill. Examples include _lesson_, _fog of
war_, and _tracer bullets_. Repetition builds its meaning across the skill and
anchors related behavior. A strong leading word may need only one use.

It supports predictability twice. In the body, it anchors _execution_. In the
description, it anchors _invocation_. Using the same word in prompts, docs, and
code helps the agent connect that language to the skill and invoke it more
reliably.

Look for repeated instructions that one leading word can replace. A triad repeated
at three sites is **duplication**. A description may also spend a sentence on one
idea that can **collapse** into one word. Examples:

- "fast, deterministic, low-overhead" becomes _tight_. One pretrained word names
  the shared quality of the loop.
- "a loop you believe in" becomes _red_. The fuzzy gate becomes observable. The
  loop goes red on the bug, or it does not.

This saves tokens and gives the agent a sharper concept. Assume every skill
contains restatements that a leading word can retire. Find them.

## Failure modes

Use these to diagnose issues the user may be having with the skill.

- **Premature completion.** The agent ends a step before it meets the completion
  criterion. Sharpen that criterion first. If it must remain fuzzy and the agent
  still rushes, hide the **post-completion steps** with a sequence split.
- **Duplication.** The same meaning appears in more than one place. It costs tokens
  and maintenance. It also gives the meaning more weight than intended.
- **Sediment.** Stale layers remain because adding feels safer than removing.
  Pruning prevents them from accumulating.
- **Sprawl.** A skill is too long even though every line is current and unique.
  Disclose **reference** behind pointers. Split by **branch** or sequence so each
  path carries only what it needs.
- **No-op.** A line tells the model to do what it already does. Test whether the
  line changes behavior. If _be thorough_ changes nothing, use a stronger leading
  word such as _relentless_ or delete the instruction.
- **Negation.** A prohibition makes the forbidden behavior more available. State
  the **positive** target. Keep a prohibition only for a hard guardrail that has
  no safe positive form, and pair it with the target behavior.
