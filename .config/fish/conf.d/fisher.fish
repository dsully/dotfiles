# https://github.com/jorgebucaran/fisher/issues/640#issuecomment-1172984768
if status is-login

    # Set fisher install to be outside of ~/.config/fish
    set -gx fisher_path $HOME/.cache/fish

    # Install fisher if it isn't already.
    # Use 'fisher update' and not install to read the checked in fish_plugins file.
    if not test -f $fisher_path/functions/fisher.fish
        curl -sL https://git.io/fisher | source && fisher update
    end

    set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
    set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

    for file in $fisher_path/conf.d/*.fish
        if not test -f (string replace -r "^.*/" $__fish_config_dir/conf.d/ -- $file)
            and test -f $file && test -r $file
            source $file
        end
    end
end
