#!/usr/bin/env bash
set -euo pipefail

aur_install() {
  paru -S --noconfirm --needed "$@"
}

# --- Przeglądarki ---
aur_install \
  brave-bin \
  librewolf-bin \
  zen-browser-bin \
  opera

# --- Edytory / IDE ---
aur_install \
  vscodium-bin \
  jetbrains-toolbox \
  zed-preview-bin

# --- AI / ML ---
# aur_install \
#   koboldcpp-bin \
#   llmfit-bin

# --- Creative ---
aur_install \
  caesium-image-compressor-bin
  # aseprite \
  # friction \
  # pixieditor-bin \
  # krokiet-bin

# --- Gry ---
aur_install \
  heroic-games-launcher-bin \
  # proton-ge-custom-bin \
  # protonplus \
  # minecraft-launcher

# --- Produktywność / Notatki ---
aur_install \
  joplin-bin \
  triliumnext-bin \
  zotero-bin \
  raindrop
  # novelwriter \
  # superproductivity-bin \

# --- Komunikacja ---
# aur_install \
#   vesktop-bin
  # ferdium-bin \
  # zoom \

# --- System / Tools ---
aur_install \
  megasync-bin \
  cryptomator-bin \
  rustdesk-bin \
  xpipe-bin \
  fsearch \
  lazyworktree-bin \
  yubico-authenticator-bin
  # wl-kbptr
  # czkawka-gui-bin \
  # weylus-bin \

# --- KDE extras ---
aur_install \
  kwin-scripts-krohnkite \
  kdotool \
  # xwaylandvideobridge

# --- Dev / Design ---
aur_install \
  penpot-desktop-bin \
  parabolic

# --- Media / Other ---
aur_install \
  streamripper \
  foobar2000
  # bottles \

# --- Fonts ---
aur_install \
  ttf-ms-fonts
