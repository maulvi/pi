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

missing=0

check() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'OK   %-12s %s\n' "$1" "$("$1" --version 2>/dev/null | head -n1)"
  else
    printf 'MISS %-12s\n' "$1"
    missing=1
  fi
}

check_compose() {
  if docker compose version >/dev/null 2>&1; then
    printf 'OK   %-12s %s\n' "docker-compose" "$(docker compose version 2>/dev/null | head -n1)"
  else
    printf 'MISS %-12s\n' "docker-compose"
    missing=1
  fi
}

for cmd in git curl node npm bun python3 cargo docker gh rg fd fzf jq tmux herdr rtk; do
  check "$cmd"
done

check_compose
check "$AGENT"

if [[ -x /usr/sbin/sshd ]]; then
  printf 'OK   %-12s %s\n' "sshd" "$(/usr/sbin/sshd -V 2>&1 | head -n1)"
else
  printf 'MISS %-12s\n' "sshd"
  missing=1
fi

if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-active --quiet ssh; then
    printf 'OK   %-12s active\n' "ssh-service"
  else
    printf 'MISS %-12s inactive\n' "ssh-service"
    missing=1
  fi
fi

exit "$missing"
