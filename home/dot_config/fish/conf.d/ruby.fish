if status is-interactive

    if test -x /opt/homebrew/opt/ruby/bin/ruby
        fish_add_path -g /opt/homebrew/opt/ruby/bin

        # set -gx LDFLAGS -L/opt/homebrew/opt/ruby/lib
        # set -gx CPPFLAGS -I/opt/homebrew/opt/ruby/include
        # set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/ruby/lib/pkgconfig"
    end

end
