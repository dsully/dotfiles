# https://github.com/jorgebucaran/fisher/issues/640#issuecomment-1172984768
if status is-login

    # Set fisher install to be outside of ~/.config/fish
    # This variable is used at the top of fisher.fish
    set -gx fisher_path $XDG_CACHE_HOME/fish

    set -a fish_complete_path $fisher_path/completions
    set -a fish_function_path $fisher_path/functions

    # Install fisher if it isn't already.
    # Use 'fisher update' and not install to read the checked in fish_plugins file.
    if not test -f $fisher_path/functions/fisher.fish
        curl -sL https://git.io/fisher | source && fisher update
    end

    for file in $fisher_path/conf.d/*.fish
        if not test -f (string replace -r "^.*/" $__fish_config_dir/conf.d/ -- $file)
            and test -f $file && test -r $file
            builtin source $file 2>/dev/null
        end
    end

    # Install fisher plugins if they aren't already.
    if test $OS = Darwin; and not type -q mac
        fisher install halostatue/fish-utils-core@v2.x
        fisher install halostatue/fish-macos@v5.x
    end

    if not type -q fkill
        fisher install gazorby/fish-finders
    end

    if not type -q fzf_configure_bindings
        fisher install patrickf1/fzf.fish
    end
end
