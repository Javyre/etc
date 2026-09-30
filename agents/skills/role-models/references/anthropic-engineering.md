# Anthropic Engineering

Reach for when:
- studying agent patterns from primary-source production work
- studying tool ergonomics
- studying multi-agent orchestration under production constraints
- studying agent evals and long-run harness concerns
- scoping writing guidance for human readers (`anthropics/skills`)

Transferable patterns:
- start simple and compose late
- tool design is often agent design
- use multiple agents for clean breadth or context splits. Keep one agent as the
  default
- design evals, traces, and delegation quality intentionally
- one skill per communication family, one guideline file per type, loaded after
  the type is identified; each type carries a reading-time budget
  (`internal-comms`: 3P updates "30-60sec or less")
- ask for the primary audience and desired impact first; test the draft on a
  fresh reader with no context (`doc-coauthoring`)

Watch:
- vendor/runtime bias
- some multi-agent lessons come from research workload shape, not all coding tasks

Orientation reads:
- https://www.anthropic.com/engineering/building-effective-agents
- https://www.anthropic.com/engineering/writing-tools-for-agents
- https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- https://github.com/anthropics/skills/blob/main/skills/internal-comms/SKILL.md
- https://github.com/anthropics/skills/blob/main/skills/doc-coauthoring/SKILL.md

Code or systems reads:
- https://www.anthropic.com/engineering/built-multi-agent-research-system
- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
