set --query _fisher_path_initialized && exit
set --global _fisher_path_initialized

if not string length --quiet "$fisher_path" || test "$fisher_path" = "$__fish_config_dir"
    exit
end

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    if ! test -f (string replace --regex "^.*/" $__fish_config_dir/conf.d/ -- $file)
        and test -f $file && test -r $file
        source $file
    end
end

# jhillyerd/plugin-git tries to protect against loading and sets fisher_path based
# on fish_config_dir which isn't the same as the one we're using
if test -f $fisher_path/functions/__git.init.fish
    source $fisher_path/functions/__git.init.fish
    __git.init
end
