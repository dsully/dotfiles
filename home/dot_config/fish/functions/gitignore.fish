# command -v gibo >/dev/null 2>&1
#
# # Add arguments to add one or more files.
#
# function gitignore -d "Generate .gitignore with incremental search"
#
#     if test "$OS" = Darwin
#         set cache $HOME/Library/Caches/gibo/gitignore-boilerplates
#     else
#         set cache $XDG_CACHE_DIR/gibo/gitignore-boilerplates
#     end
#
#     command gibo list | fzf --multi --preview "bat --color=always $cache/{}.gitignore" | xargs gibo dump >>./.gitignore
# end
#
# command -v gibo >/dev/null 2>&1

function gitignore -d "Generate .gitignore with incremental search or add files/directories"
    # Find the git root directory
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)

    if test -z "$git_root"
        echo "Error: Not in a git repository" >&2
        return 1
    end

    if not command -q gibo
        echo "Error: 'gibo' is not installed: https://github.com/simonwhitaker/gibo"
        return 1
    end

    set -l gitignore_file "$git_root/.gitignore"

    # No arguments: use fzf interface
    if test (count $argv) -eq 0
        if test "$OS" = Darwin
            set cache $HOME/Library/Caches/gibo/gitignore-boilerplates
        else
            set cache $XDG_CACHE_DIR/gibo/gitignore-boilerplates
        end

        command gibo list | fzf --multi --preview "bat --color=always $cache/{}.gitignore" | xargs gibo dump >>"$gitignore_file"

        return 0
    end

    # Arguments provided: check if they're files/directories or gibo templates
    set -l files_to_add
    set -l templates_to_add

    for arg in $argv
        if test -e "$arg"
            # It's a file or directory that exists
            set -a files_to_add $arg
        else
            # Check if it's a valid gibo template
            if command gibo search "$arg" 2>/dev/null | grep -q "^$arg\$"
                set -a templates_to_add $arg
            else
                echo "Warning: '$arg' is not a file/directory or valid gibo template, skipping..." >&2
            end
        end
    end

    # Add files/directories to .gitignore
    if test (count $files_to_add) -gt 0
        for file in $files_to_add
            # Get the relative path from git root
            set -l relative_path (realpath --relative-to="$git_root" "$file" 2>/dev/null; or echo "$file")

            echo "$relative_path" >>"$gitignore_file"

            echo "Added to .gitignore: $relative_path"
        end
    end

    # Add gibo templates
    if test (count $templates_to_add) -gt 0
        command gibo dump $templates_to_add >>"$gitignore_file"
        echo "Added gibo template(s): $templates_to_add"
    end
end
