# https://github.com/jorgebucaran/fisher/issues/640#issuecomment-1172984768
if status is-login

    # Set fisher install to be outside of ~/.config/fish
    # This variable is used at the top of fisher.fish
    set -gx fisher_path $XDG_CACHE_HOME/fish

    set -a fish_complete_path $fisher_path/completions
    set -a fish_function_path $fisher_path/functions

    fisher update >/dev/null

    for file in $fisher_path/conf.d/*.fish
        if not test -f (string replace -r "^.*/" $__fish_config_dir/conf.d/ -- $file)
            and test -f $file && test -r $file
            builtin source $file 2>/dev/null
        end
    end
end
