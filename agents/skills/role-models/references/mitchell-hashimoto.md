# Mitchell Hashimoto

## Agentic engineering context

Reach for when:
- studying the adoption path from chat to a repeatable agent workflow
- studying task shaping and the planning/execution split
- studying harness-first pragmatism
- studying when to trust background autonomy and when not to
- deciding what a human must understand before shipping agent-written code

Transferable patterns:
- stop using chat as the default coding interface
- reproduce your own work first
- give agents strong verification paths
- repeated misses should graduate into harness improvements
- whiteboard defense: for shipped work, the human can explain how it works
  and defend its decisions (why X over Y, where it fails, what a malicious
  actor does) without the agent; line-level recall is not the bar, and
  throwaway work is exempt

Watch:
- narrower corpus than Simon or Birgitta
- use more for workflow shaping than for broad theory

Orientation reads:
- https://mitchellh.com/writing/my-ai-adoption-journey
- https://mitchellh.com/writing/non-trivial-vibing
- https://x.com/mitchellh/status/2100249348345057389 (whiteboard defense)
- https://github.com/ghostty-org/ghostty/blob/main/AI_POLICY.md

## Zig context

Reach for when:
- studying large native app architecture in Zig
- studying cross-platform seams, runtime splits, and FFI boundaries
- studying practical Zig patterns under product pressure
- studying high-level APIs that still keep lower seams reachable

Transferable patterns:
- keep platform-specific ugliness below explicit seams
- use Zig for large apps without hiding system truths
- pair ergonomic top-level APIs with lower-level escape hatches
- make docs and the build configuration reflect platform constraints

Watch:
- easiest to overfit terminal or GUI structure instead of seam and boundary ideas

Orientation reads:
- https://mitchellh.com/zig
- https://mitchellh.com/writing/ghostty-is-coming

Code reads:
- https://github.com/ghostty-org/ghostty
- https://github.com/mitchellh/libxev
