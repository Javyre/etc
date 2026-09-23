{ config, ... }:
let
  ln = config.lib.jv.ln;

  skill-ln = name: {
    ".agents/skills/${name}".source = ln "agents/skills/${name}";
    ".claude/skills/${name}".source = ln "agents/skills/${name}";
  };
in
{
  home.file = {
    ".codex/AGENTS.md".source = ln "agents/AGENTS.md";
    ".claude/CLAUDE.md".source = ln "agents/AGENTS.md";
  }
  // skill-ln "agent-work"
  // skill-ln "code-work"
  // skill-ln "complete"
  // skill-ln "conflicts"
  // skill-ln "dream"
  // skill-ln "experiment"
  // skill-ln "grilling"
  // skill-ln "hindsight-prompt"
  // skill-ln "jv-review"
  // skill-ln "role-models"
  // skill-ln "standup"
  // skill-ln "unslop"
  // skill-ln "writing-artifacts"
  // skill-ln "writing-for-agents";
}
