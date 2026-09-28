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

  configDirFiles =
    {
      dir,
      agentsMd,
      skills,
      ...
    }:
    { "${dir}/CLAUDE.md".source = agentsMd; } // linkSkills "${dir}/skills" skills;

  wrapClaude =
    package: bin: configDir:
    pkgs.runCommand bin { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
      mkdir -p $out/bin
      makeBinaryWrapper ${lib.getExe package} $out/bin/${bin} \
        --set CLAUDE_CONFIG_DIR ${lib.escapeShellArg configDir}
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

  configDirModule = {
    options = {
      bin = lib.mkOption {
        type = lib.types.str;
        description = "Wrapper that runs Claude Code with this config dir.";
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
    enable = lib.mkEnableOption "Claude Code config dirs";
    package = lib.mkOption {
      type = lib.types.package;
    };
    refuseDefaultConfigDir = lib.mkOption {
      type = lib.types.bool;
      description = "Install a `claude` that exits unless CLAUDE_CONFIG_DIR is set.";
    };
    # Each config dir has its own login, sessions and history.
    configDirs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule configDirModule);
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.refuseDefaultConfigDir (guardClaude cfg.package)
      ++ lib.mapAttrsToList (
        _: d: wrapClaude cfg.package d.bin "${config.home.homeDirectory}/${d.dir}"
      ) cfg.configDirs;

    # mkMerge, not //, so two config dirs that claim one path fail loudly.
    home.file = lib.mkMerge (lib.mapAttrsToList (_: configDirFiles) cfg.configDirs);
  };
}
