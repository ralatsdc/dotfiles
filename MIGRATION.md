# Migration Guide: Springbok Emacs → Chezmoi Dotfiles

## Overview

This replaces the old `init-springbok.sh` + `sed` templating system with chezmoi.

### What changed

| Before | After |
|--------|-------|
| `init-springbok.sh` generates files via `sed` | `chezmoi apply` generates files from templates |
| `init-*.el` + `.emacs-*.el` dual config | Single `~/.emacs.d/` with `use-package` throughout |
| `install-if-needed` + `package-refresh-contents` | `use-package` with `:ensure t` (auto-install) |
| `auto-complete` + `jedi` + `tern` | `corfu` + `cape` + `eglot` (LSP for all languages) |
| `lsp-mode` / `lsp-metals` / `lsp-ui` | `eglot` (built into Emacs 29+) |
| ESS, yaml-mode, matlab-mode built from source | All installed from MELPA via `use-package` |
| Secrets hardcoded in `.zshrc` | Secrets in macOS Keychain |
| Project aliases mixed into `.zshrc` | Separate `~/.zsh_projects` file |
| Manual PATH setup in `.emacs-fini.el` | `exec-path-from-shell` handles everything |

## Prerequisites

- Emacs 30+ (you have 30.2)
- MacPorts (you have 2.12.1)

## Step 1: Install chezmoi

```sh
sudo port install chezmoi
```

Or if not yet in MacPorts:
```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

## Step 2: Migrate secrets to macOS Keychain

Run these commands once to store your secrets:

```sh
security add-generic-password -U -a "$USER" -s "VOXCELEB2_USERNAME" -w "voxceleb1912"
security add-generic-password -U -a "$USER" -s "VOXCELEB2_PASSWORD" -w "0s42xuw6"
security add-generic-password -U -a "$USER" -s "SECRET_KEY" -w '2@_oovalu#^=jo0%lbbtas02yh65mi0%epb4a+75&)%k@v4ae4'
security add-generic-password -U -a "$USER" -s "ARANGO_DB_PASSWORD" -w "7mtgagy6hFx46ASX"
```

Verify they work:
```sh
security find-generic-password -s "ARANGO_DB_PASSWORD" -w
```

## Step 3: Back up current config

```sh
cp ~/.emacs ~/.emacs.backup
cp ~/.zshrc ~/.zshrc.backup
cp -r ~/.emacs.d ~/.emacs.d.backup
```

## Step 4: Remove old symlinks

```sh
rm ~/.emacs ~/.zshrc
```

## Step 5: Initialize chezmoi with these dotfiles

```sh
chezmoi init --source ~/Projects/Springbok/emacs/dotfiles
chezmoi diff   # Review what will change
chezmoi apply  # Apply the changes
```

## Step 6: Install LSP servers

Eglot needs language servers installed on your system:

```sh
# Python
pip install python-lsp-server

# Rust (rust-analyzer comes with rustup)
rustup component add rust-analyzer

# Go
go install golang.org/x/tools/gopls@latest

# Haskell (haskell-language-server comes with GHCup)
ghcup install hls

# Scala (metals — already installed via coursier)
cs install metals

# Clojure
# clojure-lsp: https://clojure-lsp.io/installation/
```

## Step 7: Start Emacs

On first launch, `use-package` will automatically download and install all
packages from MELPA.  This takes 1-2 minutes on first run.

## Step 8: Clean up ~/.emacs.d

After verifying everything works, remove legacy directories:

```sh
rm -rf ~/.emacs.d/blacken        # replaced by eglot + python-lsp-server
rm -rf ~/.emacs.d/ESS            # now installed from MELPA
rm -rf ~/.emacs.d/matlab-emacs-src  # now installed from MELPA
rm -rf ~/.emacs.d/elpa-2024-07-04   # old elpa backup
```

## Ongoing usage

```sh
chezmoi edit ~/.zshrc    # Edit the template source
chezmoi apply            # Regenerate files from templates
chezmoi cd               # Jump to the source directory
chezmoi diff             # See pending changes
chezmoi git -- add -A && chezmoi git -- commit -m "update"  # Commit changes
```
