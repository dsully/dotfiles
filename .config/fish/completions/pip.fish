for cmd in install uninstall
    complete -c pip -n __fish_use_subcommand -xa $cmd
end

function __list_pypi_packages
    set -l partial_name (commandline -t)

    if string match -q "*==*" $partial_name
        set -l package (string match -g --regex "([^=]+)==.*" $partial_name)
        # Fetch only keys from array under `releases`.
        jq -r '.releases|keys[]' | \
            # Prefix with package name again so the match can complete.
            sed -e "s/^/$package==/" | \
            # SemVer sort: https://stackoverflow.com/a/63027058/1194456
            sort -r -t "." -k1,1n -k2,2n -k3,3n
    else
        rg "^$partial_name" --smart-case ~/.cache/pypi_packages.txt
    end
end

function __list_installed_packages
    pip list --format json | jq -r '. | map("\(.name)") | .[]'
end

complete -c pip -n "__fish_seen_subcommand_from install" -fka '(__list_pypi_packages)'
complete -c pip -n "__fish_seen_subcommand_from uninstall" -fa '(__list_installed_packages)'
