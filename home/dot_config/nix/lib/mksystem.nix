{
  nixpkgs,
  overlays,
  inputs,
}: hostname: {
  system,
  user,
  darwin ? false,
}: let
  # The config files for this system.
  machineConfig = ../machines/${hostname}.nix;

  userOSConfig =
    ../users/${user}/${
      if darwin
      then "darwin"
      else "nixos"
    }.nix;

  userHMConfig = ../users/${user}/home-manager.nix;

  globals = {
    # FIXME
    hostname = "jarvis";
    user = "dsully"; # builtins.getEnv "USER";
  };

  # NixOS vs nix-darwin functions
  systemFunc =
    if darwin
    then inputs.nix-darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;

  home-manager =
    if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;
in
  systemFunc {
    inherit system;

    specialArgs =
      inputs
      // {
        inherit globals;
      };

    modules = [
      # Apply our overlays. Overlays are keyed by system type so we have
      # to go through and apply our system type. We do this first so
      # the overlays are available globally.
      {nixpkgs.overlays = overlays;}

      ./nix-core.nix
      ./packages.nix

      machineConfig
      userOSConfig

      home-manager.home-manager
      {
        home-manager = {
          # useGlobalPkgs = true;
          # useUserPackages = true;
          users.${user} = import userHMConfig {
            inherit inputs;
          };
        };
      }

      # Expose some extra arguments so that our modules can parameterize better based on these values.
      {
        config._module.args = {
          inherit hostname user inputs;
        };
      }
    ];
  }
