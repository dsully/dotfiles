# Installation

Dotfiles via the bare repo approach, as defined in [Nicola
Paolucci's
blog](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/), with modifications for multiple repositories.

This allows for dotfiles without symlinks, rsyncing, or other state management.

## On a new machine

```bash
curl https://raw.githubusercontent.com/dsully/dotfiles/master/bin/bootstrap [URL] | bash
```

### Using different repositories

Often you'll want to have public dotfiles along with private ones, for both home and work.

Use the 'git-link' function defined in .config/fish/functions/git-link.fish to switch between repos.
