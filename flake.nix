{
  description = "Jv System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, lib, ... }:
      {
        imports = [
          ./nix/flake-parts-hm.nix
        ];

        # In case someone want's to use this :)
        # add this flake as an input to yours and then
        # ```nix
        # imports = [ inputs.<nameofinput>.flakeModules.hm ];
        # ```
        flake.flakeModules.hm = ./nix/flake-parts-hm.nix;

        # apply with `nix run .#apply-home`
        hm-configs."javyre@jv-mbpm3" = {
          system = "aarch64-darwin";
          module = {
            imports = [
              ./nix/hm-common.nix
              ./nix/hm-macos.nix
            ];
            home.username = "javyre";
            home.homeDirectory = "/Users/javyre";
          };
        };

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt-rfc-style;
          };
      }
    );
}
