#!/usr/bin/env bash
set -euo pipefail

sudo systemctl enable docker.service
sudo systemctl enable libvirtd.service
sudo usermod -aG docker,libvirt "$USER"
