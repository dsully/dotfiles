{
  lib,
  pkgs,
  ...
}: {
  environment = {
    pathsToLink = ["/share/fish"];
    shells = [pkgs.fish];
    systemPackages = with pkgs; let
      mine = [
        devmoji-log
        lolcate-rs
        magic-opener
      ];

      forked = [
        git-trim
        safari-rs
      ];

      custom = [
        apple-photos-export
        autorebase
        dirstat-rs
        feluda
        # geil
        reading-list-to-pinboard-rs
        # werk
      ];

      nix = [
        deadnix
        flake-checker
        # nix-du
        nh
        nix-init
        nix-tree
        nix-update
        nixpkgs-lint
        nix-output-monitor
        statix
      ];

      rust = [
        bacon
        cargo-autoinherit
        cargo-binstall
        cargo-bloat
        cargo-cache
        cargo-clone
        cargo-dist
        cargo-duplicates
        cargo-features-manager
        cargo-insta
        cargo-llvm-lines
        cargo-msrv
        cargo-nextest
        cargo-run-bin
        cargo-shear
        cargo-sweep
        cargo-tarpaulin
        cargo-unused-features
        cargo-update
        cargo-wizard

        rust-bin.stable.latest.default
        # rust-bin.nightly.latest.default

        # (fenix.stable.withComponents [
        #   "cargo"
        #   "clippy"
        #   "rust-analyzer"
        #   # "rust-src"
        #   "rustc"
        #   "rustfmt"
        # ])

        rustcat
        sccache
      ];

      python = [
        instaloader
        ruff
        rye
        uv
        # yt-dlp
      ];

      files = [
        b3sum
        bat
        choose
        dasel
        delta
        dua
        dust
        fclones
        fd
        fselect
        gnutar
        gomi
        hexyl
        kondo
        lsd
        moar
        p7zip
        ripgrep
        rnr
        rsync
        sd
        see-cat
        tree
        unar
        unzip
        viu
        xcp
        xz
      ];

      shell = [
        chezmoi
        direnv
        fish
        fzf
        just
        macchina
        starship
        topgrade
        zellij
        zoxide
      ];

      network = [
        act
        age
        aichat
        bandwhich
        bombardier
        checkip
        croc
        curl
        inetutils
        iperf3
        ipmitool
        mtr
        nextdns
        nur.repos.caarlos0.xdg-open-svc
        q
        sniffnet
        wget
        xh
      ];

      system = [
        btop
        procs
      ];

      development = [
        better-commits # git bc
        claude-code
        cyme
        fork-cleaner
        fx
        gh
        ghq
        gibo
        git
        git-ai-commit
        git-dive
        git-ignore
        git-lfs
        git-quick-stats
        git-sizer
        glow
        gnused
        go
        gofumpt
        gotools
        gron
        helix
        jq
        kickstart
        nodejs
        scc
        sq
        sqlite
        tree-sitter
        turbo-commit
        typos
        vivid
        xan
        yek
        yq
        zig
      ];

      editor = [
        # inputs.emmylua-analyzer.packages.${pkgs.system}.default

        actionlint
        alejandra
        ast-grep
        basedpyright
        bash-language-server
        biome
        buildifier
        ccls
        codesort
        commitlint-rs
        dockerfile-language-server-nodejs
        fish-lsp
        ghostty-ls
        github-actions-languageserver
        gitui
        gofumpt
        gopls
        gotools
        harper
        imagemagick
        jinja-lsp
        lemminx
        # lua-language-server
        luajit
        markdownlint-cli2
        marksman
        mermaid-cli
        neovim
        nil
        nixd
        nixpkgs-fmt
        pkl-lsp
        protolint
        pyproject-fmt
        revive
        rstcheck
        ruff
        shellharden
        shfmt
        sith-language-server
        sphinx-lint
        stylelint
        stylua
        superhtml
        systemd-language-server
        taplo
        ts_query_ls
        typos
        vscode-langservers-extracted
        vtsls
        write-good
        xmlformatter
        yaml-language-server
        yamllint
        zls

        ghostscript_headless
        tectonic-unwrapped
      ];

      macos = lib.optionals stdenv.isDarwin [
        cachix
        morlana
        # mas
      ];

      linux =
        lib.optionals stdenv.isLinux [
        ];
    in
      mine
      ++ custom
      ++ development
      ++ editor
      ++ files
      ++ forked
      ++ linux
      ++ macos
      ++ network
      ++ nix
      ++ python
      ++ rust
      ++ shell
      ++ system;
  };

  programs = {
    fish.enable = true;
  };
}
