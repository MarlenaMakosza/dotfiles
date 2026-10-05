#!/usr/bin/env bash
set -euo pipefail

# latexmk zakładany z osobnej instalacji texlive-full (run_once_08-texlive.sh).

read -rp "Zainstalować opencode + stack AI (llama.cpp, texlab, postgres-mcp)? [y/N] " answer < /dev/tty

case "$answer" in
  [yY]|[yY][eE][sS]) ;;
  *)
    echo "Pominięto opencode/AI stack."
    exit 0
    ;;
esac

pacman_install() {
  sudo pacman -S --noconfirm --needed "$@"
}

# --- opencode + llama.cpp + texlab ---
pacman_install opencode llama-cpp texlab

# --- uv / uvx ---
if ! command -v uv &>/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# --- postgres-mcp: rozgrzej cache uvx (tak wywołuje go opencode.json) ---
# Sam MCP, bez bazy — DATABASE_URI podpinasz do czego akurat chcesz.
# https://github.com/crystaldba/postgres-mcp
uvx postgres-mcp --help &>/dev/null

# codebase-memory-mcp: osobny, opcjonalny skrypt run_once_after_11-agent-tools.sh

echo "opencode stack gotowy."
