# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.HVL1ns/__plugin_cd.fish @ line 19
function __plugin_cd --description plugin-cd --argument fancy_path
    
  function __fish_cd
    if functions -q __wrapped_cd
      __wrapped_cd $argv
    else
      builtin cd $argv
    end
  end

  function __empty_cd -S
    __fish_cd
    set -l output_status $status

    __update_pwd

    return $output_status
  end

  function __hyphen_cd -S
    __fish_cd $OLDPWD
    set -l output_status $status

    __update_pwd

    return $output_status
  end

  function __fancy_cd -S
    set extract_from_right (echo $fancy_path | sed -n 's/^+\([0-9]*\)$/\1/g p')
    set extract_from_left (echo $fancy_path | sed -n 's/^-\([0-9]*\)$/\1/g p')

    if test -n "$extract_from_right" -o -n "$extract_from_left"
      # Generate current stack
      set -l stack (command pwd) $dirstack

      if test -n "$extract_from_right"
        if test $extract_from_right -gt (math (count $stack) - 1)
          echo "no such entry in dir stack"
          return 1
        end

        set extract_from_left (math (count $stack) - 1 - $extract_from_right)
      end

      if test $extract_from_left -gt (math (count $stack) - 1)
        echo "no such entry in dir stack"
        return 1
      else
        if test $extract_from_left -gt 0
          set stack $stack[(math $extract_from_left + 1)] $stack
          set -e stack[(math $extract_from_left + 2)]
        end

        # now reconstruct dirstack and change directory
        set -g dirstack $stack[2..(count $stack)]
        __fish_cd $stack[1]
        set -l output_status $status

        __update_pwd

        return $output_status
      end
    else
      set -l normal_path (echo $fancy_path | sed -e 's@^\.$@:@;s@^\.\([^\.]\)@:\1@g;s@\([^\.]\)\.$@\1:@g' -e 's@\([^\.]\)\.\([^\.]\)@\1:\2@g' -e 's@\([^\.]\)\.\([^\.]\)@\1:\2@g' -e 's@\.\{2\}\(\.*\)@::\1@g' -e 's@\.@\/\.\.@g' -e 's@:@\.@g')

      __fish_cd $normal_path
      set -l output_status $status

      __update_pwd

      return $output_status
    end
  end

  function __update_dirstack -S
      if contains $old_pwd $dirstack
        # If the from directory is existed in stack, remove it
        set -e dirstack[(contains -i $old_pwd $dirstack)]
      end
      # Add the from directory to the head of stack
      set -g dirstack $old_pwd $dirstack

      if contains (command pwd) $dirstack
        # If the to directory is existed in stack, remove it
        set -e dirstack[(contains -i (command pwd) $dirstack)]
      end
  end

  function __update_pwd -S
    if test $old_pwd != (command pwd)
      set -xg OLDPWD $old_pwd
      __update_dirstack
    end
  end

  # body:
  set -l old_pwd (pwd)

  switch "$fancy_path"
    case ''
      __empty_cd
    case '-'
      __hyphen_cd
    case '*'
      __fancy_cd
  end
end
