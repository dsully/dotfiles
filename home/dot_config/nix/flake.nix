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

    # Homebrew + Declarative tap management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    # emmylua-analyzer.url = "github:CppCXY/emmylua-analyzer-rust";
    # emmylua-analyzer.inputs.nixpkgs.follows = "nixpkgs";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {nixpkgs, ...}: let
    # username = "dsully";
    # useremail = "dsully@users.noreply.github.com";
    # supportedSystems = [
    #   "aarch64-darwin"
    #   "x86_64-linux"
    # ];
    globals = {
      # FIXME
      hostname = "jarvis";
      user = "dsully"; # builtins.getEnv "USER";
    };

    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
      inputs.nur.overlays.default
      inputs.dsully.overlays.default
      inputs.rust-overlay.overlays.default

      # Until upstream has merged my PR.
      (_final: prev: {
        cargo-clone = prev.cargo-clone.overrideAttrs (oldAttrs: {
          buildInputs = (oldAttrs.buildInputs or []) ++ [prev.zlib];
        });
      })
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit nixpkgs overlays inputs;
    };
  in {
    darwinConfigurations.jarvis = mkSystem "jarvis" {
      system = "aarch64-darwin";
      inherit (globals) user;
      darwin = true;
    };
  };
}
