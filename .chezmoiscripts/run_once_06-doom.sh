#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "$HOME/.config/emacs" ]; then
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
fi

set +o pipefail
yes | "$HOME/.config/emacs/bin/doom" install --no-env
doom_exit="${PIPESTATUS[1]}"
set -o pipefail
exit "$doom_exit"
