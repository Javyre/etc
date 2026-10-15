# Codex

Codex source layout for Agent Work mining.

Layout checked on 2026-10-15 with `codex-cli 0.162.1`. After upgrades, root
changes, or missing paths or fields, refresh affected entries from the
installation and the matching version of
[upstream Codex](https://github.com/openai/codex). Then update this stamp.

## Roots

- Codex root: `$CODEX_HOME` when set; `~/.codex` otherwise.
- A machine can run several roots, each with its own history. The user's
  instructions name them and say which ones you may read.

## Truth

- `<codex-root>/AGENTS.md`: user instructions.
- `<codex-root>/AGENTS.override.md`: temporary user instructions.
- `~/.agents/skills/`: user skills, shared by every Codex root.
  `<codex-root>/skills/` is a deprecated location that still loads.
- `<codex-root>/config.toml`: model, sandbox, approvals, and MCP servers.
- `<codex-root>/memories/`: shared factual reference.
- Current project instructions and docs: project truth.

## History

- `<codex-root>/history.jsonl`: cheap index. One row per prompt: `text`,
  `ts` (epoch s), `session_id`.
- `<codex-root>/session_index.jsonl`: thread names. Append-only rows of
  `id`, `thread_name`, `updated_at`; the latest row for an id wins.
- `<codex-root>/sessions/YYYY/MM/DD/rollout-<time>-<id>.jsonl`: exact
  traces. Archived threads move to `<codex-root>/archived_sessions/`.

Search the index with targeted `rg`. Narrow rollouts by the date in their
path, then by `cwd` in the first row.

Trace hazards for new queries:

- Most rollouts are not the user's threads. The first row (`session_meta`)
  says whose: `payload.thread_source` is `user` for the user's own thread,
  and `subagent` or `guardian_review` for one it spawned, linked back by
  `payload.parent_thread_id`.
- The user's typed messages are `event_msg` rows whose `payload.item.type`
  is `UserMessage`. `response_item` messages with role `user` also carry
  injected instructions.
- With rollout compression on, rollouts older than 7 days become
  `.jsonl.zst`. Read them with `zstd -dc` or search with `rg -z`; both need
  `zstd` on `PATH`.

Session dialogue carries intent, decisions, findings, and blockers. Tool traces
and current project state support verification.

## Machine state

Never read, copy, summarize, or expose credentials or auth state, such as
`auth.json`. Edit anything in the root only with explicit authority. Treat
these as supporting evidence:

- `rules/default.rules`
- `log*`
- `*.sqlite*`
- `models_cache.json`
- `version.json`
- `tmp/`
- `shell_snapshots/`
