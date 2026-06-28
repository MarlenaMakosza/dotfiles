#!/usr/bin/env bash
set -euo pipefail

pacman_install() {
  sudo pacman -S --noconfirm --needed "$@"
}

# --- Base build tools (needed for AUR fallback + general use) ---
pacman_install \
  base-devel \
  git \
  pkgconf \
  fakeroot \
  # lld

# --- Terminal / Shell ---
pacman_install \
  atuin \
  exa \
  fd \
  kitty \
  lazygit \
  fastfetch \
  zoxide \
  btop \
  htop \
  figlet \
  tree \
  jq \
  ripgrep \
  yt-dlp \
  rsync \
  fdupes \
  inotify-tools \
  pdfgrep \
  7zip

# --- Edytory ---
pacman_install \
  vim \
  neovim \
  emacs \
  micro \
  meld

# --- Dev tools ---
pacman_install \
  go \
  deno \
  dotnet-sdk \
  typescript \
  npm \
  pnpm \
  github-cli \
  docker \
  docker-compose \
  distrobox \
  qemu-full \
  virt-manager \
  libvirt \
  dbeaver \
  smartmontools \
  ethtool \
  testdisk \
  worktrunk
  # bridge-utils \
  # nm-connection-editor \
  # podman \
  # terraform \


# --- Multimedia / Creative ---
pacman_install \
  obs-studio \
  kdenlive \
  blender \
  gimp \
  inkscape \
  freecad \
  rawtherapee \
  scribus \
  synfigstudio \
  vlc \
  mpv \
  ffmpeg \
  argyllcms \
  sweethome3d
  # audacity \
  # krita \
  # handbrake \

# --- AI / ML ---
# pacman_install \
  # ollama-rocm

# --- Gry ---
pacman_install \
  steam \
  lutris \
  wine \
  winetricks \
  wine-gecko \
  wine-mono
  # prismlauncher \

# --- Biuro / Docs ---
pacman_install \
  libreoffice-fresh \
  onlyoffice-desktopeditors \
  calibre \
  foliate \
  okular \
  pandoc-cli \
  texstudio \
  firefox-developer-edition
  # texlive-full \

# --- KDE Apps ---
pacman_install \
  filelight \
  hardinfo2 \
  kalarm \
  spectacle

# --- System / Backup / Security ---
pacman_install \
  ufw \
  snapper \
  grub-btrfs \
  timeshift \
  topgrade \
  bleachbit \
  gparted \
  keepassxc \
  xca \
  sbctl \
  wireshark-qt \
  vivaldi \
  resources \
  # lact \
  # headsetcontrol \
  # solaar \
  # keyd \
  # gocryptfs \
  # protonup-qt \

# --- Remote / Transfer ---
pacman_install \
  remmina \
  putty \
  sshfs \
  scrcpy \
  deskflow

# --- Komunikacja ---
pacman_install \
  signal-desktop

# --- Misc ---
pacman_install \
  chromium \
  chezmoi \
  anki \
  wofi
  # paru
  # waydroid \
