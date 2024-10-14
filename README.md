# jv-etc

## Installing

1. Install nix using the [installer](https://github.com/DeterminateSystems/nix-installer).
2. Clone this repo to `~/etc`.
3. Run `nix run ~/etc#apply-home`.

## Updating

1. Update some configs / pull this repo.
2. Run `nix run ~/etc#apply-home`.

## hm-configs

This is a small util to reduce the boilerplate to define home-manager
configurations in a flake-parts flake.

To use this util in your flake-parts flake, add this repo as an input and then:
```nix
# ...
outputs = inputs@{ ... }:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ inputs.<nameofinput>.flakeModules.hm ];

    hm-configs."<config name>" = {
        system = "<system>";
        module = {
            # your home-manager config module body here.
        };
    };

    # ...
  };
```
