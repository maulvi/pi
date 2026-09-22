#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() { printf '\n==> %s\n' "$*"; }
warn() { printf '\n[!] %s\n' "$*" >&2; }

if [[ "$(id -u)" -eq 0 ]]; then
  warn "Run this script as your normal user with sudo access, not as root."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required."
  exit 1
fi

log "Installing Debian packages"
sudo apt-get update
sudo apt-get install -y \
  build-essential git curl wget unzip zip tar gzip ca-certificates \
  gnupg jq ripgrep fd-find fzf tree tmux htop btop rsync \
  openssh-client procps file less man-db shellcheck pkg-config \
  python3 python3-pip python3-venv zsh neovim \
  github-cli docker.io docker-compose-plugin

log "Configuring local bin"
mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null || \
  printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"

log "Installing fnm"
if ! command -v fnm >/dev/null 2>&1; then
  curl -fsSL https://fnm.vercel.app/install | bash
fi

export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$PATH"
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash)"
  fnm install --lts
  fnm default "$(fnm current)"
else
  warn "fnm is not available in this shell."
fi

log "Installing Bun"
if ! command -v bun >/dev/null 2>&1; then
  curl -fsSL https://bun.sh/install | bash
fi
export PATH="$HOME/.bun/bin:$PATH"

log "Installing Rust"
if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

log "Installing Pi Coding Agent"
if command -v npm >/dev/null 2>&1; then
  npm install -g @mariozechner/pi-coding-agent
else
  warn "npm is not available in this shell. Open a new shell and run: npm install -g @mariozechner/pi-coding-agent"
fi

log "Installing Oh My Pi (OMP)"
if command -v bun >/dev/null 2>&1; then
  bun install -g @oh-my-pi/pi-coding-agent
else
  warn "Bun is not available in this shell. Open a new shell and run: bun install -g @oh-my-pi/pi-coding-agent"
fi

log "Installing Pi global instructions"
mkdir -p "$HOME/.pi/agent"
install -m 0644 AGENTS.md "$HOME/.pi/agent/AGENTS.md"

log "Installing tmux configuration"
mkdir -p "$HOME/.config/tmux"
install -m 0644 config/tmux.conf "$HOME/.config/tmux/tmux.conf"

log "Enabling Docker"
sudo systemctl enable --now docker
if ! groups "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  warn "Log out and back in before using Docker without sudo."
fi

chmod +x scripts/verify.sh

log "Done"
printf '\nOpen a new shell, then run:\n'
printf '  ./scripts/verify.sh\n'
printf '  pi\n'
printf '  omp\n'
