fish_add_path -g --move /run/current-system/sw/bin \
    /run/system-manager/sw/bin \
    /nix/var/nix/profiles/default/bin \
    $XDG_STATE_HOME/nix/profile/bin

# Set $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
if not set -q NIX_SSL_CERT_FILE
    for f in /etc/{ssl/{certs/ca-certificates.crt,ca-bundle.pem,certs/ca-bundle.crt},pki/tls/certs/ca-bundle.crt,ssl/cert.pem} $profile/etc/{ssl/certs/,}ca-bundle.crt
        if test -e $f
            set -x NIX_SSL_CERT_FILE $f
            break
        end
    end
end

if test -d $XDG_STATE_HOME/nix/profile/share/fish
    set -p fish_complete_path "$XDG_STATE_HOME/nix/profile/share/fish/vendor_completions.d"
    set -p fish_function_path "$XDG_STATE_HOME/nix/profile/share/fish/vendor_functions.d"

    # Bootstrap fishPlugins.git, as it checks for $fisher_path which doesn't exiset.
    if functions --query __git.init
        __git.init
    end
end

if test -d /nix/var/nix/profiles/default/share/fish/vendor_completions.d
    set -a fish_complete_path /nix/var/nix/profiles/default/share/fish/vendor_completions.d
end
