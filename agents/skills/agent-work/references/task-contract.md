# Task contract

Audience: an agent that takes on bounded work without the conversation, such
as a subagent or a fresh session.

Purpose: define the task precisely enough to execute, prove, and accept.

Include:

- intended outcome and observable behavior
- scope boundaries, and the authority granted: what the agent may change,
  run, or publish
- constraints and non-goals that change implementation choices
- a checkable completion criterion, exhaustive where coverage matters
- the proof bar and what to report back
- unresolved decisions, and whom to ask instead of guessing

Include current implementation detail only when it changes the outcome,
constraints, or proof bar. Point to repository truth rather than restating
it.

Complete when the agent can act without reconstructing intent and the owner
can tell acceptance from rejection.
