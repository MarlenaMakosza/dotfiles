#!/usr/bin/env bash
set -euo pipefail

# texlive-full conflicts with smaller texlive-* packages preinstalled on Manjaro.
# Skip if already installed (AUR texlive-full provides texlive-basic/bin).
if pacman -Qi texlive-full &>/dev/null; then
  echo "texlive-full already installed, skipping"
  exit 0
fi

# Remove official texlive-basic/texlive-bin only if literally installed under that name.
conflicting=(texlive-basic texlive-bin)
installed=()
for pkg in "${conflicting[@]}"; do
  if pacman -Qq "$pkg" 2>/dev/null | grep -qx "$pkg"; then
    installed+=("$pkg")
  fi
done

if [ "${#installed[@]}" -gt 0 ]; then
  sudo pacman -Rdd --noconfirm "${installed[@]}"
fi

paru -S --noconfirm --needed texlive-full
