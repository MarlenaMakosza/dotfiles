#!/usr/bin/env bash
set -euo pipefail

# texlive-full conflicts with the smaller texlive-basic/texlive-bin
# packages preinstalled on Manjaro; paru refuses to resolve that
# under --noconfirm, so drop them first.
conflicting=(texlive-basic texlive-bin)
installed=()
for pkg in "${conflicting[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    installed+=("$pkg")
  fi
done

if [ "${#installed[@]}" -gt 0 ]; then
  sudo pacman -Rdd --noconfirm "${installed[@]}"
fi

paru -S --noconfirm --needed texlive-full
