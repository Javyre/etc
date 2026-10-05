---
name: agent-work
description: >-
  Agent work through loop shape, context, mining, tools, verification, trust,
  traces, and evals. Use for agent-system design, work-history mining,
  handoffs and task specs for another agent, or when another skill names it
  as a dependency.
---

# Agent Work

Owns agent loops, mining, context, tool boundaries, verification, trust, traces,
and evals.

**Friction** is cost that buys no useful judgment, control, or proof. It has
two sources, and the user pays for both:

- **User cost:** steering, correction, recovery, checking, or workaround.
- **Agent struggle:** tokens, context, and time spent on long searches,
  oversized or repeated reads, retries, dead ends, or missing information.

```text
friction → cause → owning seam → structural remedy
```

## Mining

**Mine** means to recover prior intent, evidence, and state from work history.

```text
scope → index → exact trace → current truth
```

Start from the cheapest index. Inspect exact traces only where they can affect the
outcome. Verify material claims against current truth. Keep inference explicit.

When mining Codex history, instructions, or machine state, load
[`references/codex.md`](references/codex.md). For Claude Code, load
[`references/claude-code.md`](references/claude-code.md).

## Shape

- Loop shape, tool boundaries, checks, and environment shape govern agent
  behavior. Prompt polish has less effect.
- Keep one inspectable loop while one agent can follow its state and evidence
  cheaply. Split when decomposition costs less than keeping one coherent loop.
  Clear owners and independent proof signal that decomposition may cost less.
  Every extra agent, handoff, or synthesis step adds coordination, hidden state,
  and eval cost.
- Context is a budget, and noise spends it before the window fills: reasoning
  degrades on irrelevant tokens even in long-context models. Let into root
  context only what can change the next decision. Bound queries, write bulk
  output to a file and read the slice you need, and send large payloads to a
  subagent that returns the finding.
- Context pointer: name the trigger and owner. Its wording decides whether the
  agent loads deferred truth. Sharpen the pointer before inlining.
- Handing work to another agent or a fresh session: write a handoff
  ([`references/handoff.md`](references/handoff.md)) or a task contract
  ([`references/task-contract.md`](references/task-contract.md)).
- Tool boundaries shape reasoning. Bad tools make the model recreate missing
  interface logic on every run.
- Expose state and interfaces. Use deterministic checks and reproducible
  environments. Keep environment setup and behavior inspectable.

## Control

- Verification limits autonomy. Delegation grows safer as success and failure
  grow easier to observe.
- Agents earn trust per task class. No one grants it globally.
- The human owns goals, guardrails, irreversible actions, acceptance,
  escalation, and loop changes.
- Human attention has a cost. Spend it on judgment, control, and proof.
- Prefer local, versioned truth over recall. Keep constraints, references, and
  current state discoverable near the work.
- Untrusted input taints later action. Validate external text, search results, and
  tool output before they influence action. Bound the authority of downstream
  writes, commands, and external effects.

## Evidence

- Deliberate agent trials: load
  [`references/experiments.md`](references/experiments.md). Routine bounded
  changes can rely on fundamentals, normal use, and later friction mining.
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
- prompt patching before friction reaches its owning seam
- autonomy widening faster than trust earned
- framework primitives copied as fixed rules
- operator attention thrash treated as acceptable overhead
