# rebuild-texstudio.sh

Buduje pakiet `texstudio` z oficjalnego PKGBUILD Archa, ale z włączonym
wbudowanym terminalem (panel **Terminal**, oparty na QTermWidget).

## Dlaczego to jest potrzebne

Oficjalny pakiet `texstudio` (Arch/Manjaro) jest kompilowany bez
`INTERNAL_TERMINAL`. Kod terminala jest wycinany w czasie kompilacji
(`#ifdef INTERNAL_TERMINAL`), więc samo doinstalowanie `qtermwidget` nic nie
daje i nie ma żadnej opcji w konfiguracji, która by go włączyła.

CMake TeXstudio obsługuje terminal bez żadnych poprawek: moduł
`cmake/FindQTermWidget.cmake` szuka `qtermwidget${QT_VERSION_MAJOR}` i po
znalezieniu włącza `INTERNAL_TERMINAL`. Brakuje tylko zależności w PKGBUILD
Archa. Arch miał `qtermwidget` w zależnościach przez jeden dzień (4.5.1, luty
2023), ale usunął go w FS#77426, bo `qtermwidget` było wtedy tylko dla Qt5.
Obsługa QTermWidget z Qt6 jest w TeXstudio dopiero od wersji 4.9.2
(upstream issue #3761, `qtermwidget` dla Qt6 istnieje od LXQt 2.0), a pakiet
Archa nie dodał jeszcze zależności z powrotem. Debian i Ubuntu budują TeXstudio
z `qtermwidget` i tam terminal jest.

Skrypt bierze PKGBUILD Archa, dopisuje na jego końcu `qtermwidget` do
`depends` i `makedepends` (bez edycji oryginalnych linii), buduje pakiet i
sprawdza, że binarka naprawdę linkuje `libqtermwidget6`.

## Wymagania

```sh
sudo pacman -S --needed base-devel git qtermwidget qt6-tools cmake ninja imagemagick librsvg
```

## Pierwsza instalacja

1. Dodaj `texstudio` do ignorowanych pakietów, żeby `pacman -Syu` nie
   zastąpił twojego buildu wersją bez terminala. W `/etc/pacman.conf`, w sekcji
   `[options]`:

   ```
   IgnorePkg = texstudio
   ```

   Jeśli `IgnorePkg` już istnieje, dopisz `texstudio` po spacji.

2. Zbuduj i zainstaluj:

   ```sh
   rebuild-texstudio.sh
   ```

   Na końcu skrypt pyta `[t/N]`, zanim uruchomi `sudo pacman -U`.

3. W TeXstudio: **View → Panels → Terminal**. Ustawienia terminala są w
   **Options → Configure TeXstudio → Internal Terminal** (zaznacz *Show
   Advanced Options*, jeśli zakładki nie widać).

Ustawienia użytkownika (`~/.config/texstudio`) zostają bez zmian.

## Opcje

| Opcja          | Działanie                                                                 |
|----------------|---------------------------------------------------------------------------|
| *(brak)*       | Buduje wersję zgodną z tą, którą oferuje repo Manjaro, i pyta o instalację |
| `--latest`     | Bierze gałąź `main` PKGBUILD Archa (może być nowsza niż w Manjaro)         |
| `--force`      | Buduje nawet wtedy, gdy zainstalowana wersja jest już aktualna            |
| `--no-install` | Tylko buduje i weryfikuje, nie uruchamia `pacman -U`                      |

Domyślny tryb jest bezpieczniejszy: Manjaro zwykle ma starsze biblioteki niż
Arch, a PKGBUILD z tagu odpowiadającego wersji w repo pasuje do nich.

## Aktualizacje

Kiedy `pacman -Syu` pokaże:

```
warning: texstudio: ignoring package upgrade (4.9.7-1.1 => 4.9.8-1)
```

uruchom:

```sh
rebuild-texstudio.sh
```

Przebuduj też po dużej aktualizacji `qtermwidget` (zmiana soname, np.
`libqtermwidget6.so.2` na `.so.3`). Objaw: TeXstudio nie startuje i pokazuje
`error while loading shared libraries: libqtermwidget6.so.2`.

Pamiętaj, że `IgnorePkg` blokuje też poprawki bezpieczeństwa TeXstudio, więc
nie odkładaj przebudowy na długo.

## Sprawdzenie

```sh
pacman -Q texstudio                        # wersja z końcówką .1, np. 4.9.7-1.1
ldd /usr/bin/texstudio | grep qtermwidget  # musi pokazać libqtermwidget6.so.N
```

## Powrót do oficjalnego pakietu

1. Usuń `texstudio` z `IgnorePkg` w `/etc/pacman.conf`.
2. Zainstaluj wersję z repo:

   ```sh
   sudo pacman -S texstudio
   ```

   Jeśli repo ma niższą wersję niż twój build, pacman zapyta o downgrade.

## Pliki

- `~/.cache/texstudio-term-build/texstudio/` to klon repozytorium PKGBUILD Archa
  i gotowe pakiety `*.pkg.tar.zst`.
- `~/.cache/texstudio-term-build/build.log` to log ostatniego buildu.

Cały katalog `~/.cache/texstudio-term-build` można bezpiecznie usunąć. Skrypt
odtworzy go przy następnym uruchomieniu.

## Gdy coś się nie uda

- `CMake nie wykrył QTermWidget`: sprawdź `pacman -Q qtermwidget` i
  `pkg-config --modversion qtermwidget6`, potem log buildu. Jeśli upstream
  zmienił `cmake/FindQTermWidget.cmake`, sprawdź, czego nowy moduł szuka.
- `brak rewizji X w repozytorium Archa`: Manjaro ma wersję, której Arch nie
  otagował. Użyj `--latest`.
