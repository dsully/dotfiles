if status is-interactive

    if test -x /usr/local/opt/ruby/bin/ruby
        fish_add_path -g /usr/local/opt/ruby/bin

        # set -gx LDFLAGS -L/opt/homebrew/opt/ruby/lib
        # set -gx CPPFLAGS -I/opt/homebrew/opt/ruby/include
        # set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/ruby/lib/pkgconfig"
    end

end
