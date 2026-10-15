# Codex

Codex source layout for Agent Work mining.

Layout checked on 2026-09-06 with `codex-cli 0.153.4`. After upgrades, root
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
- `<codex-root>/config.toml`: model, sandbox, approvals, and MCP servers.
- `<codex-root>/memories/`: shared factual reference.
- Current project instructions and docs: project truth.

## History

- `<codex-root>/history.jsonl`: cheap index.
- `<codex-root>/sessions/`: exact traces, context, dates, cwd, and injected rules.

Search the index with targeted `rg`. Narrow session archives by timestamp and
cwd. Derive absolute dates from `ts` or `timestamp`.

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
