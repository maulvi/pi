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

## Language Playbooks

The global rules stay intentionally small. Language-specific guidance lives under `languages/`:

- `typescript` — TypeScript/Node.js
- `python` — Python
- `rust` — Rust
- `go` — Go
- `java` — Java
- `csharp` — C#
- `cpp` — C++
- `php` — PHP
- `kotlin` — Kotlin
- `bash` — Bash/shell automation

These guides focus on maintainable design, consistent naming, testability, error handling, and performance choices by workload. Project-local conventions always take precedence.

After installation:

    pi

Inside Pi, authenticate with:

    /login

Pi is intentionally kept minimal. Community extensions/packages should be installed separately after reviewing their source.
