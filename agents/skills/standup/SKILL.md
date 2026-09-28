---
name: standup
description: Synthesize recent company work from Codex sessions into compact morning standup notes.
disable-model-invocation: true
---

# Standup

Apply `$agent-work`.

Goal: short, spoken notes about meaningful company progress.

## Window

Use the requested window. Default to the previous local working day through now;
Monday covers Friday through now.

**Buffer.** Follow older traces as needed to recover context for continued or
follow-up work. Buffered activity informs the summary only when the active
window contains relevant progress.

## Mine

Mine every relevant Codex session in the window. Group related sessions by
workstream before judging them.

```text
sessions → workstreams → outcomes
```

Use code, jj, PR, issue, or project state only where it cheaply verifies status or
recovers missing context.

## Admit

**Company** means work serving a company deliverable, decision, incident,
teammate, or active technical investigation.

Keep:

- completed behavior or operational outcomes
- decisions reached or materially changed
- substantial investigation that retired risk, informed a decision, or remains active
- meaningful progress on continued work
- actionable blockers or coordination needs

Exclude:

- personal work
- private skill improvement
- agent setup or workflow refinement
- commands, file inventories, routine checks, and abandoned paths
- implementation detail without team impact

Purpose governs admission. Repo location is weak evidence. Exclude work whose
company relevance is uncertain.

## Synthesize

Merge repeated activity into one bullet that leads with the outcome. Preserve
enough cause and context for team relevance. Never convert activity into claimed
progress.

Repeat active work after meaningful progress. Repeat unresolved blockers while
they remain actionable.

## Report

Use first-person, spoken bullets under:

- `Done`
- `Investigated`
- `In progress`
- `Blocked`

Omit empty sections. Default to one line per item. Expand only high-impact items.
Avoid language centered on agents, sessions, commands, and files.

## Done

Complete when all relevant sessions are admitted or excluded, material status is
verified or qualified, and each workstream appears once.
