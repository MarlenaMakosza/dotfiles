#!/usr/bin/env bash
# Rebuild Arch's texstudio package with the internal terminal (QTermWidget) enabled.
#
# Usage: rebuild-texstudio.sh [--latest] [--force] [--no-install]
#   --latest      build Arch's packaging "main" branch instead of the tag matching
#                 the version currently offered by your (Manjaro) repos
#   --force       rebuild even if the installed package is already up to date
#   --no-install  build and verify only, never run pacman -U
#
# Upstream CMake already supports the terminal: cmake/FindQTermWidget.cmake looks
# for qtermwidget${QT_VERSION_MAJOR} and defines INTERNAL_TERMINAL when found.
# Arch only lacks qtermwidget in makedepends (dropped in FS#77426, back when
# qtermwidget was Qt5-only), so that is the whole change.

set -euo pipefail

REPO_URL=https://gitlab.archlinux.org/archlinux/packaging/packages/texstudio.git
WORK="${XDG_CACHE_HOME:-$HOME/.cache}/texstudio-term-build"
LATEST=0 FORCE=0 INSTALL=1

for arg in "$@"; do
    case "$arg" in
        --latest) LATEST=1 ;;
        --force) FORCE=1 ;;
        --no-install) INSTALL=0 ;;
        -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
        *) echo "Nieznana opcja: $arg" >&2; exit 2 ;;
    esac
done

die() { echo "BŁĄD: $*" >&2; exit 1; }
info() { echo "==> $*"; }

pacman -Q qtermwidget >/dev/null 2>&1 || die "brak pakietu qtermwidget (sudo pacman -S qtermwidget)"

# Pick the packaging revision: by default the one matching the repo version,
# so dependencies line up with what Manjaro actually ships.
repo_ver=$(LC_ALL=C pacman -Si texstudio 2>/dev/null | awk -F': ' '/^Version/{print $2; exit}')
[[ -n "$repo_ver" ]] || die "nie mogę odczytać wersji texstudio z repo (pacman -Sy?)"
if (( LATEST )); then
    ref=main
else
    ref="${repo_ver/:/-}"   # Arch tags replace the epoch colon with a dash
fi
info "Wersja w repo: $repo_ver, buduję z rewizji Archa: $ref"

mkdir -p "$WORK"
if [[ -d "$WORK/texstudio/.git" ]]; then
    git -C "$WORK/texstudio" fetch --quiet --tags origin
else
    git clone --quiet "$REPO_URL" "$WORK/texstudio"
fi
cd "$WORK/texstudio"
git reset --quiet --hard
git clean --quiet -fdx -e '*.tar.gz' -e '*.pkg.tar.zst'
git checkout --quiet "$ref" 2>/dev/null || git checkout --quiet "origin/$ref" \
    || die "brak rewizji $ref w repozytorium Archa"

# Patch the PKGBUILD by appending overrides, so the original stays readable.
cat >> PKGBUILD <<'EOF'

# ---- local changes: internal terminal (rebuild-texstudio.sh) ----
pkgrel="${pkgrel}.1"
depends+=('qtermwidget')
makedepends+=('qtermwidget')
_md=(); for _d in "${makedepends[@]}"; do [[ $_d == mercurial ]] || _md+=("$_d"); done
makedepends=("${_md[@]}"); unset _md _d   # mercurial is not used by the build

EOF

pkgfile=$(makepkg --packagelist | grep -v -- '-debug-' | head -1)
built_ver=$(basename "$pkgfile" | sed -E 's/^texstudio-(.+)-x86_64\.pkg\.tar\.zst$/\1/')
inst_ver=$(pacman -Q texstudio 2>/dev/null | awk '{print $2}')

if [[ "$inst_ver" == "$built_ver" && $FORCE -eq 0 ]]; then
    info "Zainstalowana wersja $inst_ver jest aktualna. Nic do zrobienia (--force wymusza)."
    exit 0
fi

info "Buduję texstudio $built_ver (zainstalowana: ${inst_ver:-brak})"
makepkg -srf --noconfirm 2>&1 | tee "$WORK/build.log"
grep -q -- '-- Using QTermWidget' "$WORK/build.log" \
    || die "CMake nie wykrył QTermWidget, log: $WORK/build.log"

# Verify the packaged binary really links libqtermwidget6.
tmpbin=$(mktemp)
trap 'rm -f "$tmpbin"' EXIT
bsdtar -xOf "$pkgfile" usr/bin/texstudio > "$tmpbin"
chmod +x "$tmpbin"
ldd "$tmpbin" | grep -q libqtermwidget6 || die "binarka nie linkuje libqtermwidget6"
info "OK: $pkgfile linkuje $(ldd "$tmpbin" | awk '/libqtermwidget6/{print $1}')"

if ! pacman-conf IgnorePkg | grep -qx texstudio; then
    echo
    echo "UWAGA: texstudio nie jest w IgnorePkg. Następna aktualizacja z repo"
    echo "zastąpi ten build wersją bez terminala. Dodaj w /etc/pacman.conf:"
    echo "    IgnorePkg = texstudio"
fi

(( INSTALL )) || { info "Pominięto instalację (--no-install). Pakiet: $pkgfile"; exit 0; }

echo
read -rp "Zainstalować $built_ver przez 'sudo pacman -U'? [t/N] " ans
if [[ "$ans" == [tTyY] ]]; then
    sudo pacman -U "$pkgfile"
else
    info "Nie instaluję. Pakiet: $pkgfile"
fi
