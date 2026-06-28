#!/usr/bin/env bash
set -euo pipefail

systemctl enable docker.service
systemctl enable libvirtd.service
usermod -aG docker,libvirt "$USER"
