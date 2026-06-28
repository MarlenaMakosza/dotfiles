# dotfiles

Personal dotfiles for Arch Linux + KDE, managed with [chezmoi](https://chezmoi.io).

## Bootstrap (fresh system)

```bash
sudo pacman -S --needed chezmoi git
chezmoi init --apply https://github.com/MarlenaMakosza/dotfiles
```

First run will prompt for:
- Git email & name
- Atuin sync server address
- Projects directory
- PlantUML jar path

`chezmoi apply` runs installation scripts automatically in order:

| Script | What it does |
|--------|-------------|
| `00-bootstrap` | Builds yay from AUR, installs paru via yay |
| `01-pacman` | Official repository packages |
| `02-aur` | AUR packages via paru |
| `03-flatpak` | Flatpak apps from Flathub |
| `04-services` | Enables docker, libvirtd; adds user to groups |
| `06-doom` | Installs Doom Emacs |
| `07-npm-globals` | Global npm packages (claude-code) |
| `08-texlive` | texlive-full from AUR (long install) |
| `09-notes` | Creates autostart with manual post-install checklist |

> `run_once_*` scripts execute only once — chezmoi tracks whether they've already run.

## After install

After `chezmoi apply` finishes, **restart the system**. An autostart window will appear with the manual steps checklist (KeepassXC, MEGA, SSH, Atuin, Timeshift, UFW, etc.).

## What's inside

| Tool | Config |
|------|--------|
| zsh | modular `zshrc.d/`, atuin, zoxide |
| atuin | history sync across machines |
| zed / VSCodium | editor settings |
| wofi | launcher |
| fastfetch | startup info |
| TeX Studio | LaTeX editor |
| Vesktop | Discord client (Vencord) |
| topgrade | system updater |

## Update dotfiles

```bash
chezmoi update
```
