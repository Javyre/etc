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
    yabai
    skhd
  ];

  xdg.configFile."yabai".source = ln "yabai";
  xdg.configFile."skhd".source = ln "skhd";
}
