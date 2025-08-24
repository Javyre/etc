{
  description = "Jv System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs?ref=master";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
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
      # url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, lib, ... }:
      {
        imports = [
          ./nix/flake-parts-hm.nix
          ./nix/flake-parts-os.nix
        ];

        # In case someone wants to use this :)
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

        hm-configs."jv@jv-vm" = {
          system = "aarch64-darwin";
          module = {
            imports = [
              ./nix/hm-common.nix
            ];
            home.username = "jv";
            home.homeDirectory = "/home/jv";
          };
        };

        # apply with `nix run .#apply-os`
        os-configs."jv-vm" = {
          system = "aarch64-linux";
          module = {
            imports = [
              ./nix/os-common.nix
            ];
          };
        };

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        perSystem =
          { system, pkgs, ... }:
          {
            formatter = pkgs.nixfmt-rfc-style;
            # packages.gen-qemu = inputs.nixos-generators.nixosGenerate {
            #   inherit system;
            #   # specialArgs = { inherit pkgs; };
            #   format = "qcow-efi";
            #   modules = [
            #     {
            #       # Pin nixpkgs to the flake input, so that the packages
            #       # installed come from the flake inputs.nixpkgs.url.
            #       nix.registry.nixpkgs.flake = inputs.nixpkgs;
            #       # set disk size to to 20G
            #       virtualisation.diskSize = 20 * 1024;
            #       # boot.binfmt.emulatedSystems = [ system ];
            #     }
            #     ./nix/nixos.nix
            #   ];
            # };
          };
      }
    );
}
