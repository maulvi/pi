# Pi Vibecoding — Debian

A production-friendly Debian bootstrap for Pi Coding Agent.

## Install

    git clone https://github.com/maulvi/pi.git
    cd pi
    chmod +x setup.sh
    ./setup.sh

The installer is idempotent and can be run again safely.

## Included

- Debian development tools
- Node.js LTS via fnm
- npm + Pi Coding Agent
- Bun
- GitHub CLI
- Docker + Compose
- Python + venv
- Rust
- tmux configuration
- ripgrep, fd, fzf, jq, shellcheck
- global Pi AGENTS.md
- verification script

After installation:

    pi

Inside Pi, authenticate with:

    /login

Pi is intentionally kept minimal. Community extensions/packages should be installed separately after reviewing their source.
