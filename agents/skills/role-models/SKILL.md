---
name: role-models
description: >-
  Precedent research for decision-bearing systems, mechanics, code, or
  agent-design choices. Use when role-model evidence could expose a missed
  constraint, challenge a first-principles proposal, or help another skill judge
  a choice under similar pressure.
---

# Role Models

Owns precedent research for design choices under similar pressure.

Goal: resolve the choice, control context use, and grow a reusable evidence index.

## Primary Agent-Engineering Pair

- Poteto is the primary model for agent execution and prose taste. Act proactively
  and understand deeply before changing. Compose executable workflows, prove
  results through observed behavior or inspected artifacts, and write with voice.
- Matt Pocock is the primary model for instruction design: predictable process,
  context and cognitive load, information hierarchy, completion criteria,
  leading words, and pruning.
- Taste judgment: Poteto has stronger prose taste and workflow judgment. Matt
  gives the clearer theory and more portable mechanics.

## Problem Map

- Agent engineering, primary: `./references/poteto.md`, `./references/matt-pocock.md`
- Primitive set: `./references/casey-muratori.md`, `./references/andrew-kelley.md`, `./references/raph-levien.md`, `./references/matklad.md`
- Surface truth: `./references/casey-muratori.md`, `./references/andrew-kelley.md`, `./references/joran-dir-greef.md`, `./references/floooh.md`
- API and seams: `./references/burnt-sushi.md`, `./references/mitchell-hashimoto.md`, `./references/matklad.md`, `./references/withoutboats.md`
- State and identity: `./references/raph-levien.md`, `./references/nick-fitzgerald.md`, `./references/aria-beingessner.md`, `./references/joran-dir-greef.md`
- Ownership and concurrency: `./references/mara-bos.md`, `./references/niko-matsakis.md`, `./references/aria-beingessner.md`, `./references/withoutboats.md`
- Cost and layout: `./references/casey-muratori.md`, `./references/andrew-kelley.md`, `./references/chris-fallin.md`, `./references/nick-fitzgerald.md`, `./references/joran-dir-greef.md`, `./references/floooh.md`
- Proof and testing: `./references/poteto.md`, `./references/joran-dir-greef.md`, `./references/chris-fallin.md`, `./references/mara-bos.md`, `./references/hamel-husain.md`, `./references/simon-willison.md`
- Agent loops and context: `./references/poteto.md`, `./references/matt-pocock.md`, `./references/simon-willison.md`, `./references/birgitta-boeckeler.md`, `./references/mitchell-hashimoto.md`, `./references/armin-ronacher.md`, `./references/anthropic-engineering.md`, `./references/nuno-campos.md`, `./references/kief-morris.md`
- Evals and trust: `./references/poteto.md`, `./references/hamel-husain.md`, `./references/anthropic-engineering.md`, `./references/simon-willison.md`, `./references/birgitta-boeckeler.md`

## Flow

- Fork: state the choice, known pressures, and missing evidence.
- Select: load profiles likely to change the decision or expose missing pressure.
- Context budget: load profiles incrementally. Add another only when the expected
  gain in decision, design, or confidence justifies its context cost.
- Research: follow primary writing, talks, source, and code until the completion
  condition is met.
- Delegation: use fresh subagent work for broad, independent, or context-heavy
  research. Give each agent a bounded evidence question. Keep synthesis in the
  root context.
- Transfer: extract the choice, pressure, fit, mismatch, and consequence. Feed
  useful results into systems design, mechanics, and code work.
- Compound index: when research produces reusable evidence, update the canonical
  profile. Sharpen the shortest Problem Map pointer that would help a future run
  find it.
- Distillation: when recurring evidence suggests a stable core-guide lesson,
  present the proposed owner, exact lesson, supporting pressure, and suggested
  edit. Ask the user to approve the proposed edit.
- Approved edit: apply approved edits with `$writing-for-agents` active. Apply its
  SSoT, relevance, no-op, co-location, leading-word, and context-pointer checks
  while drafting and editing the guide.

Complete when the design choice is resolved or remaining uncertainty is
explicit. Every adopted lesson carries enough primary evidence and pressure
context. Reusable findings are indexed.
