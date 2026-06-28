#!/usr/bin/env bash
set -euo pipefail

sudo -u "$INSTALL_USER" git clone --depth 1 https://github.com/doomemacs/doomemacs /home/"$INSTALL_USER"/.config/emacs
yes | sudo -u "$INSTALL_USER" /home/"$INSTALL_USER"/.config/emacs/bin/doom install --no-env
