#!/usr/bin/env bash
set -u

AGENT=""
if [[ "${1:-}" == "--agent" ]]; then
  AGENT="${2:-}"
elif [[ "${1:-}" == --agent=* ]]; then
  AGENT="${1#--agent=}"
elif [[ -n "${1:-}" ]]; then
  AGENT="$1"
fi

case "$AGENT" in
  pi|omp) ;;
  *)
    printf 'Usage: %s --agent pi|omp\n' "$0" >&2
    exit 2
    ;;
esac

# Include common user-local install locations. Not every tool is installed
# through APT or placed in a system PATH.
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/go/bin:$HOME/.local/share/fnm:$HOME/.fnm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

# fnm-managed Node/npm may need its shell environment initialized.
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash 2>/dev/null)" || true
fi

missing=0

check() {
  local name="$1"
  local path
  path="$(command -v "$name" 2>/dev/null || true)"

  if [[ -n "$path" ]]; then
    printf 'OK   %-22s %s\n' "$name" "$path"
    return
  fi

  printf 'MISS %-22s\n' "$name"
  missing=1
}

check_compose() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    printf 'OK   %-22s %s\n' "docker-compose" "$(docker compose version 2>/dev/null | head -n1)"
  else
    printf 'MISS %-22s\n' "docker-compose"
    missing=1
  fi
}

for cmd in git curl node npm bun python3 php go rust-analyzer gopls phpactor bash-language-server clangd composer cargo docker gh rg fd fzf jq herdr rtk; do
  check "$cmd"
done

check_compose
check "$AGENT"
check_path() {
  local name="$1"
  shift
  local candidate
  for candidate in "$@"; do
    if [[ -x "$candidate" ]]; then
      printf 'OK   %-22s %s\n' "$name" "$candidate"
      return
    fi
  done
  printf 'MISS %-22s\n' "$name"
  missing=1
}

check_path php-fpm8.5 /usr/sbin/php-fpm8.5
check_path sshd /usr/sbin/sshd

if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-active --quiet php8.5-fpm; then
    printf 'OK   %-22s active\n' "php8.5-fpm"
  else
    printf 'MISS %-22s inactive\n' "php8.5-fpm"
    missing=1
  fi

  if systemctl is-active --quiet ssh; then
    printf 'OK   %-22s active\n' "ssh-service"
  else
    printf 'MISS %-22s inactive\n' "ssh-service"
    missing=1
  fi
fi

exit "$missing"
