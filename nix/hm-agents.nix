{
  config,
  lib,
  inputs',
  ...
}:
let
  ln = config.lib.jv.ln;
  agentsMd = ln "agents/AGENTS.md";

  sharedSkills = lib.genAttrs [
    "agent-work"
    "code-work"
    "complete"
    "conflicts"
    "dream"
    "experiment"
    "grilling"
    "hindsight-prompt"
    "jv-review"
    "role-models"
    "standup"
    "unslop"
    "writing-artifacts"
    "writing-for-agents"
  ] (name: ln "agents/skills/${name}");
in
{
  imports = [ ./hm-claude.nix ];

  home.file = {
    ".codex/AGENTS.md".source = agentsMd;
  }
  // lib.mapAttrs' (
    name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
  ) sharedSkills;

  jv.claude = {
    enable = true;
    package = inputs'.llm-agents.packages.claude-code;
    refuseDefaultConfigDir = true;
    configDirs.personal = {
      bin = "claude-personal";
      dir = ".claude-personal";
      inherit agentsMd;
      skills = sharedSkills;
    };
    configDirs.work = {
      bin = "claude-work";
      dir = ".claude-work";
      inherit agentsMd;
      skills = sharedSkills;
    };
  };
}
