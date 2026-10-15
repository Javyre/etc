{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jv.claude;

  linkSkills =
    dir: skills:
    lib.mapAttrs' (name: source: lib.nameValuePair "${dir}/${name}" { inherit source; }) skills;

  homeFiles =
    {
      dir,
      agentsMd,
      skills,
      ...
    }:
    { "${dir}/CLAUDE.md".source = agentsMd; } // linkSkills "${dir}/skills" skills;

  wrapClaude =
    package: bin: claudeHome:
    pkgs.runCommand bin { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
      mkdir -p $out/bin
      makeBinaryWrapper ${lib.getExe package} $out/bin/${bin} \
        --set CLAUDE_CONFIG_DIR ${lib.escapeShellArg claudeHome}
    '';

  # If ~/.claude reappears, something bypassed this.
  guardClaude =
    package:
    pkgs.writeShellApplication {
      name = "claude";
      text = ''
        if [ -z "''${CLAUDE_CONFIG_DIR:-}" ]; then
          echo "claude: CLAUDE_CONFIG_DIR unset; use a claude-* wrapper" >&2
          exit 64
        fi
        exec ${lib.getExe package} "$@"
      '';
    };

  homeModule = {
    options = {
      bin = lib.mkOption {
        type = lib.types.str;
        description = "Wrapper that runs Claude Code with this home.";
      };
      dir = lib.mkOption {
        type = lib.types.str;
        description = "CLAUDE_CONFIG_DIR, relative to the home directory.";
      };
      agentsMd = lib.mkOption {
        type = lib.types.path;
        description = "Linked as CLAUDE.md.";
      };
      skills = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        description = "Skill name to source, linked under skills/.";
      };
    };
  };
in
{
  options.jv.claude = {
    enable = lib.mkEnableOption "Claude Code homes";
    package = lib.mkOption {
      type = lib.types.package;
    };
    refuseDefaultHome = lib.mkOption {
      type = lib.types.bool;
      description = "Install a `claude` that exits unless CLAUDE_CONFIG_DIR is set.";
    };
    # Each home has its own login, sessions and history.
    homes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule homeModule);
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.refuseDefaultHome (guardClaude cfg.package)
      ++ lib.mapAttrsToList (
        _: h: wrapClaude cfg.package h.bin "${config.home.homeDirectory}/${h.dir}"
      ) cfg.homes;

    # Each home needs its own dir. Two that share one, with the same
    # sources, merge silently into one login and history.
    home.file = lib.mkMerge (lib.mapAttrsToList (_: homeFiles) cfg.homes);
  };
}
