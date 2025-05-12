function clean-complete-path --description "Remove non-existent paths from fish_complete_path"
    set -l valid_paths

    for path in $fish_complete_path

        if not test -d $path
            continue
        end

        # Skip if path contains no .fish files
        set -l fish_files_count (count $path/*.fish 2>/dev/null)

        if test $fish_files_count -eq 0
            continue
        end

        # Skip if path is already in our valid_paths list (deduplication)
        if contains $path $valid_paths
            continue
        end

        set -a valid_paths $path
    end

    # Set the fish_complete_path to only include valid, unique paths
    set -g fish_complete_path $valid_paths
end

clean-complete-path
