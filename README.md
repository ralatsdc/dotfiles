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

The Emacs configuration targets **Emacs 29+** and uses built-in features where possible.

#### Bootstrap

- [use-package](https://www.gnu.org/software/emacs/manual/html_mono/use-package.html) — Declarative package management (built into Emacs 29+). All packages are auto-installed from MELPA on first launch.
- [exec-path-from-shell](https://github.com/purcell/exec-path-from-shell) — Inherits `PATH` and environment variables from your shell so that Emacs finds tools like `ruff`, `pylsp`, `rust-analyzer`, etc.

#### Minibuffer completion: Vertico + Consult + Marginalia

These replace Helm with a lighter stack built on Emacs's native completion API.

- [vertico](https://github.com/minad/vertico) — Vertical minibuffer completion UI. Activates automatically for `M-x`, `C-x C-f`, and anywhere Emacs uses `completing-read`.
- [consult](https://github.com/minad/consult) — Enhanced commands that integrate with Vertico:
  - `C-x b` — `consult-buffer` (switch buffers, recent files, bookmarks)
  - `M-s l` — `consult-line` (search lines in the current buffer)
  - `M-s g` — `consult-grep` (grep across files)
  - `M-s r` — `consult-ripgrep` (ripgrep across files, requires `rg` on PATH)
  - `M-g g` — `consult-goto-line`
- [marginalia](https://github.com/minad/marginalia) — Adds rich annotations (docstrings, file sizes, permissions) to minibuffer candidates.

#### In-buffer completion: Corfu + Cape + Orderless

- [corfu](https://github.com/minad/corfu) — In-buffer completion popup. Auto-triggers after 2 characters with a 0.2s delay. Completion candidates come from eglot (LSP), cape, and other completion-at-point backends.
- [cape](https://github.com/minad/cape) — Extra completion-at-point backends. Configured here with `cape-dabbrev` (words from open buffers) and `cape-file` (file path completion).
- [orderless](https://github.com/oantolin/orderless) — Completion matching style that allows space-separated patterns in any order (e.g., typing `def main` matches `defun-main-loop`). Used by both Vertico (minibuffer) and Corfu (in-buffer).

#### LSP: Eglot

- [eglot](https://www.gnu.org/software/emacs/manual/html_mono/eglot.html) — Built-in LSP client (Emacs 29+). Starts automatically in Python, Rust, JavaScript, and Java buffers. Provides completions, hover docs, go-to-definition, diagnostics, and formatting.
  - `M-.` — Go to definition
  - `M-?` — Find references
  - `C-h .` — Show hover documentation
  - `M-x eglot-rename` — Rename symbol
  - `M-x eglot-format-buffer` — Format the buffer (runs automatically on save for Python)
  - `M-x eglot-code-actions` — Show available code actions

#### Python tooling in Emacs

- [python-lsp-server](https://github.com/python-lsp/python-lsp-server) — The LSP server eglot uses for Python. Provides completions, hover, go-to-definition.
- [python-lsp-ruff](https://github.com/python-lsp/python-lsp-ruff) — Plugin that delegates linting and formatting to [ruff](https://docs.astral.sh/ruff/) through pylsp. Python files are formatted on save automatically.
- [pyvenv](https://github.com/jorgenschaefer/pyvenv) — Virtual environment support. Activates venvs so eglot and other tools see project dependencies. Use `M-x pyvenv-activate` to activate a venv, or `M-x pyvenv-workon` for named environments.

Install the Python LSP stack with:
```sh
pip install python-lsp-server python-lsp-ruff ruff
```

#### Version control

- [magit](https://magit.vc/) — Git interface. `C-x g` opens magit-status showing staged/unstaged changes, with key-driven commands for committing, branching, pushing, rebasing, etc. See the [magit cheatsheet](https://magit.vc/manual/magit-refcard.pdf).

#### Syntax checking

- [flycheck](https://www.flycheck.org/) — On-the-fly syntax checking. Enabled globally. Shows errors/warnings inline. Works alongside eglot diagnostics. See [flycheck languages](https://www.flycheck.org/en/latest/languages.html).

#### Snippets

- [yasnippet](https://github.com/joaotavora/yasnippet) — Template/snippet expansion. Type a snippet key and press `TAB` to expand. `M-x yas-describe-tables` lists available snippets for the current mode. See [snippet development](https://joaotavora.github.io/yasnippet/snippet-development.html).

#### Language modes

- Built-in `js-mode` / `js-ts-mode` — JavaScript editing. Eglot provides completions, diagnostics, and formatting via [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) (`npm install -g typescript-language-server typescript`).
- [rust-mode](https://github.com/rust-lang/rust-mode) + [flycheck-rust](https://github.com/flycheck/flycheck-rust) — Rust editing with flycheck integration
- [ess](https://ess.r-project.org/) — Emacs Speaks Statistics, for R. Provides an interactive R console (`M-x R`), code evaluation (`C-c C-c` sends region/line to R), and object inspection. See [ESS manual](https://ess.r-project.org/Manual/ess.html).
- [yaml-mode](https://github.com/yoshiki/yaml-mode) — YAML syntax highlighting and indentation
- [matlab-mode](https://github.com/mathworks/Emacs-MATLAB-Mode) — MATLAB editing

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
