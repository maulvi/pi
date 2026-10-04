#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() { printf '\n==> %s\n' "$*"; }
warn() { printf '\n[!] %s\n' "$*" >&2; }

# Resolve paths relative to this script, not the caller's current directory.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename -- "${BASH_SOURCE[0]}")"

# Support both normal execution (bash setup.sh) and "sudo bash setup.sh".
# If sudo was used, drop back to the invoking user before installing anything
# user-scoped, so fnm, Bun, Rust, shell config, and agent files use their HOME.
if [[ "$(id -u)" -eq 0 ]]; then
  INVOKING_USER="${SUDO_USER:-}"
  if [[ -z "$INVOKING_USER" || "$INVOKING_USER" == "root" ]]; then
    warn "Run as your normal user with sudo access, or use sudo from that user."
    exit 1
  fi
  exec sudo -u "$INVOKING_USER" -H env PI_SETUP_INVOKING_USER="$INVOKING_USER" bash "$SCRIPT_PATH" "$@"
fi

TARGET_USER="${PI_SETUP_INVOKING_USER:-$USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
if [[ -z "$TARGET_HOME" || "$TARGET_HOME" != "$HOME" ]]; then
  warn "Could not resolve the invoking user's home directory safely."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required."
  exit 1
fi

printf 'Which coding agent do you want to install?\n'
printf '  1) Pi Coding Agent\n'
printf '  2) Oh My Pi (OMP)\n'
while true; do
  read -r -p "Select [1/2]: " agent_choice
  case "$agent_choice" in
    1|pi|Pi|PI)
      AGENT="pi"
      break
      ;;
    2|omp|OMP|Omp)
      AGENT="omp"
      break
      ;;
    *)
      warn "Please enter 1 for Pi or 2 for OMP."
      ;;
  esac
done

log "Installing Debian packages"
sudo apt-get update
sudo apt-get install -y \
  build-essential git curl wget unzip zip tar gzip ca-certificates \
  gnupg jq ripgrep fd-find fzf tree tmux htop btop rsync \
  openssh-client procps file less man-db shellcheck pkg-config \
  python3 python3-pip python3-venv zsh neovim \
  gh

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

export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$HOME/.local/bin:$PATH"
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
export PATH="$HOME/.bun/bin:$HOME/.local/bin:$PATH"

log "Installing Rust"
if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

case "$AGENT" in
  pi)
    log "Installing Pi Coding Agent"
    if command -v npm >/dev/null 2>&1; then
      npm install -g @mariozechner/pi-coding-agent
    else
      warn "npm is not available in this shell. Open a new shell and run: npm install -g @mariozechner/pi-coding-agent"
    fi
    AGENT_DIR="$HOME/.pi/agent"
    ;;
  omp)
    log "Installing Oh My Pi (OMP)"
    if command -v bun >/dev/null 2>&1; then
      bun install -g @oh-my-pi/pi-coding-agent
    else
      warn "Bun is not available in this shell. Open a new shell and run: bun install -g @oh-my-pi/pi-coding-agent"
    fi
    AGENT_DIR="$HOME/.omp/agent"
    ;;
esac

log "Installing global agent instructions for ${AGENT^^}"
mkdir -p "$AGENT_DIR"
install -m 0644 "$SCRIPT_DIR/AGENTS.md" "$AGENT_DIR/AGENTS.md"

log "Installing tmux configuration"
mkdir -p "$HOME/.config/tmux"
install -m 0644 "$SCRIPT_DIR/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"

log "Installing latest Docker"
curl -fsSL https://get.docker.com | sudo sh

log "Enabling Docker"
sudo systemctl enable --now docker
if ! id -nG "$TARGET_USER" | tr ' ' '\n' | grep -qx docker; then
  sudo usermod -aG docker "$TARGET_USER"
  warn "Log out and back in before using Docker without sudo."
fi

chmod +x "$SCRIPT_DIR/scripts/verify.sh"

log "Done"
printf '\nOpen a new shell, then run:\n'
printf '  %s/scripts/verify.sh\n' "$SCRIPT_DIR"
if [[ "$AGENT" == "pi" ]]; then
  printf '  pi\n'
else
  printf '  omp\n'
fi
