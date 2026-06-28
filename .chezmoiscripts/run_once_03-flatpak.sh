#!/usr/bin/env bash
set -euo pipefail

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.vysp3r.Vesktop
flatpak install -y flathub app.tintero.Tintero
