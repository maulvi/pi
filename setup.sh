#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

log() { printf '\n==> %s\n' "$*"; }
warn() { printf '\n[!] %s\n' "$*" >&2; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename -- "${BASH_SOURCE[0]}")"

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

if [[ ! -r /etc/os-release ]] || ! . /etc/os-release || [[ "${ID:-}" != "debian" ]]; then
  warn "This installer supports Debian only."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required."
  exit 1
fi

AGENT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent)
      if [[ $# -lt 2 ]]; then
        warn "--agent requires pi or omp."
        exit 1
      fi
      AGENT="${2,,}"
      shift 2
      ;;
    --agent=*)
      AGENT="${1#*=}"
      AGENT="${AGENT,,}"
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: ./setup.sh [--agent pi|omp]

Without --agent, the installer prompts for the coding agent.
EOF
      exit 0
      ;;
    *)
      warn "Unknown argument: $1"
      exit 1
      ;;
  esac
done

case "$AGENT" in
  pi|omp)
    ;;
  "")
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
    ;;
  *)
    warn "Invalid agent: $AGENT (use pi or omp)."
    exit 1
    ;;
esac

log "Installing Debian packages"
sudo apt-get update
sudo apt-get install -y \
  build-essential git git-lfs curl wget unzip zip tar gzip ca-certificates \
  gnupg jq ripgrep fd-find fzf tree tmux htop btop rsync direnv \
  openssh-client openssh-server procps file less man-db shellcheck pkg-config \
  python3 python3-pip python3-venv pipx zsh neovim bash-completion \
  dnsutils iproute2 iputils-ping lsof netcat-openbsd socat strace \
  gh kitty-terminfo

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

log "Installing Herdr"
curl -fsSL https://herdr.dev/install.sh | sh
export PATH="$HOME/.local/bin:$HOME/.local/share/herdr/bin:$PATH"

log "Installing RTK"
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
export PATH="$HOME/.local/bin:$HOME/.local/share/rtk/bin:$PATH"

case "$AGENT" in
  pi)
    log "Installing Pi Coding Agent"
    if ! command -v npm >/dev/null 2>&1; then
      warn "npm is not available in this shell."
      exit 1
    fi
    npm install -g @mariozechner/pi-coding-agent
    AGENT_DIR="$HOME/.pi/agent"
    ;;
  omp)
    log "Installing Oh My Pi (OMP)"
    if ! command -v bun >/dev/null 2>&1; then
      warn "Bun is not available in this shell."
      exit 1
    fi
    bun install -g @oh-my-pi/pi-coding-agent
    AGENT_DIR="$HOME/.omp/agent"
    ;;
esac

log "Installing global agent instructions for ${AGENT^^}"
mkdir -p "$AGENT_DIR"
install -m 0644 "$SCRIPT_DIR/AGENTS.md" "$AGENT_DIR/AGENTS.md"

log "Installing tmux configuration"
mkdir -p "$HOME/.config/tmux"
install -m 0644 "$SCRIPT_DIR/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"

log "Enabling OpenSSH server"
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable --now ssh
else
  warn "systemctl is not available; OpenSSH server was installed but not enabled automatically."
fi

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
printf '  %s/scripts/verify.sh --agent %s\n' "$SCRIPT_DIR" "$AGENT"
printf '  %s\n' "$AGENT"
