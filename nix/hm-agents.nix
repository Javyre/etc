{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  # HACK: codex-nix omits the voice runtime. No upstream issue or PR exists yet.
  #       Remove this override once codex-nix includes the complete package.
  #       Keep the CLI, voice helper, and native libraries from one release;
  #       voice discovery requires the package's physical layout and metadata.
  codexBin =
    let
      codex = inputs'.codex-nix.packages.default;
      version = "0.162.1";
      platform = pkgs.stdenv.hostPlatform;
      hashes = {
        "0.162.1" = {
          aarch64-darwin = "sha256-iON8zd9aD06p3BvhPGaiqU+cLRoE86zpBT1xs5OeiF0=";
        };
      };
      target = "${platform.parsed.cpu.name}-apple-darwin";
    in
    if !platform.isDarwin then
      codex
    else
      codex.overrideAttrs (_: {
        inherit version;
        src = pkgs.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-package-${target}.tar.gz";
          hash = hashes.${version}.${platform.system};
        };
        codeModeHostSrc = null;
        installPhase = ''
          runHook preInstall
          mkdir -p "$out"
          cp -R bin codex-package.json codex-path codex-resources "$out/"
          runHook postInstall
        '';
      });
  ln = config.lib.jv.ln;
  agentsMd = ln "agents/AGENTS.md";

  sharedSkills = lib.genAttrs [
    "agent-work"
    "briefing"
    "code-work"
    "complete"
    "conflicts"
    "dream"
    "experiment"
    "grilling"
    "hindsight-prompt"
    "jv-review"
    "ramble"
    "role-models"
    "standup"
    "typesetting"
    "unslop"
    "writing-for-agents"
    "writing-for-humans"
  ] (name: ln "agents/skills/${name}");
in
{
  imports = [
    ./hm-claude.nix
    ./hm-codex.nix
  ];

  home.file = lib.mapAttrs' (
    name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
  ) sharedSkills;

  jv.codex = {
    enable = true;
    package = codexBin;
    refuseDefaultHome = true;
    homes.personal = {
      bin = "codex-personal";
      dir = ".codex-personal";
      inherit agentsMd;
    };
    homes.work = {
      bin = "codex-work";
      dir = ".codex-work";
      inherit agentsMd;
    };
  };

  jv.claude = {
    enable = true;
    package = inputs'.llm-agents.packages.claude-code;
    refuseDefaultHome = true;
    homes.personal = {
      bin = "claude-personal";
      dir = ".claude-personal";
      inherit agentsMd;
      skills = sharedSkills;
    };
    homes.work = {
      bin = "claude-work";
      dir = ".claude-work";
      inherit agentsMd;
      skills = sharedSkills;
    };
  };
}
