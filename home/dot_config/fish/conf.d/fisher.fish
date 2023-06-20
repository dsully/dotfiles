# https://github.com/jorgebucaran/fisher/issues/640#issuecomment-1172984768
if status is-login

    if set -q fisher_path; and test -d $fisher_path/conf.d

        for file in $fisher_path/conf.d/*.fish
            if not test -f (string replace -r "^.*/" $__fish_config_dir/conf.d/ -- $file)
                and test -f $file && test -r $file
                builtin source $file 2>/dev/null
            end
        end
    end
end
