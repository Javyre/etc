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

- Loop shape, tool boundaries, checks, and environment shape govern agent
  behavior. Prompt polish has less effect.
- Keep one inspectable loop while one agent can follow its state and evidence
  cheaply. Split when decomposition costs less than keeping one coherent loop.
  Clear owners and independent proof are signs that decomposition may cost less.
  Every extra agent, handoff, or synthesis step adds coordination, hidden state,
  and eval cost.
- Context is a budget. Keep root context small, current, and high-signal. Rules,
  docs, tools, plans, memory, and live state have different costs.
- Context pointer: name the trigger and owner. Its wording decides whether the
  agent loads deferred truth. Sharpen the pointer before inlining.
- Tool boundaries shape reasoning. Bad tools make the model recreate missing
  interface logic on every run.
- Expose state and interfaces. Use deterministic checks and reproducible
  environments. Keep environment setup and behavior inspectable.

## Control

- Verification limits autonomy. Delegation safety rises with the observability of
  success and failure.
- Trust is earned by task class, not granted globally.
- Human owns goals, guardrails, irreversible actions, acceptance, escalation,
  and loop changes.
- Human attention has a cost. Spend it on judgment, control, and proof.
- Prefer local, versioned truth over recall. Keep constraints, references, and
  current state discoverable near the work.
- Untrusted input taints later action. Validate external text, search results, and
  tool output before they influence action. Bound the authority of downstream
  writes, commands, and external effects.

## Evidence

- Experiments: when uncertainty needs an active probe, load [`references/experiments.md`](references/experiments.md).
- Runs must be inspectable. Treat traces, checkpoints, artifacts, and check
  results as product outputs.
- Measure success on representative tasks and observed failure modes. Generic
  benchmark scores do not establish product quality.
- Recurring friction should become structure: checks, evals, tools, context, or tighter boundaries.
- Traces and evals must localize the failure source: context, tool use, action
  order, synthesis, or side effects. If they cannot, instrumentation is too weak.
- Generation may be cheap. Correctness, review, maintenance, and trust still require work.

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
