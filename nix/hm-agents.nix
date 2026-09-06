{ config, ... }:
let
  ln = config.lib.jv.ln;
in
{
  home.file = {
    ".codex/AGENTS.md".source = ln "agents/AGENTS.md";

    ".agents/skills/agent-work".source = ln "agents/skills/agent-work";
    ".agents/skills/code-work".source = ln "agents/skills/code-work";
    ".agents/skills/complete".source = ln "agents/skills/complete";
    ".agents/skills/conflicts".source = ln "agents/skills/conflicts";
    ".agents/skills/dream".source = ln "agents/skills/dream";
    ".agents/skills/experiment".source = ln "agents/skills/experiment";
    ".agents/skills/grilling".source = ln "agents/skills/grilling";
    ".agents/skills/hindsight-prompt".source = ln "agents/skills/hindsight-prompt";
    ".agents/skills/jv-review".source = ln "agents/skills/jv-review";
    ".agents/skills/role-models".source = ln "agents/skills/role-models";
    ".agents/skills/standup".source = ln "agents/skills/standup";
    ".agents/skills/unslop".source = ln "agents/skills/unslop";
    ".agents/skills/writing-artifacts".source = ln "agents/skills/writing-artifacts";
    ".agents/skills/writing-for-agents".source = ln "agents/skills/writing-for-agents";
  };
}
