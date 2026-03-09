# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A [chezmoi](https://www.chezmoi.io/) dotfiles repository managing Emacs, zsh, and shell configuration for macOS. Chezmoi templates (`.tmpl` files) are rendered at apply time using data from `.chezmoi.toml.tmpl`.

## Chezmoi Commands

```sh
chezmoi diff          # Preview changes before applying
chezmoi apply         # Apply templates to home directory
chezmoi edit ~/.zshrc # Edit the template source (not the target)
chezmoi cd            # Jump to this source directory
```

## File Naming Conventions

Chezmoi uses prefixes to map source files to targets:

| Source file | Target |
|---|---|
| `dot_zshrc.tmpl` | `~/.zshrc` |
| `dot_zshenv.tmpl` | `~/.zshenv` |
| `dot_zsh_projects` | `~/.zsh_projects` |
| `dot_emacs.d/` | `~/.emacs.d/` |

Files ending in `.tmpl` are Go templates with access to `.chezmoi.os` and custom data (like `email`). Non-`.tmpl` files are copied verbatim.

## Architecture

### Templating

- `.chezmoi.toml.tmpl` — prompts for `email` during `chezmoi init`; generates `~/.config/chezmoi/chezmoi.toml`
- Templates use `{{ if eq .chezmoi.os "darwin" }}` guards for macOS-specific blocks (Keychain secrets, MacPorts paths, pipx paths)

### Shell (zsh)

- `dot_zshenv.tmpl` — environment variables for all shells: PATH (MacPorts, Conda, Cargo), Conda initialization
- `dot_zshrc.tmpl` — interactive shell: mise activation, Emacs editor config, code quality aliases (black/pylint/mypy), git aliases, zsh completions, macOS Keychain secrets, ArangoDB env vars, project aliases via `~/.zsh_projects`
- `dot_zsh_projects` — machine-specific `cd.*` project aliases (each cd's into a project and activates its venv)

### Emacs

- `dot_emacs.d/early-init.el` — package archives (GNU, NonGNU, MELPA) with priority ordering, frame defaults
- `dot_emacs.d/init.el` — main config using `use-package` with `:ensure t` throughout. Core stack: corfu/cape/orderless (completion), eglot (LSP), magit, flycheck, yasnippet, helm
- `dot_emacs.d/lisp/init-{language}.el` — per-language configs for Python, JavaScript, Rust, Java, R, YAML, MATLAB. Each is `require`d from init.el

Eglot hooks are configured in init.el for: python, rust, js, java (including tree-sitter `-ts-mode` variants).

### Secrets

Secrets are stored in the macOS Keychain (not in dotfiles). The zshrc retrieves them at shell startup via `security find-generic-password`.
