#!/usr/bin/env bash
set -euo pipefail

read -rp "Zainstalować opencode + stack AI (llama.cpp, texlab, MCP)? [y/N] " answer < /dev/tty

case "$answer" in
  [yY]|[yY][eE][sS])
    bash "$(chezmoi source-path)/.chezmoiscripts/opencode-ai-install.sh"
    ;;
  *)
    echo "Pominięto opencode/AI stack."
    ;;
esac
