fish_add_path -g --move /run/current-system/sw/bin/
fish_add_path -g --move /run/system-manager/sw/bin/
fish_add_path -g --move /nix/var/nix/profiles/default/bin
fish_add_path -g --move $XDG_STATE_HOME/nix/profile/bin

# Set $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
if not set -q NIX_SSL_CERT_FILE
    for f in /etc/{ssl/{certs/ca-certificates.crt,ca-bundle.pem,certs/ca-bundle.crt},pki/tls/certs/ca-bundle.crt,ssl/cert.pem} $profile/etc/{ssl/certs/,}ca-bundle.crt
        if test -e $f
            set -x NIX_SSL_CERT_FILE $f
            break
        end
    end
end

if test -f /nix/var/nix/profiles/default/share/fish/vendor_completions.d/nix.fish
    source /nix/var/nix/profiles/default/share/fish/vendor_completions.d/nix.fish
end

set -a fish_complete_path $XDG_STATE_HOME/nix/profile/share/fish/vendor_completions.d
