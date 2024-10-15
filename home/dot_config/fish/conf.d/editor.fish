if status is-interactive

    # Set VSCode to use itself if inside the VSCode terminal.
    if string match -q "$TERM_PROGRAM" vscode
        set -gx EDITOR code --wait

    else if command -q nvim
        abbr --add vi nvim
        abbr --add vim nvim
        abbr --add view 'nvim -R'

        set -gx EDITOR nvim

    else if command -q vim
        set -gx EDITOR vim
    else
        set -gx EDITOR vi
    end

    set -gx VISUAL $EDITOR
end
