if status is-interactive

    switch $OS
        case Darwin
            set -l BASE /Library/Java/JavaVirtualMachines
            set -gx JAVA_HOME $BASE/(command ls $BASE|sort)[-1]/Contents/Home

            fish_add_path --append -g $JAVA_HOME/bin
        case Linux
            set -gx JAVA_HOME (dirname (dirname (readlink -f /usr/bin/java)))
    end
end
