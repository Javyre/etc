---
name: complete
description: Draft a boring completion at a COMPL anchor.
disable-model-invocation: true
---

# Complete

`COMPL: <description>` marks a requested code completion. Infer its extent from
its placement, description, and surrounding code.

On `$complete`, inspect the relevant code and draft the completion in chat. Show
its `./path:line` and exact diff.

Keep inspection proximal. Read outward until the proposed names and APIs are
defined and local types, contracts, control flow, and conventions support the
diff.
Research only when a missing fact can change it. Then stop.

Make the result boring and predictable. Follow the request and nearest local
shapes. Prefer the smallest behavior and diff supported by the evidence. Expose
any remaining choice instead of guessing.

Use source inspection for confidence. Builds, tests, and PoCs require an explicit
request.

On `apply`, recheck the target, then apply the latest draft if it still matches.
If the target changed, refresh the draft first.
