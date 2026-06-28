#!/usr/bin/env bash
set -euo pipefail

git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
yes | "$HOME/.config/emacs/bin/doom" install --no-env
