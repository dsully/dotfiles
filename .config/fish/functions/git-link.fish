function git-link --description="Switch between different git repositories for $HOME"

  if [ -n "$1" ] && [ -e "$HOME/.config/repos/$1" ]
    echo "gitdir: .config/repos/$1" >"$HOME/.git"
  else
    echo "Repository \"$1\" not found in $HOME/.config/repos/"
    ls $HOME/.config/repos/
  end

end
