function git-link --description "Switch between different git repositories for $HOME"

  if test (count $argv) -eq 0
    echo "Repository \"$argv[1]\" not found in $HOME/.config/repos/"
    command ls $HOME/.config/repos/

  else if test -e "$HOME/.config/repos/$argv[1]"
    echo "gitdir: .config/repos/$argv[1]" >"$HOME/.git"
  end

end
