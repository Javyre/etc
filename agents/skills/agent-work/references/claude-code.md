# Claude Code

Claude Code source layout for Agent Work mining.

Layout checked on 2026-10-05 with Claude Code 2.1.284. After upgrades, root
changes, or missing paths or fields, refresh affected entries from the
installation and [the docs](https://code.claude.com/docs). Then update this
stamp.

## Roots

- Claude Code root: `$CLAUDE_CONFIG_DIR` when set; `~/.claude` otherwise.
- A machine can run several roots, each with its own history. The user's
  instructions name them and say which ones you may read.

## Truth

- `<claude-root>/CLAUDE.md`: user instructions.
- `<claude-root>/skills/`: user skills.
- `<claude-root>/settings.json`: hooks, permissions, and environment.
- `<claude-root>/projects/<slug>/memory/MEMORY.md`: auto-memory, when enabled.
- Current project instructions and docs: project truth.

## History

- `<claude-root>/history.jsonl`: cheap index. One row per prompt: `display`,
  `timestamp` (epoch ms), `project`, `sessionId`.
- `<claude-root>/projects/<slug>/<session>.jsonl`: exact traces. `<slug>` is
  the working directory with `/` and `.` replaced by `-`.
- `<session>/subagents/*.jsonl`: subagent traces.
- `<session>/tool-results/`: tool output too large to inline.

Start with [`scripts/claude-log`](../scripts/claude-log); `-h` lists its views.
A view that leaves something out says so in a `#` footer. Write a new query
only for a question the views cannot answer.

Trace hazards for new queries (the script handles each):

- One assistant message spans several rows, one per content block. Count
  messages by `message.id`; sum content over rows.
- Subagent traces can log `usage` mid-stream, below the visible output.
- Tool results can hold base64 images. Count them apart from text.
- A message the user sends mid-turn is an `attachment` row of type
  `queued_command` with `origin.kind == "human"`, not a `user` row.
- `isMeta` user rows are harness-injected: skill loads, agent messages,
  scheduled prompts, image notes.
- A failed `capture` or other empty jq expression drops its whole row.
  Wrap it in an array.
- `continued-in` rows link a session to its continuation.

## Machine state

Never read, copy, summarize, or expose credentials or auth state. Edit
anything in the root only with explicit authority. Treat these as supporting
evidence:

- `daemon*`
- `sessions/`
- `session-env/`
- `shell-snapshots/`
- `file-history/`
