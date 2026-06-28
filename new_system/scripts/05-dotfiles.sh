#!/usr/bin/env bash
set -euo pipefail

sudo -u "$INSTALL_USER" chezmoi init --apply "$DOTFILES_REPO"
