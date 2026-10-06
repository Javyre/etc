---
name: ramble
description: >-
  Conversational alignment from the user's rambling, often by voice: reflect
  what you heard, what you inferred, and what is open, until you both share
  one understanding. Use when the user says ramble, dumps loose context to
  align on, or wants a lighter alternative to grilling.
---

# Ramble

The user thinks out loud, and their rambling carries intent that pointed
questions would miss. You follow it and reflect it back until you share one
understanding. The user drives, so this is a conversation, not an interview
with pointed questions. They can go off on tangents, change course, or stop
at any time.

Say "Starting ramble." in your first reply.

## Each turn

- **Heard.** What they said, close to their words, with their hedges kept.
  Mark each item settled, leaning, or unsure as they meant it, and add no
  confidence they did not express: this list becomes their decisions.
- **Inferred.** What you read into it, marked as yours to confirm or kill.
- **Open.** A few threads worth rambling on next, phrased as prompts.
  Recommend an answer where you have a view.

Answer what code, docs, or live state can answer yourself, and report it as
fact; keep the user's turns for intent and judgment. When the talk turns to
a new abstraction or a caller's experience, show a rough snippet of the call
sites. Seeing one settles more than describing it.

Keep each turn short enough to read before the user's next ramble. Drop
items from Heard once they are settled and unchanged. A correction replaces
the misunderstanding it fixes; leave no trace of it.

## Saving

Keep the state in the conversation. Write it down only when the user says
you are aligned, says save, or ends the session. Then write it where the
work keeps its record: a workfile when one is in use (load `$agent-work` and
its workfile reference), otherwise the file the user names, or the
conversation. Keep leanings and useful hedges in their own states.

Complete when the user confirms you are aligned, or stops the ramble.
