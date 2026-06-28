# Przewodnik jak wywalić okno przez okno (czyli pokazanie środkowego palca microshitowi

## pacman
pkgconf fakeroot

```zsh
sudo pacman -Sy pkgconf fakeroot base-devel yayZ docker docker-compose rawtherapee signal-desktop gimp krita obs-studio dbeaver texstudio git neovim emacs okular keepassxc calibre handbrake steam blender meld ffmpeg inotify-tools freecad deno putty starship pandoc nushell scribus r audacity vlc bleachbit firefox-developer-edition yt-dlp argyllcms p7zip solaar zed figlet terraform exa gparted mangohud goverlay xca sweethome3d bridge-utils nm-connection-editor lutris ripgrep fd podman distrobox lld resources pdfgrep protonup-qt smartmontools ethtool restic headsetcontrol testdisk fdupes keyd gocryptfs vivaldi chezmoi topupgrade zoxide atuin
```

if needed droidcam linux612-headers

## yay
```zsh
yay -Sy zen-browser-bin brave-bin ferdium-bin fsearch github-desktop-bin heroic-games-launcher-bin librewolf-bin rustdesk-bin triliumnext-bin yubico-authenticator-bin cryptomator-bin megasync-bin vscodium-bin opera-bin penpot-desktop-bin rstudio-desktop-bin pear-desktop hoppscotch-bin vesktop-bin zoom streamcontroller kwin-scripts-krohnkite raindrop minecraft-launcher streamripper parabolic onlyoffice-bin droidcam clementine friction anki-bin proton-ge-custom-bin xpipe-bin freefilesync-bin kdotool krokiet-bin koboldcpp-bin lazyworktree-bin zoter-bin
```
// Tylko w wolnym czasie bo to długo ciągnie
texlive-full

https://twinery.org
https://jazz.net/forum/questions/120022/planning-stories-and-tasks-in-rtc

Mango juice czy mango hud?

## INNE

### docker w autostartcie

sudo systemctl enable docker.service

### Wake up on LAN on manjaro

Install ethtool

```zsh
sudo pacman -S ethtool
```

Sprawdź karty sieciowe
ip link

Weź koniecznie ETHERNET - wifi nie zadziała

```zsh
> sudo ethtool enp7s0
...
Supports Wake-on: g
Wake-on: d
...
```

Włącz wake-on
```zsh
sudo ethtool -s enp7s0 wol g
```

Sprawdź czy załapało
```zsh
> sudo ethtool enp133s0 | grep Wake-on
# Ma być
Wake-on: g
```
Podobno to zniknie po reboocie więc
```zsh
sudo nano /etc/systemd/system/wol.service
```
Wklej
```zsh
[Unit]
Description=Enable Wake-on-LAN
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/ethtool -s enp133s0 wol g

[Install]
WantedBy=multi-user.target
```
Aktywuj
```zsh
sudo systemctl daemon-reload
sudo systemctl enable wol.service
```
Test
```zsh
sudo systemctl start wol.service
```
Finalny test
Wyłącz komputer. Skonfiguruj apkę w telefonie adresem mac, IP kompa nie jest konieczne można użyć broadcastu, wol port standardowy to 9. Reszta ustawień opcjonalna

### Mouseless

Na archu
```
sudo tee /etc/udev/rules.d/99-mouseless-input.rules <<EOF
# Output: Virtual device creation
KERNEL=="uinput", GROUP="$USER", MODE:="0660"

# Input: Physical device reading
KERNEL=="event*", GROUP="$USER", NAME="input/%k", MODE:="0660"
EOF

sudo udevadm control --reload-rules && sudo udevadm trigger

```

Logout and login

### Space Engineers

Zainstaluj proton-ge-custom-bin

I

protonplus

### Steam nie czyta gierek z drugiego dysku, który był z windą związany

Źle podpięte bez opcji odpowiednich

uid=1000,gid=1000,umask=022,windows_names,noatime,x-gvfs-show

### QEMU/KVM

#### Instalacja

Żeby autostart był to opróczna VMce to jeszcze w connectionie (QEMU/KVM na przykład) Ustawić autoconnect

https://getlabsdone.com/how-to-install-proxmox-on-kvm-hypervisor/

```zsh
sudo pacman -Syu qemu virt-manager libvirt dnsmasq ebtables iptables-nft
sudo usermod -aG libvirt $USER
sudo systemctl enable --now libvirtd
sudo systemctl enable --now pcscd
```

Note!
Odpalałam qemu/kvm żeby zainstalować win11 - nie działało uznawał, że nie ma iso, które mu wrzucam
I tam w tym trzeba wybrać jaki jest "bazowy' system, to wybierałam grzecznie 11
Nie działało
Ale jak wybrałam, że instaluję 10, a iso 11 to nagle się normalnie odpaliło bez żadnego ale xDD

### Yubikey authenticator

sudo systemctl enable --now pcscd

#### Wspólny schowek VM i host

VM ma używać SPICE channel

W virt-manager:

VM → Details powinien być wpis Display Spice

Dodać Channel Spice

VM → Add Hardware → Channel
Wybierz: org.spice-space.webdav.0

3️⃣ Zainstaluj w gościu (Arch)

W VM:

sudo pacman -S spice-vdagent

Włącz usługę:

sudo systemctl enable spice-vdagentd
sudo systemctl start spice-vdagentd

Sprawdź czy działa:

systemctl status spice-vdagentd

Reboot VMki


## INNE PC

Anki - dla audio należy doinstalować

sudo pacman -S mpv

### StreamController - for stream deck

Instalować z flatpacka bo się wysypał przy aktualizacji pluł się o pythona

Import settings from directory com.core447.StreamController

### Keymap

https://github.com/zsa/wally/wiki/Linux-install

BUT look at keymapp.md in parent folder of this file [Keymap](./keymapp.md)

### Electron (i965)

sudo pacman -S libva-intel-driver intel-media-driver

### PBS ale to export z hyper-v... a nie, tępaki z microshitu postanowili podzielić pliki... bo mam odpalone jakos checkpointy

#### merge maszyny ze checkpointami

PS C:\ProgramData\Microsoft\Windows\Virtual Hard Disks> merge-vhd -Path .\pbs_74964632-3E40-4CCB-BA21-C6479D9133CC.avhdx -DestinationPath .\pbs.vhdx

#### Wyączenie AUTOMATYCZNYCH CHECKPOINTOW

Get-VM | Set-VM -AutomaticCheckPointsEnabled $flase

#### podlinkowanie checkpointow

Set-VHD -Path child_disk.avhdx -ParentPath parent_disk.vhdx -IgnoreIdMismatch

### PBS konwersja maszyny z Hyper-V do kvm/qemu

sudo qemu-img convert -f vhdx -O qcow2 -c pbs.vhdx pbs.qcow2

### PBS on kvm/qemu and other bridge

https://www.youtube.com/watch?v=XWC02K9_5Ws

- upewnij się, że export/zmiany sieci nie zmieniły ci interfejsu w virtual maszynie

config jak na [zdjęciu](config_vm_vmm_kvm_qemu.png)

ifreload -a

systemctl status NetworkManager

ip link show enp7s0

ip link set enp7s0 up


### yt-dlp nie chciał pobierać filmów tylko dźwięk

  Komendy których użyłem:

  1. Sprawdzenie czy yt-dlp jest zainstalowane:

  which yt-dlp

  2. Pierwsza nieudana próba (tylko audio):

  cd ~
  yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 --restrict-filenames -o "%(title)s.%(ext)s" "URL"

  3. Sprawdzenie dostępnych formatów:

  yt-dlp --list-formats "URL"

  4. Poprawna komenda (z automatycznym pobieraniem komponentów):

  yt-dlp --remote-components ejs:github -f "bestvideo+bestaudio/best" --merge-output-format mp4 --restrict-filenames -o "%(title)s.%(ext)s" "URL"

  Do notatek:

  # Pobieranie YouTube w najwyższej jakości z automatycznym rozwiązywaniem challengów:
  yt-dlp --remote-components ejs:github -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "%(title)s.%(ext)s" "YOUTUBE_URL"

  # Jeśli chcesz zawsze używać tej flagi, dodaj do ~/.config/yt-dlp/config:
  echo "--remote-components ejs:github" >> ~/.config/yt-dlp/config

  Flaga --remote-components ejs:github pobiera skrypt solver z GitHub, który rozwiązuje JavaScript challenges YouTube, dzięki czemu możesz pobierać wszystkie formaty wideo.

### DaVinci Resolve

Bazowane na: https://www.youtube.com/watch?v=LFDx9emOzEc

DLA GPU AMD NIE PRÓBOWAĆ opencl-mesa, TYLKO rocm-opencl-runtime
```zsh
sudo pacman -S --needed rocm-opencl-runtime ocl-icd clinfo
```
Pobrać DaVinci najnowszą wersję - normalnie od nich ze strony.

Rozpakować

Odpalić to tak i przed odpaleniem wejść do tej ścieżki i zrobić co komenda mówi:

```zsh
SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_20.3.1_Linux.run

cd /opt/resolve/libs/ && sudo mkdir disabled-libraries && sudo mv libglib* libgio* libgmodule* disabled-libraries
```

#### konwersja do DNxHR

ffmpeg -i input.mp4 -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p output.mov

#### wersja lżejsza

ffmpeg -i input.mp4 -c:v dnxhd -profile:v dnxhr_sq output.mov

### R

Doinstalować gcc fortana

### Unreal Engine

1. Nie pobierać z prebuildu - brakuje mu tylu plików, że to nieśmieszny żart (A 30GB dziadostwo waży)

2. Nie z AURa, bo ten nie działa po prostu

3. Instalować to ze źródeł, u mnie poszła instalacja bez problemów

Ale co dziwne u mnie się dzieje, to że na większość rzeczy muszę klikać 2 razy, żeby załapało, albo wgl nie łapie jak klikam w menu myszą i trzeba klawiaturą zatwierdzić i okna zamiast pojawiać się zaraz obok klikniętego przycisku to na środku ekranu

Przedziwne rzeczy, ale udaje jakoś, że działa

### DroidCam

Sprawdź kernel
uname -r
mhwd-kernel -li

Zainstaluj odpowiednie headery

sudo pacman -S linux612-headers
sudo pacman -S base-devel dkms

Zainstaluj
sudo pacman -S v4l2loopback-dkms

Odpal
sudo modprobe v4l2loopback

Odpal droidcama

## INNE LAPTOP

### Touchpad gestures

touchpad gestures https://github.com/NayamAmarshe/ToucheggKDE/blob/main/touchegg.conf

### Electron (because nvidia - nouveau)

sudo pacman -S nvidia-utils

nvidia-smi

## To research

- easyeffects
