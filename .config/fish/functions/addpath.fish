# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.zQIxQn/addpath.fish @ line 2
function addpath
    for p in $argv
        if begin; not contains $p $fish_user_paths; and test -d $p; end
            set -U fish_user_paths $fish_user_paths $p
        end
    end
end
