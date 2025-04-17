hostname := `hostname`

# switch:
#   if uname == "Darwin"
#     nix build --extra-experimental-features nix-command --extra-experimental-features flakes ".#darwinConfigurations.{{nixname()}}.system"
#     ./result/sw/bin/darwin-rebuild switch --flake "{{pwd()}}#{{nixname()}}"
#   else
#     sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#{{nixname()}}"
#   end

default:
    @just --list

############################################################################
#
#  Darwin related commands
#
############################################################################

[group('desktop')]
switch:
    @nix build .#darwinConfigurations.{{ hostname }}.system \
      --extra-experimental-features 'nix-command flakes' \
    .#darwinConfigurations.{{ hostname }}.system

    @./result/sw/bin/darwin-rebuild switch --flake .#{{ hostname }}
    @/bin/rm result*

[group('desktop')]
darwin-debug:
    @nix build .#darwinConfigurations.{{ hostname }}.system --show-trace --verbose \
      --extra-experimental-features 'nix-command flakes' \
    .#darwinConfigurations.{{ hostname }}.system

    ./result/sw/bin/darwin-rebuild switch --flake .#{{ hostname }} --show-trace --verbose

############################################################################
#
#  nix related commands
#
############################################################################

# Update all the flake inputs
[group('nix')]
up:
    nix flake update

# Update specific input

# Usage: just upp nixpkgs
[group('nix')]
upp input:
    nix flake update {{ input }}

# List all generations of the system profile
[group('nix')]
history:
    nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
    nix repl -f flake:nixpkgs

# remove all generations older than 7 days

# On darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Garbage collect all unused nix store entries
[group('nix')]
gc:
    @sudo nix-collect-garbage --delete-older-than 7d
    @nix-collect-garbage --delete-older-than 7d

# Format the nix files in this repo
[group('nix')]
fmt:
    @alejandra .
    @deadnix .
    @statix check

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
    ls -al /nix/var/nix/gcroots/auto/

# Create a .nix file from a URL using nix-init

# Usage: just init-from-url https://github.com/anistark/feluda
[group('nix')]
init-from-url URL:
    #!/usr/bin/env bash
    set -euo pipefail

    # Extract the last path component from the URL
    LAST_COMPONENT=$(echo "{{ URL }}" | sed -E 's|.*/([^/]+)/?$|\1|')

    # Remove any trailing .git if present
    LAST_COMPONENT=${LAST_COMPONENT%.git}

    # Create the output filename
    OUTPUT_FILE=pkgs/"${LAST_COMPONENT}.nix"

    # Run nix-init with the specified parameters
    nix-init -n 'builtins.getFlake "nixpkgs"' -u "{{ URL }}" "${OUTPUT_FILE}"

    # Add useFetchCargoVendor = true; to the file
    sed -i '/cargoHash = ".*";/a \    useFetchCargoVendor = true;' "${OUTPUT_FILE}"
