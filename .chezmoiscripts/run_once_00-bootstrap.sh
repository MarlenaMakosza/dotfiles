#!/usr/bin/env bash
set -euo pipefail

# yay built manually — only AUR helper available at this point
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm
rm -rf /tmp/yay

# paru installed via yay so yay tracks paru updates
yay -S --noconfirm --needed paru
