# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io), targeting Manjaro Linux / KDE Wayland.

## Install

```bash
chezmoi init --apply https://github.com/MarlenaMakosza/dotfiles.git
```

First run will prompt for:
- Git email & name
- Atuin sync server address
- Projects directory
- PlantUML jar path

## What's inside

| Tool | Config |
|---|---|
| zsh | modular `zshrc.d/`, atuin, zoxide |
| kitty | Nord theme |
| zed / VSCodium | editor settings |
| wofi | launcher (Nord) |
| fastfetch | startup info |
| TeX Studio | LaTeX editor |
| Vesktop | Discord client (Vencord) |
| topgrade | system updater |

And more.
