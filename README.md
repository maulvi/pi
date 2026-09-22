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
- Oh My Pi (OMP)
- GitHub CLI
- Docker + Compose
- Python + venv
- Rust
- tmux configuration
- ripgrep, fd, fzf, jq, shellcheck
- global Pi AGENTS.md
- verification script

Pi and OMP are installed as separate CLIs:

    pi
    omp

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

or:

    omp

Inside the agent, authenticate/configure the provider according to the agent's setup flow.

Pi and OMP are intentionally kept separate so either CLI can be used for different workflows.
Community extensions/packages should be installed separately after reviewing their source.
