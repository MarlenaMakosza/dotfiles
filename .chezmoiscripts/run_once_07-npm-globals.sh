#!/usr/bin/env bash
set -euo pipefail

npm_install() {
  npm install -g "$@"
}

# --- AI / Dev tools ---
npm_install \
  @anthropic-ai/claude-code
