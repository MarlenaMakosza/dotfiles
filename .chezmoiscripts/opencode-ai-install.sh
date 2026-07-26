#!/usr/bin/env bash
set -euo pipefail

# Wywoływany wyłącznie z run_once_10-opencode-ai.sh po potwierdzeniu.
# Brak prefixu run_once_ celowo — chezmoi go nie odpala automatycznie.
# latexmk zakładany z osobnej instalacji texlive-full (run_once_08-texlive.sh).

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

# --- codebase-memory-mcp ---
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash -s -- --ui

echo "opencode stack gotowy."
