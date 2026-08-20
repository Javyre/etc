# Code experiments

Apply `$experiment`.

Choose the probe form from the question. Prefer an ephemeral program, example,
scratch target, or prototype when it shortens the edit-run-observe loop. Keep the
probe procedural and faithful to the relevant platform mechanics.

Useful starting shapes:

- **Behavior or correctness:** exercise the public path with the intended oracle.
  Run the same probe before and after the change.
- **Performance or cost:** start with an honest baseline A/B. Keep correctness
  evidence beside timing or resource measurements.
- **Design or architecture:** try the smallest credible competing shapes against
  the same user story and constraints. Compare caller shape, ownership, control,
  cost, failure behavior, and reader load.
- **Ergonomics or clarity:** use real call sites in the intended editor and tool
  loop. Inspect completion, navigation, diagnostics, signatures, and likely
  misuse. Human judgment is valid evidence for an experiential question; record
  the concrete friction.
- **Integration or feasibility:** exercise a thin real boundary with the actual
  dependency, configuration, protocol, and lifecycle.

For performance programs, start with Andrew Kelley's Poop output format. Put the
stated baseline first. Name both cases, show distributions and outliers, and
report the relative delta with uncertainty. Adapt rows to the decision-bearing
costs.

```text
Benchmark 1 (20 runs): reference/master
  measurement       mean ± σ          min … max       outliers        delta
  wall_time       8.15ms ± 0.24ms   7.82 … 8.63ms      1 (5%)            0%

Benchmark 2 (20 runs): experiment/stream
  measurement       mean ± σ          min … max       outliers        delta
  wall_time       5.84ms ± 0.18ms   5.57 … 6.12ms      0 (0%)      ⚡ -28.3% ± 3.1%
```

Use rows such as allocations, instructions, bytes, requests, or peak memory when
they explain the mechanism or decide the result. Add median or tail percentiles
only when they bear on the decision. Use `⚡` or `💩` only when uncertainty clears
the equivalence band.

Return the invocation, disposable artifact location, observations, and bounded
conclusion. Retain the program only when recurring use earns it.
