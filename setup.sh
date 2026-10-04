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

# Detect tools installed in the user's home directory before installing anything.
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/go/bin:$HOME/.local/share/fnm:$HOME/.fnm:$HOME/.local/share/herdr/bin:$HOME/.local/share/rtk/bin:$HOME/.config/composer/vendor/bin:$HOME/.npm-global/bin:$PATH"
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash 2>/dev/null)" || true
fi

if [[ ! -r /etc/os-release ]] || ! . /etc/os-release || [[ "${ID:-}" != "debian" ]]; then
  warn "This installer supports Debian only."
  exit 1
fi

DEBIAN_MAJOR="${VERSION_ID%%.*}"
if [[ ! "$DEBIAN_MAJOR" =~ ^[0-9]+$ ]] || (( DEBIAN_MAJOR < 13 )); then
  warn "Debian 13 or newer is required for the current language-server toolchain."
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

log "Configuring PHP repository"
sudo apt-get update
sudo apt-get install -y lsb-release ca-certificates curl
sudo curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
sudo dpkg -i /tmp/debsuryorg-archive-keyring.deb
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
sudo apt-get update

if ! apt-cache show php8.5-cli >/dev/null 2>&1 || ! apt-cache show php8.5-fpm >/dev/null 2>&1; then
  warn "PHP 8.5 packages are not available for this Debian release from packages.sury.org."
  exit 1
fi

log "Installing Debian packages"
sudo apt-get install -y \
  build-essential git git-lfs curl wget unzip zip tar gzip ca-certificates \
  gnupg jq ripgrep fd-find fzf tree htop btop rsync direnv \
  openssh-client openssh-server procps file less man-db shellcheck pkg-config \
  python3 python3-pip python3-venv pipx zsh neovim bash-completion \
  dnsutils iproute2 iputils-ping lsof netcat-openbsd socat strace \
  php8.5-cli php8.5-fpm php8.5-mbstring \
  clangd \
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

log "Installing Go"
curl -sL https://git.io/go-installer | bash
export GOROOT="${GOROOT:-$HOME/.go}"
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$GOROOT/bin:$GOPATH/bin:$HOME/.local/bin:$PATH"

log "Installing Go LSP"
go install golang.org/x/tools/gopls@latest

log "Installing Rust LSP"
rustup component add rust-src rust-analyzer

log "Installing PHP tooling"
if ! command -v composer >/dev/null 2>&1; then
  EXPECTED_CHECKSUM="$(curl -fsSL https://composer.github.io/installer.sig)"
  curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', '/tmp/composer-setup.php');")"
  if [[ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]]; then
    warn "Composer installer checksum mismatch."
    rm -f /tmp/composer-setup.php
    exit 1
  fi
  php /tmp/composer-setup.php --install-dir="$HOME/.local/bin" --filename=composer
  rm -f /tmp/composer-setup.php
fi

log "Installing Phpactor"
curl -fsSL https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar   -o "$HOME/.local/bin/phpactor"
chmod +x "$HOME/.local/bin/phpactor"

log "Enabling PHP-FPM"
sudo systemctl enable --now php8.5-fpm


log "Installing JavaScript/TypeScript, Python, and Bash LSPs"
npm install -g typescript-language-server typescript@6 pyright bash-language-server

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
