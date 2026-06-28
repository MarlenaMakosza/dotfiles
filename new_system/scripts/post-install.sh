#!/usr/bin/env bash
# Orchestrator — runs all post-install steps independently.
# One step failing does not stop the rest.

INSTALL_USER="lenerystia"
DOTFILES_REPO="https://github.com/MarlenaMakosza/dotfiles"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="/root/post-install-errors.log"

export INSTALL_USER DOTFILES_REPO

FAILED_STEPS=()

run_step() {
  local name="$1"
  local script="$2"
  echo ""
  echo ">>> [$name]"
  if bash "$SCRIPT_DIR/$script"; then
    echo "[OK] $name"
  else
    echo "[FAIL] $name — see $LOG"
    echo "[FAIL] $name" >> "$LOG"
    FAILED_STEPS+=("$name")
  fi
}
#
# run_step "pacman"      "01-pacman.sh"
# run_step "aur"         "02-aur.sh"
# run_step "flatpak"     "03-flatpak.sh"
# run_step "services"    "04-services.sh"
run_step "dotfiles"    "05-dotfiles.sh"
run_step "doom"        "06-doom.sh"
# run_step "npm-globals" "07-npm-globals.sh"

echo ""
if [[ ${#FAILED_STEPS[@]} -eq 0 ]]; then
  echo "==============================="
  echo "  Post-install: wszystko OK"
  echo "==============================="
else
  echo "==============================="
  echo "  FAILED:"
  for s in "${FAILED_STEPS[@]}"; do
    echo "    - $s"
  done
  echo "  Log: $LOG"
  echo "==============================="
fi
