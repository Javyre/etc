{
  pkgs,
  config,
  lib,
  ...
}:
let
  ln = config.lib.jv.ln;
  xnu = pkgs.apple-sdk.sourceRelease "xnu";
  crap = pkgs.stdenv.mkDerivation {
    pname = "crap";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "D-Berg";
      repo = "crap";
      rev = "9c5f83b8776af387c2cd355ab74049fbd0934b86";
      hash = "sha256-IVI1utI+l5eCSzcxibKj89RzgiXRKeEZINhF1Ok2EJw=";
    };

    nativeBuildInputs = [ pkgs.zig_0_16 ];
    buildInputs = [ pkgs.apple-sdk ];

    meta = {
      description = "Counter Reading Acquisition Platform";
      homepage = "https://github.com/D-Berg/crap";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
      mainProgram = "crap";
    };
  };
  lauka = pkgs.stdenv.mkDerivation {
    pname = "lauka";
    version = "unstable-2026-01-12";

    src = pkgs.fetchFromGitHub {
      owner = "verte-zerg";
      repo = "lauka";
      rev = "f6c55ff9bcb1392535df50f62508cd9e2b9c5f5a";
      hash = "sha256-TC+UPBCvy1z/ALdF+fa75x6t+57IKsO5pOzDAfij/oY=";
    };

    nativeBuildInputs = [ pkgs.zig_0_15 ];
    buildInputs = [ pkgs.apple-sdk ];

    # HACK: nix zig drops the xnu include path for @cImport, so patch build.zig to add it.
    postPatch = ''
      substituteInPlace build.zig \
        --replace-fail '    exe_mod.addSystemFrameworkPath(kperf_path);' \
        '    exe_mod.addSystemFrameworkPath(kperf_path);
            exe_mod.addIncludePath(.{ .cwd_relative = "${xnu}/bsd" });'
    '';

    dontSetZigDefaultFlags = true;
    zigBuildFlags = [ "--release=fast" ];

    meta = {
      description = "Apple Silicon PMU counter benchmark";
      homepage = "https://github.com/verte-zerg/lauka";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
      mainProgram = "lauka";
    };
  };
in
{
  home.packages = with pkgs; [
    iina
    # yabai
    skhd
    skimpdf
    # TODO: check out the aerospace support in home-manager
    aerospace
    # jankyborders
    raycast
    crap
    lauka
  ];

  # xdg.configFile."yabai".source = ln "yabai";
  xdg.configFile."skhd".source = ln "skhd";
  xdg.configFile."aerospace".source = ln "aerospace";
}
