{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jv.codex;

  homeFiles =
    { dir, agentsMd, ... }:
    {
      "${dir}/AGENTS.md".source = agentsMd;
      # The daemon resolves current/bin/codex. Keep CLI and daemon on the Nix
      # package; Codex's updater only owns selections under
      # standalone/releases. Replace any current link left by the standalone
      # installer.
      "${dir}/packages/standalone/current" = {
        source = cfg.package;
        force = true;
      };
    };

  # Pin the state database to the home too; an inherited CODEX_SQLITE_HOME
  # would point every home at one database.
  wrapCodex =
    bin: codexHome:
    pkgs.runCommand bin { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
      mkdir -p $out/bin
      makeBinaryWrapper ${lib.getExe cfg.package} $out/bin/${bin} \
        --set CODEX_HOME ${lib.escapeShellArg codexHome} \
        --set CODEX_SQLITE_HOME ${lib.escapeShellArg codexHome}
    '';

  # Without CODEX_HOME, codex falls back to ~/.codex, so a bare `codex`
  # would silently run in whichever home that is.
  guardCodex = pkgs.writeShellApplication {
    name = "codex";
    text = ''
      if [ -z "''${CODEX_HOME:-}" ]; then
        echo "codex: CODEX_HOME unset; use a codex-* wrapper" >&2
        exit 64
      fi
      exec ${lib.getExe cfg.package} "$@"
    '';
  };

  homeModule = {
    options = {
      bin = lib.mkOption {
        type = lib.types.str;
        description = "Wrapper that runs Codex with this home.";
      };
      dir = lib.mkOption {
        type = lib.types.str;
        description = "CODEX_HOME, relative to the home directory.";
      };
      agentsMd = lib.mkOption {
        type = lib.types.path;
        description = "Linked as AGENTS.md.";
      };
    };
  };
in
{
  options.jv.codex = {
    enable = lib.mkEnableOption "Codex homes";
    package = lib.mkOption {
      type = lib.types.package;
    };
    refuseDefaultHome = lib.mkOption {
      type = lib.types.bool;
      description = "Install a `codex` that exits unless CODEX_HOME is set.";
    };
    # Each home has its own login, sessions and history.
    homes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule homeModule);
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.refuseDefaultHome guardCodex
      ++ lib.mapAttrsToList (_: h: wrapCodex h.bin "${config.home.homeDirectory}/${h.dir}") cfg.homes;

    home.file = lib.mkMerge (lib.mapAttrsToList (_: homeFiles) cfg.homes);
  };
}
