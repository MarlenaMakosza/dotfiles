#!/usr/bin/env bash
set -euo pipefail

npm_install() {
  sudo -u "$INSTALL_USER" npm install -g "$@"
}

# --- AI / Dev tools ---
npm_install \
  @anthropic-ai/claude-code
