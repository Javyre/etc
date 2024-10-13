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
    hm-configs = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            system = mkOption {
              type = types.str;
            };
            module = mkOption {
              type = types.deferredModule;
              description = ''
                Home-Manager configuration module.
                This forwards flake-parts' module args as extraSpecialArgs.
              '';
            };
          };
        }
      );
    };
  };
  config = {
    flake.homeConfigurations = (
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
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit
                self
                inputs
                self'
                inputs'
                system
                ;
            };
            modules =
              (lib.optionals ((builtins.match ".*-darwin" system) != null) [
                inputs.mac-app-util.homeManagerModules.default

              ])
              ++ [ value.module ];
          }
        )
      ) config.hm-configs
    );

    perSystem =
      { pkgs, inputs', ... }:
      {
        packages =
          let
            home-manager = inputs'.home-manager.packages.default;
          in
          {
            inherit home-manager;
            apply-home = pkgs.writeShellApplication {
              name = "apply-home";
              runtimeInputs = [ home-manager ];
              text = ''
                home-manager switch --flake "${self}" "$@"
              '';
            };
          };
      };
  };
}
