if status is-interactive

    if command -q jenv
        fish_add_path --append -g --move $HOME/.jenv/bin $HOME/.jenv/shims

        set -gx JENV_SHELL fish
        set -gx JENV_LOADED 1
        set -e JAVA_HOME
        set -e JDK_HOME
    else
        switch $OS
            case Darwin
                set -l BASE /Library/Java/JavaVirtualMachines
                set -gx JAVA_HOME $BASE/(command ls $BASE|sort)[-1]/Contents/Home

                fish_add_path --append -g $JAVA_HOME/bin
            case Linux
                set -gx JAVA_HOME (dirname (dirname (readlink -f /usr/bin/java)))
        end
    end
end
