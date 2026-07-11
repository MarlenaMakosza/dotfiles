#!/usr/bin/env bash
set -euo pipefail

unset NPM_CONFIG_PREFIX
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

npm_install() {
  npm install -g "$@"
}

# --- AI / Dev tools ---
npm install -g --allow-scripts=@anthropic-ai/claude-code @anthropic-ai/claude-code
