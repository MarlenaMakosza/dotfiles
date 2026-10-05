#!/usr/bin/env bash
set -euo pipefail

# Opcjonalne narzędzia dla agentów AI. Prefiks "after" = odpala się po wszystkich
# obowiązkowych krokach. Każde narzędzie ma osobne pytanie.

ask() {
  local answer
  read -rp "$1 [y/N] " answer < /dev/tty
  case "$answer" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

# --- codebase-memory-mcp ---
# Usługa codebase-memory-mcp.service jest wdrażana zawsze, ale ma
# ConditionPathExists na binarce, więc bez instalacji po prostu się nie startuje.
if ask "Zainstalować codebase-memory-mcp (graf kodu dla agentów + UI na :9749)?"; then
  # Instaluje do ~/.local/bin i rejestruje MCP w wykrytych agentach (Claude Code, opencode, ...).
  curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash -s -- --ui

  systemctl --user daemon-reload
  systemctl --user enable --now codebase-memory-mcp.service
  echo "codebase-memory-mcp gotowy: http://127.0.0.1:9749"
else
  echo "Pominięto codebase-memory-mcp."
fi

# --- ssgrep ---
# Wyszukiwarka po transkryptach sesji agentów. https://github.com/pshokeen/ssgrep
if ask "Zainstalować ssgrep (wyszukiwanie w historii sesji agentów + MCP)?"; then
  if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
  fi
  uv tool install ssgrep
  # Rejestruje MCP i skill we wszystkich agentach, buduje indeks.
  # Pierwszy run pobiera torch + model ColBERT (kilkaset MB).
  ssgrep init
  echo "ssgrep gotowy."
else
  echo "Pominięto ssgrep."
fi
