# Claude Code

Claude Code source layout for Agent Work mining.

Layout checked on 2026-10-05 with Claude Code 2.1.284. After upgrades, root
changes, or missing paths or fields, refresh affected entries from the
installation and [the docs](https://code.claude.com/docs). Then update this
stamp.

## Roots

- Config root: `$CLAUDE_CONFIG_DIR` when set; `~/.claude` otherwise.
- A machine can run several roots, each with its own history. The user's
  instructions name them; mine every root the scope covers.

## Truth

- `<root>/CLAUDE.md`: user instructions.
- `<root>/skills/`: user skills.
- `<root>/settings.json`: hooks, permissions, and environment.
- Current project instructions and docs: project truth.

## History

- `<root>/history.jsonl`: cheap index. One row per prompt: `display`,
  `timestamp` (epoch ms), `project`, `sessionId`.
- `<root>/projects/<slug>/<session>.jsonl`: exact traces. `<slug>` is the
  working directory with `/` and `.` replaced by `-`.
- `<session>/subagents/*.jsonl`: subagent traces.
- `<session>/tool-results/`: tool output too large to inline.

Start with [`scripts/claude-log`](../scripts/claude-log). It covers the index,
prompts, tool calls with result sizes, and token usage. Write a new query only
for a question it cannot answer.

Trace hazards:

- One assistant message spans several rows that repeat its `usage`.
  Deduplicate by `message.id` before summing.
- Tool results can hold base64 images. Count them apart from text.
- `isMeta` user rows are harness notes, not prompts.

## Machine state

Never read, copy, summarize, or expose credentials or auth state. Treat
`settings.json`, `daemon*`, `sessions/`, `session-env/`, `shell-snapshots/`,
and `file-history/` as supporting evidence. Edit them only with explicit
authority.
