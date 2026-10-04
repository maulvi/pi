# Pi Vibecoding — Debian

A production-friendly Debian bootstrap for Pi Coding Agent or Oh My Pi.

## Install

    git clone https://github.com/maulvi/pi.git
    cd pi
    chmod +x setup.sh
    ./setup.sh

The installer is idempotent and can be run again safely.

For non-interactive installation:

    ./setup.sh --agent pi
    ./setup.sh --agent omp

## Included

- Debian development and debugging tools
- Node.js LTS via fnm
- Bun
- Rust
- Go
- PHP 8.5 CLI + FPM
- Python + venv + pipx
- GitHub CLI + Git LFS
- OpenSSH client + server
- Docker + Compose
- tmux configuration
- ripgrep, fd, fzf, jq, shellcheck
- direnv
- DNS/network troubleshooting tools
- Herdr
- global agent instructions
- verification script

Only the selected coding agent is installed.

After installation:

    ./scripts/verify.sh --agent pi
    # or
    ./scripts/verify.sh --agent omp

Then launch the selected agent:

    pi
    # or
    omp

Inside the agent, authenticate/configure the provider according to its setup flow.

Community extensions/packages should be installed separately after reviewing their source.
