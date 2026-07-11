#!/usr/bin/env bash
set -euo pipefail

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub dev.vencord.Vesktop
flatpak install -y flathub app.tintero.Tintero

# --- Autostart notes for manual Wine installs ---
NOTES_SCRIPT="/home/$INSTALL_USER/.local/bin/post-install-notes.sh"
AUTOSTART_ENTRY="/home/$INSTALL_USER/.config/autostart/post-install-notes.desktop"

mkdir -p "/home/$INSTALL_USER/.local/bin" "/home/$INSTALL_USER/.config/autostart"

cat > "$NOTES_SCRIPT" <<EOF
#!/usr/bin/env bash
cat <<'NOTES'

============================================
  POST-INSTALL — DO ZROBIENIA RĘCZNIE
============================================

  [Wine] Enterprise Architect
         https://sparxsystems.com/products/ea/

  [Wine] Norwi Presenter
         https://norwi.com

============================================

NOTES
# Self-destruct — odpala się tylko raz
rm -f "$AUTOSTART_ENTRY"
rm -f "$NOTES_SCRIPT"
read -rp "Naciśnij Enter aby zamknąć..."
EOF

chmod +x "$NOTES_SCRIPT"

cat > "$AUTOSTART_ENTRY" <<EOF
[Desktop Entry]
Type=Application
Name=Post-Install Notes
Exec=konsole -e $NOTES_SCRIPT
X-KDE-AutostartScript=true
EOF

chown -R "$INSTALL_USER:$INSTALL_USER" "/home/$INSTALL_USER/.local/bin" "/home/$INSTALL_USER/.config/autostart"
