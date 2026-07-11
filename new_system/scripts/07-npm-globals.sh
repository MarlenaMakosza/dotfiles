#!/usr/bin/env bash
set -euo pipefail

npm_install() {
  sudo -u "$INSTALL_USER" env NPM_CONFIG_PREFIX="/home/$INSTALL_USER/.local/share/npm-global" npm install -g "$@"
}

# --- AI / Dev tools ---
npm_install \
  @anthropic-ai/claude-code
