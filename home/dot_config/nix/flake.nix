{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # home-manager, used for managing user configuration
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index.url = "github:nix-community/nix-index";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # rust-overlay.url = "github:nix-community/fenix";
    # rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    dsully.url = "git+file:///Users/dsully/dev/home/nur";
    # dsully.url = "github:dsully/nur";
    dsully.inputs.nixpkgs.follows = "nixpkgs";

    # emmylua-analyzer.url = "github:CppCXY/emmylua-analyzer-rust";
    # emmylua-analyzer.inputs.nixpkgs.follows = "nixpkgs";
    morlana.url = "github:ryanccn/morlana";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  }: let
    # Common overlays for all systems
    commonOverlays = [
      inputs.neovim-nightly-overlay.overlays.default
      inputs.nur.overlays.default
      inputs.dsully.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.morlana.overlays.default
    ];

    # Default username (can be overridden per host)
    defaultUserName = "dsully";

    # Generic function to create system configurations
    mkSystem = {
      system,
      userName ? defaultUserName,
      extraModules ? [],
      extraOverlays ? [],
    }: hostName: let
      isDarwin = builtins.match ".*-darwin" system != null;

      # Select the appropriate system function based on isDarwin
      systemFunc =
        if isDarwin
        then inputs.nix-darwin.lib.darwinSystem
        else nixpkgs.lib.nixosSystem;

      # Select the appropriate home-manager module based on isDarwin
      hmModule =
        if isDarwin
        then home-manager.darwinModules.home-manager
        else home-manager.nixosModules.home-manager;

      # Select the appropriate OS-specific user config
      osConfig =
        ./users/${userName}/${
          if isDarwin
          then "darwin"
          else "nixos"
        }.nix;
    in
      systemFunc {
        inherit system;

        specialArgs = {
          inherit system userName hostName inputs isDarwin;
        };

        modules =
          [
            {nixpkgs.overlays = commonOverlays ++ extraOverlays;}
            ./lib/nix-core.nix
            ./lib/packages.nix

            ./machines/${hostName}.nix

            osConfig
            hmModule
            {
              home-manager = {
                users.${userName} = import ./users/${userName}/home-manager.nix {
                  inherit inputs;
                };
              };
            }
          ]
          ++ extraModules;
      };

    mkDarwin = args: hostName:
      mkSystem (args // {system = args.system or "aarch64-darwin";}) hostName;

    mkNixOS = args: hostName:
      mkSystem (args // {system = args.system or "x86_64-linux";}) hostName;

    mkDarwinConfigurations = hosts:
      builtins.listToAttrs (map
        (hostName: {
          name = hostName;
          value = mkDarwin {} hostName;
        })
        hosts);

    mkNixOSConfigurations = hosts:
      builtins.listToAttrs (map
        (hostName: {
          name = hostName;
          value = mkNixOS {} hostName;
        })
        hosts);
  in {
    darwinConfigurations = mkDarwinConfigurations ["jarvis"];

    nixosConfigurations = mkNixOSConfigurations ["server" "zap"];
  };
}
