# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), targeting macOS with zsh and Emacs.

## Tools

### chezmoi

[Chezmoi](https://www.chezmoi.io/) manages dotfiles across machines by maintaining template sources in a Git repository and rendering them to the home directory. Files ending in `.tmpl` are [Go templates](https://pkg.go.dev/text/template) with access to system facts like `.chezmoi.os` and custom data defined during `chezmoi init`.

- [Quick start](https://www.chezmoi.io/quick-start/)
- [Templating](https://www.chezmoi.io/user-guide/templating/)
- [Command reference](https://www.chezmoi.io/reference/commands/)

### mise

[mise](https://mise.jdx.dev/) is a polyglot version manager (successor to asdf) used here for Node.js and Java. It is activated in `.zshrc` via `eval "$(mise activate zsh)"`.

- [Getting started](https://mise.jdx.dev/getting-started.html)
- [Configuration](https://mise.jdx.dev/configuration.html)

### MacPorts

[MacPorts](https://www.macports.org/) is the system package manager, providing tools like `aspell` (used by Emacs for spell checking). MacPorts paths (`/opt/local/bin`, `/opt/local/sbin`) are added to `PATH` in `.zshenv`.

- [Guide](https://guide.macports.org/)

### Python

Python versions are primarily managed via [MacPorts](https://www.macports.org/).

```sh
port search --name --line python3  # List available Python versions in MacPorts
sudo port install python313  # Install a specific Python version
sudo port upgrade python313  # Upgrade it
port select --list python  # List installed versions available for selection
sudo port select --set python3 python313  # Set the default python3
```

### Emacs

The Emacs configuration targets **Emacs 29+** and uses built-in features where possible:

- [use-package](https://www.gnu.org/software/emacs/manual/html_mono/use-package.html) for declarative package management (auto-installs from MELPA on first launch)
- [eglot](https://www.gnu.org/software/emacs/manual/html_mono/eglot.html) as the built-in LSP client for Python, Rust, JavaScript, and Java
- [corfu](https://github.com/minad/corfu) + [cape](https://github.com/minad/cape) + [orderless](https://github.com/oantolin/orderless) for in-buffer completion
- [magit](https://magit.vc/) for Git, [flycheck](https://www.flycheck.org/) for syntax checking, [helm](https://emacs-helm.github.io/helm/) for search/navigation

### macOS Keychain

Secrets are stored in the macOS Keychain rather than in dotfiles. The `.zshrc` retrieves them at shell startup using `security find-generic-password`.

- [security(1) man page](https://ss64.com/mac/security.html)

## Repository layout

```
.chezmoi.toml.tmpl          # Chezmoi config template (prompts for email during init)
.chezmoiignore              # Files chezmoi should not deploy (README.md, LICENSE)

dot_zshenv.tmpl             # → ~/.zshenv    — PATH and environment for all shells
dot_zshrc.tmpl              # → ~/.zshrc     — Interactive shell config (aliases, secrets, mise)
dot_zsh_projects            # → ~/.zsh_projects — Machine-specific project cd/activate aliases

dot_emacs.d/
  early-init.el             # → ~/.emacs.d/early-init.el — Package archives, frame defaults
  init.el                   # → ~/.emacs.d/init.el       — Main config (use-package, eglot, corfu)
  lisp/
    init-python.el          # Per-language configs, each required from init.el
    init-java.el
    init-javascript.el
    init-rust.el
    init-r.el
    init-matlab.el
    init-yaml.el
```

Chezmoi naming conventions: `dot_` becomes `.`, and `.tmpl` files are rendered as Go templates. See [source state attributes](https://www.chezmoi.io/reference/source-state-attributes/).

## Usage

### Prerequisites

- macOS with zsh
- [MacPorts](https://www.macports.org/install.php)
- Emacs 29+
- [chezmoi](https://www.chezmoi.io/install/)

### Initial setup

```sh
# Install chezmoi
sudo port install chezmoi

# Initialize from this repository (prompts for email)
chezmoi init <git-remote-url>

# Preview what will change
chezmoi diff

# Apply the dotfiles
chezmoi apply
```

On first Emacs launch, `use-package` will automatically download and install all packages from MELPA (takes 1-2 minutes).

### LSP servers

Eglot requires language servers to be installed separately:

```sh
pip install python-lsp-server  # Python
rustup component add rust-analyzer  # Rust
```

### Storing secrets

```sh
# Add a secret
security add-generic-password -U -a "$USER" -s "SECRET_NAME" -w "value"

# Verify it works
security find-generic-password -s "SECRET_NAME" -w
```

## Keeping the configuration up to date

### Editing dotfiles

Always edit through chezmoi so changes go to the template source, not the rendered target:

```sh
# Edit a managed file (opens the template source)
chezmoi edit ~/.zshrc

# Or edit source files directly
cd $(chezmoi source-path)
```

After editing, apply and commit:

```sh
chezmoi diff                # Review pending changes
chezmoi apply               # Render templates to home directory
```

### Pulling updates on another machine

```sh
chezmoi update              # git pull + chezmoi apply in one step
```

### Adding a new dotfile

```sh
chezmoi add ~/.some_config  # Copies the file into the chezmoi source directory
```

To make it a template (for OS-specific logic or variable substitution):

```sh
chezmoi add --template ~/.some_config
```

### Updating language resources

#### Language runtimes (mise)

mise manages Node.js and Java versions. To update:

```sh
mise ls                     # See installed versions
mise ls-remote node         # See available versions
mise use node@22            # Install and pin a new version
```

Version pins are stored in `.mise.toml` (or `.tool-versions`) in your project or home directory. See [mise languages](https://mise.jdx.dev/lang/).

#### Python

Python versions are primarily managed via [MacPorts](https://www.macports.org/).

```sh
port search --name --line python3  # List available Python versions in MacPorts
port select --list python           # List installed versions available for selection
sudo port install python313       # Install a specific Python version
sudo port upgrade python313       # Upgrade it
sudo port select --set python3 python313  # Set the default python3
```

Per-project dependencies use virtual environments (`python3 -m venv`), sometimes with [Poetry](https://python-poetry.org/) for dependency resolution and lock files.

- [venv docs](https://docs.python.org/3/library/venv.html)
- [Poetry docs](https://python-poetry.org/docs/)

```sh
python3 -m venv .venv && source .venv/bin/activate  # Standard venv
poetry install                                       # Poetry-managed project
```

- [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/index.html) (Miniconda) is also available and initialized in `.zshenv`, but is used less frequently. The project aliases in `~/.zsh_projects` activate the appropriate venv or Conda environment for each project.
- [Conda user guide](https://docs.conda.io/projects/conda/en/latest/user-guide/index.html)

#### Rust (rustup)

Rust is managed via [rustup](https://rust-lang.github.io/rustup/), with `~/.cargo/bin` on PATH (set in `.zshenv`):

```sh
rustup update               # Update Rust toolchain and rust-analyzer
rustup show                 # Show installed toolchains and active version
```

See [rustup book](https://rust-lang.github.io/rustup/).

#### R (MacPorts)

R is installed and updated through MacPorts:

```sh
sudo port upgrade R          # Upgrade R to the latest available version
sudo port installed R        # Check installed version
```

See [R on MacPorts](https://ports.macports.org/port/R/).

#### MATLAB

MATLAB is installed separately outside of this dotfiles setup. Update it through the MathWorks installer or MATLAB's built-in update mechanism. The Emacs `matlab-mode` package (managed via use-package/MELPA) provides editor integration.

#### LSP servers

Eglot relies on external language servers. Update them with their respective package managers:

```sh
pip install --upgrade python-lsp-server   # Python
rustup update                             # Rust (includes rust-analyzer)
```

Eglot discovers servers by executable name on `PATH`. To check which server eglot is using for a buffer, run `M-x eglot-show-workspace-configuration` in Emacs. See [eglot server programs](https://www.gnu.org/software/emacs/manual/html_node/eglot/Setting-Up-LSP-Servers.html).

#### Emacs packages

Packages installed by `use-package` from MELPA can be updated from within Emacs:

```
M-x package-refresh-contents    ; Fetch latest package listings
M-x package-upgrade-all         ; Upgrade all installed packages (Emacs 29+)
```

Or selectively via `M-x package-list-packages`, then `U` to mark upgrades and `x` to execute. See [package management](https://www.gnu.org/software/emacs/manual/html_node/emacs/Package-Installation.html).

### Committing changes

```sh
chezmoi cd                  # Jump to the source directory
git add -A && git commit -m "description of change"
git push
```

Or without leaving your current directory:

```sh
chezmoi git -- add -A
chezmoi git -- commit -m "description of change"
chezmoi git -- push
```
