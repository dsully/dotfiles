# Fish git prompt
set -U __fish_git_prompt_showdirtystate true
set -U __fish_git_prompt_color_branch -o white

set -U fish_color_user cyan
set -U fish_color_host cyan

# only display a host name if we're in an ssh session.
function __user_host
    if test -n "$SSH_CLIENT$SSH_TTY"

        if test (id -u) -eq 0
            set_color --bold red
            echo -n $USER(set_color --bold white)@
        else
            set_color --bold white
        end
        echo -n $HOSTNAME(set_color normal):

    else
        if test (id -u) -eq 0
            set_color --bold red
            echo -n $USER(set_color normal)@
        end
    end

end

function fish_prompt --description 'Write out the prompt'

    set -l last_status $status

    __user_host

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    set -l delim '$'

    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    if not set -q __fish_prompt_user
        set -g __fish_prompt_user (set_color $fish_color_user)
    end

    echo -n -s '[' "$__fish_prompt_user" (prompt_pwd) "$__fish_prompt_normal" ']' (fish_git_prompt)\n "$delim" ' '

end
