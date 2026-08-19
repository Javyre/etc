# Experiments

Goal: resolve decision-bearing uncertainty with the cheapest faithful evidence.
The question determines the probe.

**Loop:** Question, Model, Probe, Observe, Model update. The updated Model
determines the next Probe until Stop.

- Question: name the uncertainty, affected decision, and result that could change it.
- Model: keep plausible explanations and distinguishing predictions explicit enough to test.
- Probe: isolate the smallest decision-bearing difference under representative conditions.
- Observe: expose and record the state needed to interpret the result. Preserve
  the setup, action, result, and relevant context.
- Model update: compare the observation with the prediction. Revise the
  assumptions, represented state, or mechanism. Check the new model against
  accumulated evidence before choosing the next probe.
- Stop: after each update, conclude if the decision is resolved or another probe costs more than it informs.
- Capture: retain the verdict and one cheap rerun path; keep apparatus only while useful.

These are reasoning handles, not a required report shape.
