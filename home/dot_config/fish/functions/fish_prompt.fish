function __get_status_symbol
    set -l code $argv[1]
    switch $code
        case 126
            echo -n "🚫" # not executable
        case 127
            echo -n "🔍" # not found
        case 130
            echo -n "🧱" # SIGINT
        case '*'
            if test $code -gt 128
                echo -n "󰉁 " # signal
            else
                echo -n "$code"
            end
    end
end

function fish_prompt
    # Save last status
    set -l last_status $status
    set -l last_pipestatus $pipestatus
    set -l pwd = (pwd)

    # Username (only if not dsully)
    if test "$USER" != dsully
        echo -n -s (set_color red --bold) "$USER@" (set_color normal)
    end

    # Sudo indicator
    if sudo -vn &>/dev/null
        echo -n -s (set_color red --bold) " " (set_color normal)
    end

    # Hostname (SSH only)
    if set -q SSH_CONNECTION
        echo -n -s (set_color white --bold) "$hostname:" (set_color normal)
    end

    # Directory
    echo -n (set_color white)"["(set_color cyan)(prompt_pwd)(set_color white)"]"(set_color normal)

    if test "$pwd" != "$HOME"

        # Collect language icons
        set -l icon_count 0
        set -l icons

        if string match -q -r iCloud $pwd
            set -a icons "blue:󰀸:1"
        end

        # C (color 149 = light blue/cyan)
        if count *.c *.h >/dev/null 2>&1
            set -a icons "95d3af::1"
        end

        if count *.cpp *.cc >/dev/null 2>&1; or test -f CMakeLists.txt
            set -a icons "95d3af:󰙲:1"
        end

        if test -f Dockerfile -o -f docker-compose.yml -o -f docker-compose.yaml -o -f compose.yml -o -f compose.yaml
            set -a icons "blue::2" # 🐳
        end

        if test -f go.mod -o -f go.sum -o -f go.work -o -f Gopkg.yml -o -f Gopkg.lock
            set -a icons "cyan::1"
        end

        if test -f helmfile.yaml -o -f Chart.yaml
            set -a icons "white:⎈:2"
        end

        if count *.java *.class *.jar >/dev/null 2>&1; or test -f pom.xml
            set -a icons "red::1"
        end

        if count *.lua >/dev/null 2>&1; or test -f .lua-version -o -d lua -o -f stylua.toml
            set -a icons "blue:󰢱:1"
        end

        if set -q IN_NIX_SHELL; or test -f flake.nix -o -f default.nix -o -f shell.nix
            set -a icons "blue:󱄅:1"
            #set -a icons "blue:❄️:1"
        end

        if count *.js >/dev/null 2>&1; or test -f package.json -o -f .node-version -o -f .nvmrc -o -d node_modules
            set -a icons "red::1"
        end

        if test -f Pulumi.yaml; or test -f Pulumi.yml
            set -a icons "magenta::1"
        end

        if count *.py *.ipynb >/dev/null 2>&1; or test -f requirements.txt -o -f pyproject.toml -o -f Pipfile -o -f setup.py
            set -a icons "yellow:󰌠:1"
        end

        if count *.rs >/dev/null 2>&1; or test -f Cargo.toml
            set -a icons "red:󱘗:1"
        end

        if count *.swift >/dev/null 2>&1; or test -f Package.swift
            set -a icons "red:󰛥:1"
        end

        if count *.ts >/dev/null 2>&1; or test -f package.json -o -f .node-version -o -f .nvmrc -o -d node_modules
            set -a icons "yellow::1"
        end

        if count *.zig >/dev/null 2>&1
            set -a icons "yellow::1"
        end

        set -l icon_count (count $icons)

        # Check if we're in a git repo
        set -l in_git_repo 0

        if test -d .git; or git rev-parse --git-dir >/dev/null 2>&1
            set in_git_repo 1
        end

        if test $icon_count -gt 0 -o $in_git_repo -eq 1
            echo -n " ("

            # Display language icons
            for i in (seq $icon_count)
                set -l parts (string split ":" $icons[$i])
                set -l color $parts[1]
                set -l icon $parts[2]
                set -l width $parts[3]

                set_color $color --bold
                echo -n $icon

                # Add single space for double-width emoji.
                if test $width -eq 2
                    echo -n " "
                end

                set_color normal

                # Add space only if there are more icons
                if test $i -lt $icon_count
                    echo -n " "
                end
            end

            # Add space before git info if we have language icons and git
            if test $icon_count -gt 0 -a $in_git_repo -eq 1
                echo -n " "
            end

            # The order is important to not have a space after the branch name.
            set -g __fish_git_prompt_showdirtystate 1
            set -g __fish_git_prompt_char_dirtystate "*"
            set -g __fish_git_prompt_char_stagedstate "+"
            set -g __fish_git_prompt_color_branch white --bold
            set -g __fish_git_prompt_show_informative_status 0
            set -g ___fish_git_prompt_char_stateseparator ""
            fish_git_prompt "%s"

            echo -n ")"
        end
    end

    # Status (with pipestatus support)
    if test $last_status -ne 0
        set_color red --bold

        # Check if we have a pipeline with multiple statuses
        if test (count $last_pipestatus) -gt 1
            # Show pipestatus format
            echo -n " ["

            for i in (seq (count $last_pipestatus))

                if test $i -gt 1
                    echo -n "|"
                end

                set -l code $last_pipestatus[$i]

                if test $code -ne 0
                    echo -n (__get_status_symbol $code)
                end
            end

            echo -n "]"
        else
            echo -n " ["(__get_status_symbol $last_status)"]"
        end

        set_color normal

        set last_status 0
    end

    # Newline before the prompt.
    echo

    # Shell level indicator
    if test $SHLVL -gt 1
        for i in (seq $SHLVL)
            echo -n "❯"
        end
    end

    echo -n "\$ "
end
