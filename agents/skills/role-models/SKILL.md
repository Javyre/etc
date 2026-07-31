---
name: role-models
description: >-
  Precedent research for material design choices. Use when role-model evidence
  could improve or challenge first-principles systems, mechanics, code, or
  agent design, or when another skill needs pressure-aware precedent.
---

# Role Models

Owns pressure-aware precedent research for material design choices.

Goal: resolve the choice, control context use, and compound a reusable evidence index.

## Problem Map

- Primitive set: `./references/casey-muratori.md`, `./references/andrew-kelley.md`, `./references/raph-levien.md`, `./references/matklad.md`
- Surface truth: `./references/casey-muratori.md`, `./references/andrew-kelley.md`, `./references/joran-dir-greef.md`, `./references/floooh.md`
- API and seams: `./references/burnt-sushi.md`, `./references/mitchell-hashimoto.md`, `./references/matklad.md`, `./references/withoutboats.md`
- State and identity: `./references/raph-levien.md`, `./references/nick-fitzgerald.md`, `./references/aria-beingessner.md`, `./references/joran-dir-greef.md`
- Ownership and concurrency: `./references/mara-bos.md`, `./references/niko-matsakis.md`, `./references/aria-beingessner.md`, `./references/withoutboats.md`
- Cost and layout: `./references/casey-muratori.md`, `./references/andrew-kelley.md`, `./references/chris-fallin.md`, `./references/nick-fitzgerald.md`, `./references/joran-dir-greef.md`, `./references/floooh.md`
- Proof and testing: `./references/joran-dir-greef.md`, `./references/chris-fallin.md`, `./references/mara-bos.md`, `./references/hamel-husain.md`, `./references/simon-willison.md`
- Agent loops and context: `./references/matt-pocock.md`, `./references/simon-willison.md`, `./references/birgitta-boeckeler.md`, `./references/mitchell-hashimoto.md`, `./references/armin-ronacher.md`, `./references/anthropic-engineering.md`, `./references/nuno-campos.md`, `./references/kief-morris.md`
- Evals and trust: `./references/hamel-husain.md`, `./references/anthropic-engineering.md`, `./references/simon-willison.md`, `./references/birgitta-boeckeler.md`

## Flow

- Fork: state the choice, known pressures, and missing evidence.
- Select: load profiles likely to change the decision or expose missing pressure.
- Context budget: load profiles incrementally. Add another when it could materially improve the result.
- Research: follow primary writing, talks, source, and code until the completion condition can be met.
- Delegation: use fresh subagent work for broad, independent, or context-heavy research. Give each agent a bounded evidence question; keep synthesis in the root context.
- Transfer: extract the choice, pressure, fit, mismatch, and consequence. Feed useful results into systems design, mechanics, and code work.
- Compound index: when research produces reusable value, update the canonical profile and sharpen the shortest Problem Map pointer that would help a future run find it.
- Distillation: when recurring evidence suggests a stable core-guide lesson, present the proposed owner, exact lesson, supporting pressure, and suggested edit. Ask the user to approve by invoking `$writing-great-skills`.
- Approved edit: after that explicit invocation, load the skill and apply its SSoT, relevance, no-op, co-location, leading-word, and context-pointer checks while drafting and editing the guide.

Complete when the design choice is resolved or remaining uncertainty is explicit, every adopted lesson carries enough primary evidence and pressure context, and reusable new findings are indexed.
