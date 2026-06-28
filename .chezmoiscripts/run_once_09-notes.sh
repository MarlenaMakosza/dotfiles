#!/usr/bin/env bash
set -euo pipefail

NOTES_SCRIPT="$HOME/.local/bin/post-install-notes.sh"
AUTOSTART_ENTRY="$HOME/.config/autostart/post-install-notes.desktop"

mkdir -p "$HOME/.local/bin" "$HOME/.config/autostart"

cat > "$NOTES_SCRIPT" <<'EOF'
#!/usr/bin/env bash
cat <<'NOTES'

============================================
  POST-INSTALL — DO ZROBIENIA RĘCZNIE
============================================

  [KeepassXC]
    przywróć bazę danych (z backupu / MEGA)

  [MEGA Sync]
    zaloguj się i ustaw foldery sync

  [SSH]
    ssh-keygen -t ed25519 -C "twój komentarz"
    skopiuj ~/.ssh/id_ed25519.pub do GitHub/serwera

  [Atuin]
    atuin login
    atuin sync

  [Timeshift]
    ustaw tryb BTRFS, harmonogram i lokalizację snapshotów

  [UFW]
    skonfiguruj reguły pod homelab zanim włączysz:
    sudo ufw allow <port>
    sudo ufw enable

  [Przeglądarka]
    zaloguj się w: Firefox Dev / Brave / Librewolf / Zen

  [Trilium]
    zaloguj się / zsynchronizuj z serwerem

  [Joplin]
    zaloguj się / zsynchronizuj

  [RustDesk]
    ustaw hasło i ID w RustDesk
    skonfiguruj własny serwer jeśli używasz

  [Signal]
    połącz z telefonem

  [Vesktop]
    zaloguj się w Discord

  [KVM / libvirt]
    virsh net-start default
    virsh net-autostart default

  [Wine — do ręcznej instalacji]
    Enterprise Architect  https://sparxsystems.com/products/ea/
    Norwi Presenter       https://norwi.com

  !! ZRESTARTUJ SYSTEM !!
     (grupy docker/libvirt aktywne dopiero po ponownym logowaniu)

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
