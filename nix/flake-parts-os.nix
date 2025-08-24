{
  config,
  withSystem,
  lib,
  self,
  inputs,
  ...
}:
{
  options = with lib; {
    os-configs = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            system = mkOption {
              type = types.str;
            };
            module = mkOption {
              type = types.deferredModule;
              description = ''
                NixOS configuration module.
                This forwards flake-parts' module args as specialArgs.
              '';
            };
          };
        }
      );
    };
  };
  config = {
    flake.nixosConfigurations = (
      builtins.mapAttrs (
        name: value:
        withSystem value.system (
          {
            pkgs,
            system,
            self',
            inputs',
            ...
          }:
          pkgs.lib.nixosSystem {
            inherit pkgs;
            specialArgs = {
              inherit
                self
                inputs
                self'
                inputs'
                system
                ;
            };
            modules = [ value.module ];
          }
        )
      ) config.os-configs
    );

    perSystem =
      { pkgs, inputs', ... }:
      {
        packages =
          {
            inherit (pkgs) nixos-rebuild;
            apply-os = pkgs.writeShellApplication {
              name = "apply-os";
              runtimeInputs = [ pkgs.nixos-rebuild ];
              text = ''
                nixos-rebuild switch --flake "${self}" "$@"
              '';
            };
          };
      };
  };
}
