# Skill mechanics

The skill-specific reference for [`writing-for-agents`](SKILL.md).

## Invocation

Choose invocation by who needs to reach the skill:

- **Model-invoked.** The agent can select the skill, and the user can still name
  it. Write a description with the trigger branches. Omit
  `disable-model-invocation` and configure the host to allow implicit invocation.
- **User-invoked.** The human selects the skill explicitly. Set
  `disable-model-invocation: true`. Write the description as a short human-facing
  summary. In Codex metadata, set `policy.allow_implicit_invocation: false`.

Keep frontmatter and host metadata consistent. The host controls discovery and
invocation; a description field alone does not establish either. Check the
active host's behavior before assuming a skill is hidden or reachable.

Choose model invocation when autonomous discovery or another skill's workflow
needs it. Keep explicit invocation where human selection provides useful control.
Loading reference does not itself authorize edits or other actions. State an
approval boundary separately when the workflow needs one.

## Splitting by invocation

Split off a model-invoked skill when a distinct trigger or another workflow needs
independent reach. Its description spends context load, so that reach must earn
its cost. Sequence splitting follows the completion rules in `SKILL.md`.

## Routing and shared reference

A **router skill** names skills and when to use them. A user-invoked router can
reduce what the human must remember. A pointer to another skill does not grant
permission to invoke it; follow the target's invocation contract.

Store shared reference in a plain file when it needs no independent trigger.
Any document can point to it. Reading that file does not require invoking a
workflow merely to recover its definitions.
