{
  pkgs,
  userName,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix = {
    enable = true;

    # Do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      interval = {
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;

    # Auto upgrade nix package
    package = pkgs.lix;

    settings = {
      allow-dirty = true;
      always-allow-substitutes = true;
      builders-use-substitutes = true;

      # Enable flakes globally
      experimental-features = ["nix-command" "flakes"];
      keep-outputs = true;
      keep-derivations = true;

      max-jobs = "auto";

      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://dsully.cachix.org"
        "https://ryanccn.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "dsully.cachix.org-1:smJ/u8VCUmfyavfuZBNXhXhPDfryFeo+vhYT0BPEIQo="
        "ryanccn.cachix.org-1:Or82F8DeVLJgjSKCaZmBzbSOhnHj82Of0bGeRniUgLQ="
      ];

      trusted-users = [
        "@admin"
        "@wheel"
        userName
      ];
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
  };
}
