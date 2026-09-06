# Codex

Codex source layout for Agent Work mining.

Layout checked on 2026-09-06 with `codex-cli 0.153.4`. After upgrades, root changes,
or missing paths/fields, refresh affected entries from the installation and
matching version of [upstream Codex](https://github.com/openai/codex); update this
stamp.

## Roots

- Codex root: `$CODEX_HOME` when set; `~/.codex` otherwise.
- Global skill root: `~/.agents/skills`.

## Truth

- `<codex-root>/AGENTS.md`: universal instructions.
- `<codex-root>/AGENTS.override.md`: temporary instructions.
- `<codex-root>/memories/`: shared factual reference.
- Current project instructions and docs: project truth.

## History

- `<codex-root>/history.jsonl`: cheap index.
- `<codex-root>/sessions/`: exact traces, context, dates, cwd, and injected rules.

Search the index with targeted `rg`. Narrow session archives by timestamp and
cwd. Derive absolute dates from `ts` or `timestamp`.

Session dialogue carries intent, decisions, findings, and blockers. Tool traces
and current project state support verification.

## Machine State

Never read, copy, summarize, or expose `auth.json` or credential files.
Treat the following files as supporting evidence. Edit them only with explicit
authority:

- `config.toml`
- `rules/default.rules`
- `log*`
- `*.sqlite*`
- `models_cache.json`
- `version.json`
- `tmp/`
- `shell_snapshots/`
