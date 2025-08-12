{
  pkgs,
  config,
  lib,
  ...
}:
let
  ln = config.lib.jv.ln;
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
  ];

  # xdg.configFile."yabai".source = ln "yabai";
  xdg.configFile."skhd".source = ln "skhd";
  xdg.configFile."aerospace".source = ln "aerospace";
}
