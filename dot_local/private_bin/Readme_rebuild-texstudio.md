# rebuild-texstudio.sh

Buduje pakiet `texstudio` z oficjalnego PKGBUILD Archa, ale z włączonym
wbudowanym terminalem (panel **Terminal**, oparty na QTermWidget).

## Dlaczego to jest potrzebne

Oficjalny pakiet `texstudio` (Arch/Manjaro) jest kompilowany bez
`INTERNAL_TERMINAL`. Kod terminala jest wycinany w czasie kompilacji
(`#ifdef INTERNAL_TERMINAL`), więc samo doinstalowanie `qtermwidget` nic nie
daje i nie ma żadnej opcji w konfiguracji, która by go włączyła.

Dodatkowo `CMakeLists.txt` TeXstudio (4.9.7, 4.9.8, master) ma błąd:

- `find_package(QTermWidget)` nie znajduje `qtermwidget` 2.x, który instaluje
  config CMake pod nazwą `qtermwidget6`,
- linkowanie sprawdza zmienną `QTERMWIDGET_FOUND`, której nic nie ustawia.

Skrypt bierze PKGBUILD Archa, dopisuje na jego końcu poprawki (bez edycji
oryginalnych linii), buduje pakiet i sprawdza, że binarka naprawdę linkuje
`libqtermwidget6`.

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

- `CMake nie wykrył QTermWidget`: sprawdź `pacman -Q qtermwidget` i log buildu.
- `CMakeLists.txt changed upstream, qtermwidget fix needs review`: upstream
  zmienił fragment CMake z QTermWidget. Sprawdź, czy błąd naprawiono (wtedy
  wystarczy `qtermwidget` w `makedepends`), i dostosuj blok `prepare()` w
  skrypcie.
- `brak rewizji X w repozytorium Archa`: Manjaro ma wersję, której Arch nie
  otagował. Użyj `--latest`.
