{inputs, ...}: {
  #
  # See here what bumping this value impacts:
  # https://nix-community.github.io/home-manager/release-notes.xhtml
  home.stateVersion = "25.05";

  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./home-manager/bat.nix
  ];

  programs = {
    # https://github.com/me-and/nixcfg/blob/689c91c8f5bdd7bed0d95ba2c85f6466d8b7452f/nixos/common/nix-index.nix#L11
    command-not-found.enable = false;

    # direnv = {
    #   enable = true;
    #   nix-direnv.enable = true;
    # };

    # generate index with: nix-index --filter-prefix '/bin/'
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
      enableFishIntegration = true;
    };

    # Fish plugins:
    #
    # * https://github.com/shanyouli/nur-packages/blob/a7cf65f573baa8d6e655f42adedff17a8014935d/pkgs/fish/fisher.nix#L27
    # * https://github.com/bswrundquist/dotfiles/blob/f51c42c7e4b1c9d27f2ce81281e58bdccb5fb766/home/fish.nix#L9
    # * https://github.com/awalker/nixos-config/blob/943d50e5e1e545719e6933221255c14b0a60fdbc/home.nix#L84

    # yt-dlp = {
    #   enable = true;
    #   settings = {
    #     embed-metadata = true;
    #     sponsorblock-mark = "all";
    #   };
    # };
  };
}
