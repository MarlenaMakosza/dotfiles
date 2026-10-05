#!/usr/bin/env bash
set -euo pipefail

# Opcjonalne. Prefiks "after" = odpala się po wszystkich obowiązkowych krokach.
# Usługa codebase-memory-mcp.service jest wdrażana zawsze, ale ma
# ConditionPathExists na binarce, więc bez instalacji po prostu się nie startuje.

read -rp "Zainstalować codebase-memory-mcp (graf kodu dla agentów + UI na :9749)? [y/N] " answer < /dev/tty

case "$answer" in
  [yY]|[yY][eE][sS]) ;;
  *)
    echo "Pominięto codebase-memory-mcp."
    exit 0
    ;;
esac

# Instaluje do ~/.local/bin i rejestruje MCP w wykrytych agentach (Claude Code, opencode, ...).
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash -s -- --ui

systemctl --user daemon-reload
systemctl --user enable --now codebase-memory-mcp.service

echo "codebase-memory-mcp gotowy: http://127.0.0.1:9749"
