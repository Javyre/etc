# Testing

Test features through real execution. Keep implementation free to change.
Design for useful tests that are easy to add, fast to run, and easy to diagnose.
Use runtime assertions liberally along the paths those tests exercise.

## Choose protection

- Test behavior worth preserving, using representative cases and plausible
  failures. Changed functions and lines do not define the test plan.
- Retain tests for protection or diagnosis that existing evidence does not
  adequately provide. Account for setup, runtime, maintenance, and refactoring
  cost. Verification can use existing tests, inspection, or temporary checks.
- Cover relevant state transitions, failure and cost contracts, and composition.
  Consider reachability, retry, invalidation, deletion, rebuild, recovery, and
  publication. These are coverage questions, not a test-per-item checklist.
- Use lower-level tests for distinct invariants, otherwise hidden execution
  paths, state-space coverage, or substantially better diagnosis.
- Repeated difficulty testing important behavior calls for a better design or
  test interface. Avoid making expensive testing a permanent reason to skip it.

## Make cases cheap

- Express starting state, actions, and expected results compactly. Exercise
  production code through feature boundaries, without binding fixtures to
  incidental internals.
- Concentrate setup, invocation, observation, and diagnostics in a small shared
  check function. New cases should mostly add data and expectations. Let
  repeated needs justify machinery.
- Minimize unnecessary I/O, clocks, processes, and ambient state. Let a focused
  case exercise as much code as it naturally reaches. Preserve real external
  boundaries when their behavior is part of the claim; avoid mocking internal
  collaborators merely to isolate functions.
- Expose deterministic readiness and completion. Wait on causal signals, not
  sleeps, and bound waits. Provide stable observations, including targeted
  checks for hidden contracts such as cache use or allocation behavior.
- Keep small cases beside their expectations. Use readable snapshots for
  complex results and inspect expectation changes before accepting them.

## Runtime assertions

- Assert meaningful preconditions, postconditions, relationships, and legal
  transitions in production code. Feature tests and generated scenarios then
  check invariants beyond their explicit output expectations. An assertion
  does not require its own test.
- Assert what must hold. Handle expected invalid input and recoverable failures
  through normal error contracts. Assertions detect broken assumptions without
  making them supported fallback cases.
- Keep useful checks at caller and callee, across transitions, or on independent
  paths. Similar assertions can express different obligations and local knowledge.
- Favor cheap local checks; place expensive checks where their detection value
  earns the cost. Verify with relevant assertions and runtime safety enabled.
  Follow language-specific build semantics. Correctness must not depend on a
  disabled check.
- Retain explicit behavioral expectations. Internal consistency cannot establish
  that a feature produces the intended result.

## Oracles and feedback

- Derive expectations from the contract, worked examples, or a simpler independent
  model. Repeating the implementation can repeat its bug.
- Combine concrete examples with properties, exhaustive small domains, or
  structured generation where useful. Preserve reproducible failures and useful
  state. Weight risky transitions and inspect what generators cannot reach.
- Check implementations claiming shared semantics against a common corpus or
  model. Outer dispatch may leave some implementations unexercised.
- For a known regression, verify that the check distinguishes broken behavior
  from the correction and fails for the intended reason. State unavailable
  evidence. Reduce reproductions to the inputs, state, and steps that matter.
- When implementations or boundaries move, preserve behavioral coverage before
  deleting superseded tests. Retain each test for its distinct contribution.

Complete when the affected contract has appropriate evidence, retained tests
have a clear contribution, and remaining proof gaps are explicit.

For rationale and examples, see
[Matklad's testing sources](../../role-models/references/matklad.md).
