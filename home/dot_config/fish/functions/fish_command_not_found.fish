function fish_command_not_found
    # Get packages from nix-locate
    set -l pkgs (command nix-locate --minimal --no-group --type x --type s --whole-name --at-root /bin/$argv[1] 2>/dev/null | string replace '.out' '' | sort -u)

    # Display command not found message
    set -l program (set_color $fish_color_error; printf $argv[1]; set_color $fish_color_normal)
    set -l linked_program (hyperlink "https://search.nixos.org/packages?channel=unstable&query=$argv[1]" $program)

    printf 'The program \'%s\' is not installed.\n' $linked_program

    if test (count $pkgs) -gt 0
        if test (count $pkgs) -gt 1
            printf 'It is provided by several packages.\n'
        else
            printf '\n'
        end

        for pkg in $pkgs
            set -l url "https://search.nixos.org/packages?channel=unstable&show=$pkg&from=0&size=1&type=packages&query=$pkg"
            printf '  nix profile install nixpkgs#%s\n' (hyperlink $url $pkg)
        end

    else
        printf 'It is not provided by any indexed packages.\n\n'
    end
end
