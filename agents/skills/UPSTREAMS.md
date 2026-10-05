# Upstreams

Outside skill collections we learn from. Each entry records how far we have
read a source and what we did with it. This is not a sync: we adapt ideas
into our own owners, and local skills may differ from upstream by design.

## Sync pass

1. Clone or update each source, with jj when available.
2. Read the whole diff from `read through` to head, not only the paths listed
   under `read`. Repo conventions (instruction files, `.agents/`, docs) can
   change how skills behave. When an entry is new or `read` grows, also skim
   about a month of history before `read through`.
3. Give each relevant change a decision: adopted (name our owner), declined
   (reason and evidence), deferred (what would reopen it), or pending.
4. Update `read through`, `checked`, `read`, and the decisions. Record only
   what you read. Drop a decision once it no longer helps the next pass.

## mattpocock/skills

- source: https://github.com/mattpocock/skills
- read through: `4588b32ecab9ecc9fc8cc6b6c5e7d675b6004b0d`
- checked: 2026-10-05
- read: the whole diff since `3cca18b`; `.agents/`; `CLAUDE.md`; skills
  `ask-matt`, `chief-of-staff`, `claude-handoff`, `code-review`,
  `codebase-design`, `diagnosing-bugs`, `git-guardrails-claude-code`,
  `grill-me`, `grill-with-docs`, `grilling`, `handoff`, `implement-spec`,
  `improve-codebase-architecture`, `loop-me`, `pr`, `prototype`, `research`,
  `retro`, `setup-pre-commit`, `setup-ts-deep-modules`, `tdd`, `teach`,
  `to-questionnaire`, `wait-what`, `writing-beats`, `writing-for-agents`,
  `writing-fragments`, `writing-shape`. Not yet read: `domain-modeling`,
  `implement`, `setup-matt-pocock-skills`, `to-spec`, `to-tickets`, `triage`,
  `wayfinder`, `wizard`.
- feeds: `writing-for-agents`, `grilling`, `dream`, `agent-work`,
  `writing-for-humans`

Decisions:

- adopted: `retro`'s agent-struggle lens. Owner: `agent-work` friction,
  `dream` Study.
- adopted: user-invoked skills are unreachable from other skills
  (`.agents/invocation.md`, `4aaccb5`). Owner: `writing-for-agents`
  invocation. Pending: making `writing-for-agents` itself model-invoked.
- adopted: shared skill text stays project-agnostic (`retro` docs on
  one-session overweighting). Owner: `dream` Review.
- declined: write "call the Skill tool with X" instead of `$X`. On
  2026-10-05, 20 of 20 headless runs (Claude Code 2.1.284, Opus 5.5) loaded
  a `$X` dependency, whether it was on the first line or buried. Codex is
  untested.
- declined: `chief-of-staff`'s "all work in subagents". It conflicts with
  `agent-work`'s priced decomposition.
- declined: phase rules from `ask-matt/PHASE-BOUNDARIES.md`. We state the
  context-noise constraint and let the agent choose its moves.
- deferred: the `diagnosing-bugs` gate (a reproducing command before any
  hypothesis), requirement tracing in `code-review`, recording rejected
  proposals, and the forcing constraints in `DESIGN-IT-TWICE`. None showed
  friction in history; reopen when a dream pass finds some.
- pending: `retro`'s mechanism-first remedies for `dream`, and the `pr`
  views for `writing-for-humans`.

## humanlayer/skills

- source: https://github.com/humanlayer/skills
- read through: `ca7c808`
- checked: 2026-10-05
- read: `plugins/show-me`, `plugins/visual-pr`, `plugins/improve-claude-md`
- feeds: `writing-for-humans`

Decisions:

- pending: the `show-me` views and the `visual-pr` change outline for
  `writing-for-humans`.

## cursor/plugins (pstack)

- source: https://github.com/cursor/plugins
- read through: `78f46dacbafc71fd7d937bfc2c26da914f1bc09b` for
  `pstack/skills/unslop`; `807c031` for `pstack/skills/how`, `why`,
  `blast-radius`, and `principle-guard-the-context-window`
- checked: 2026-10-05 (`unslop`: 2026-09-25)
- read: the paths above
- feeds: `unslop`, `code-work` (`references/how.md`, `references/why.md`)

Decisions:

- adopted: the latest `unslop` catalog, adapted for AI-authored prose and
  chat.
- pending: `blast-radius`'s evidence ladder and the single fact a change's
  safety rests on, for `writing-for-humans`; `guard-the-context-window` for
  `agent-work`.
