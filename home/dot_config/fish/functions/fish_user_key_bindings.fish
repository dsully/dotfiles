function cd-up
    prevd; and commandline -f repaint
end

function cd-down
    # If no next item in forward history pick a new path.
    if test (count $dirnext) -eq 0
        set --local path $(fd -t d -d 2 . | fzf)
        and cd $path
        and commandline -f repaint
    else
        nextd; and commandline -f repaint
    end
end

# Function to print custom key bindings with descriptions
function print_custom_binds --description "Prints out custom user binds"
    set_color normal
    set_color --bold white
    echo
    echo Bindings
    echo
    set_color normal

    # Define the bindings data
    set -l bindings
    set -a bindings "Alt+C\tFuzzy search directories to cd into"
    set -a bindings "Ctrl+N\tNavigate down in directory tree"
    set -a bindings "Ctrl+O\tNavigate up in directory tree"
    set -a bindings "Ctrl+R\tFuzzy search command history"
    set -a bindings "Ctrl+T\tFuzzy search files in current directory"
    set -a bindings ",ff\tCustom file finder function"
    set -a bindings ",fg\tCustom file grep function"
    set -a bindings ",fr\tCustom file replace function"

    # Print each binding with colors
    for binding in $bindings
        set -l parts (string split "\t" $binding)
        set_color normal
        set_color --bold white
        printf "  * "
        set_color normal
        set_color cyan
        printf "%-8s " $parts[1]
        set_color white
        printf "%s\n" $parts[2]
    end

    set_color normal
    echo
end

# https://brettterpstra.com/2021/11/25/git-better-with-fzf-and-fish/
#
# @ttscoff's version of @max-sixty's revision of @aluxian's
# fish translation of @junegunn's fzf git keybindings
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
# https://gist.github.com/aluxian/9c6f97557b7971c32fdff2f2b1da8209
#
# 2021-12-23:
# - Fix hash returned by *git_log being truncated
# - Allow multiple selections for git_status
# - Allow multiple selections for git_log, insert HASH[1].. HASH[-1] range
# - bind ctrl-a for select all

# Deciphered from fzf-file-widget. Somewhat unclear why it doesn't exist already!
function fzf_add_to_commandline -d 'add stdin to the command line, for fzf functions'
    read -l result
    commandline -t ""
    commandline -it -- (string escape $result)
    commandline -f repaint
end

function fzf_add_multi_files_to_commandline -d 'add stdin to the command line without escaping, for fzf functions'
    read -l result
    set files (string split '*' $result)
    commandline -t ""
    for file in $files
        commandline -it -- (string escape $file)" "
    end
    commandline -f repaint
end

function fzf_add_multi_hashes_to_commandline -d 'add multiple hashes as a range'
    read -d \n -z -a result
    set -l hashes
    for hash in $result
        if test -n (string trim $hash)
            set -a hashes $hash
        end
    end
    commandline -t ""
    if test (count $hashes) -gt 1
        commandline -it -- $hashes[1]".. "$hashes[-1]
    else
        commandline -it -- $hashes[1]
    end
    commandline -f repaint
end

function fzf-down
    fzf --height 50% --min-height 20 --border --bind ctrl-p:toggle-preview --bind ctrl-a:select-all $argv
end

# https://gist.github.com/aluxian/9c6f97557b7971c32fdff2f2b1da8209
function __git_fzf_is_in_git_repo
    command -s -q git
    and git rev-parse HEAD >/dev/null 2>&1
end

function __git_fzf_git_remote
    __git_fzf_is_in_git_repo; or return
    git remote -v | awk '{print $1 ":" $2}' | uniq | fzf-down --ansi --tac \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" --remotes={1} | head -200' | cut -d ':' -f1 | fzf_add_to_commandline
end

function __git_fzf_git_status
    __git_fzf_is_in_git_repo; or return
    git -c color.status=always status --short | fzf-down -m --ansi --preview 'git diff --color=always HEAD -- {-1} | head -500' | cut -c4- | sed 's/.* -> //' | tr '\n' '*' | sed 's/\*$//' | fzf_add_multi_files_to_commandline
end

function __git_fzf_git_branch
    __git_fzf_is_in_git_repo; or return
    git branch -a --color=always | grep -v '/HEAD\s' | fzf-down -m --ansi --preview-window right:70% --preview 'git log --color=always --oneline --graph --date=short \
			--pretty="format:%C(auto)%cd %h%d %s %C(magenta)[%an]%Creset" \
			--print0 \
			--read0 \
			(echo {} | sed s/^..// | cut -d" " -f1) | head -'$LINES | sed 's/^..//' | cut -d' ' -f1 | sed 's#^remotes/##' | fzf_add_to_commandline
end

function __git_fzf_git_tag
    __git_fzf_is_in_git_repo; or return
    git tag --sort -version:refname | fzf-down --ansi --preview-window right:70% \
        --preview 'git show --color=always {} | head -'$LINES | fzf_add_to_commandline
end

function __git_fzf_git_log
    __git_fzf_is_in_git_repo; or return
    git log --color=always --graph --date=short --format="%C(auto)%cd %h%d %s %C(magenta)[%an]%Creset" | fzf-down -m --ansi --reverse --preview 'git show --color=always (echo {} | grep -o "[a-f0-9]\{7,\}") | head -'$LINES | awk '{print $3}' \
        | fzf_add_multi_hashes_to_commandline
end

function fish_user_key_bindings
    status is-interactive || exit

    bind \co cd-up
    bind \cn cd-down

    bind \cg\cf __git_fzf_git_status
    bind \cg\cb __git_fzf_git_branch
    bind \cg\ct __git_fzf_git_tag
    bind \cg\ch __git_fzf_git_log
    bind \cg\cr __git_fzf_git_remote

    print_custom_binds
end
