---
name: agent-work
description: >-
  Agent work through loop shape, context, mining, tools, verification, trust,
  traces, and evals. Use for agent-system design, work-history mining, or when
  another skill names it as a dependency.
---

# Agent Work

Owns agent loops, mining, context, tool boundaries, verification, trust, traces,
and evals.

**Friction** — human effort that buys no useful judgment, control, or proof:
steering, correction, recovery, checking, or workaround.

```text
friction → cause → owning seam → structural remedy
```

## Mining

**Mine** — recover prior intent, evidence, and state from work history.

```text
scope → index → exact trace → current truth
```

Start from the cheapest index. Inspect exact traces only where they can affect the
outcome. Verify material claims against current truth. Keep inference explicit.

When mining Codex history, instructions, or machine state, load
[`references/codex.md`](references/codex.md).

## Shape

- Loop shape, tool boundaries, checks, and environment shape matter more than prompt polish.
- Keep one inspectable loop unless decomposition is cheaper than coherence. Every extra agent, handoff, or synthesis step adds coordination, hidden state, and eval cost.
- Context is a budget. Keep root context small, current, and high-signal. Rules, docs, tools, plans, memory, and live state have different costs.
- Context pointer: name the trigger and owner; wording decides whether deferred truth loads. Sharpen the pointer before inlining.
- Tool boundaries shape reasoning. Bad tools make model recreate missing interface logic in tokens every run.
- Explicit state, explicit interfaces, deterministic checks, and low-magic environments are easier to steer and trust.

## Control

- Verification limits autonomy. A task is only as safe to delegate as its success and failure are observable.
- Trust is earned by task class, not granted globally.
- Human owns goals, guardrails, irreversible actions, acceptance, escalation, and loop changes.
- Human attention is a real cost. Spend it on judgment, control, and proof.
- Local, versioned truth beats recalled truth. Agents work best when constraints, references, and current reality are discoverable near the work.
- Untrusted input taints later action. External text, search results, and tool output cross trust boundaries with blast-radius implications.

## Evidence

- Experiments: when uncertainty needs an active probe, load [`references/experiments.md`](references/experiments.md).
- Runs must be inspectable. Traces, checkpoints, artifacts, and check results are product outputs, not debug leftovers.
- Measure real task success and real failure modes, not benchmark comfort or generic scores.
- Recurring friction should become structure: checks, evals, tools, context, or tighter boundaries.
- If traces and evals cannot localize whether failure came from context, tool use, action order, synthesis, or side effects, the system is under-instrumented.
- Cheap generation does not make quality cheap. Correctness, review, maintenance, and trust still cost real work.

## Smells

- giant root prompt instead of context curation
- more agents with blurrier ownership
- more tools with fuzzier purpose
- no cheap verification path
- traces that exist but do not localize failure
- prompt patching before friction reaches its owning seam
- autonomy widening faster than trust earned
- benchmark wins treated as product truth
- framework primitives copied as doctrine
- operator attention thrash treated as acceptable overhead
