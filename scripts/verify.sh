#!/usr/bin/env bash
set -u

check() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'OK   %-12s %s\n' "$1" "$("$1" --version 2>/dev/null | head -n1)"
  else
    printf 'MISS %-12s\n' "$1"
  fi
}

for cmd in git curl node npm bun python3 cargo docker gh rg fd fzf jq tmux pi omp; do
  check "$cmd"
done
