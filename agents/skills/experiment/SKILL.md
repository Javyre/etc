---
name: experiment
description: >-
  Experiments that try a change or comparison to choose, reject, or refine an
  approach. Use for benchmarks, A/B tests, prototypes or spikes, manual trials,
  mechanism probes, agent evals, or when another skill names it as a dependency.
  Routine verification of a settled contract stays with its owning skill.
---

# Experiment

Goal: learn enough to keep, deepen, redirect, or reject an approach with the
cheapest faithful evidence.

Experiment owns the decision and evidence loop. The domain owner supplies the
target outcome, relevant mechanics, valid environment, safety bounds, and
interpretation.

Scale the work to the decision. A small reversible question may need one manual
trial and a short verdict. Add cases, repetition, or apparatus only while they
can change the decision.

```text
Question → Model → Pilot → Observe → Update → Stop
              ↑                   │
              └──── next pilot ───┘
```

- **Question:** name the real outcome, open question, decision, and result that
  could change it. A metric is evidence unless the metric is the product outcome.
- **Model:** derive candidates and distinguishing predictions from the underlying
  platform mechanics or architecture. State assumptions that could reverse the
  conclusion.
- **Pilot:** choose the smallest faithful probe with high separating power. Give
  the mechanism a fair chance, verify that the pilot exercised it, and avoid a
  toy case that removes the product condition at issue.
- **Observe:** preserve enough setup, action, state, result, and context to tell a
  failed approach from a bad pilot or bad model.
- **Update:** compare observation with prediction. Revise the model before
  choosing the next probe.
- **Stop:** conclude when the decision is resolved or the next probe costs more
  than it can inform.

Choose the cheapest environment that preserves decision-bearing mechanics and
state. Use local or synthetic environments when faithful, read-only live state
when physical data is the variable, and a disposable target for writes.

Use the result to choose the next move:

- the mechanism is absent under a favorable pilot: stop unless the trace shows
  one removable obstruction
- the mechanism is present but the product outcome loses: reject the direction
- the mechanism is present and the product outcome wins: widen to representative,
  hostile, and deployment cases as the decision requires
- the signal is noisy: isolate state, order, and instrumentation before explaining it

A pilot finds signal. Coverage earns the conclusion. Evidence authorizes only
the named decision. A failed gate stops that branch; a new mechanism is a new
candidate.

Retain the verdict and one cheap rerun path. Keep apparatus only when repeated
use earns its review and maintenance cost. These are reasoning handles, not a
required report shape.
