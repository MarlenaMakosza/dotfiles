#!/usr/bin/env bash
set -euo pipefail

export NPM_CONFIG_PREFIX="$HOME/.local/share/npm-global"

npm_install() {
  npm install -g "$@"
}

# --- AI / Dev tools ---
npm_install \
  @anthropic-ai/claude-code
