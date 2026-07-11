#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "/home/$INSTALL_USER/.config/emacs" ]; then
  sudo -u "$INSTALL_USER" git clone --depth 1 https://github.com/doomemacs/doomemacs "/home/$INSTALL_USER/.config/emacs"
fi

set +o pipefail
yes | sudo -u "$INSTALL_USER" "/home/$INSTALL_USER/.config/emacs/bin/doom" install --no-env
doom_exit="${PIPESTATUS[1]}"
set -o pipefail
exit "$doom_exit"
