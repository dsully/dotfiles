{pkgs, ...}: {
  system.stateVersion = 6;

  # security.pam.services.sudo_local.touchIdAuth = true;

  # programs.fish.enable = true;
  #programs.fish.shellInit = ''
  #  # Nix
  #  if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
  #    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
  #  end
  #  # End Nix
  #'';

  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  #programs.zsh.enable = true;
  #programs.zsh.shellInit = ''
  #  # Nix
  #  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  #    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  #  fi
  #  # End Nix
  #'';

  environment.shells = with pkgs; [bashInteractive zsh fish];
}
