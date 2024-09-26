function which-completion
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Usage: which-completion <main_command> [subcommand]"
        return 0
    end

    set -l main_command $argv[1]
    set -l subcommand $argv[2]
    set -l completion_command (string join '-' $argv)

    for directory in $fish_complete_path
        # Search for files matching the main command
        set -l files (command find $directory -type f \( -name "*$main_command*" -o -name "*$completion_command*" \))
        for file in $files
            set -l filename (string split -r -m1 . (basename $file))[1]
            if test "$filename" = "$main_command"
                if test -n "$subcommand"
                    command grep -q "__fish\S*command $subcommand" $file
                    and echo $file
                else
                    echo $file
                end
            else if test "$filename" = "$completion_command"
                echo $file
            end
        end
    end
end
