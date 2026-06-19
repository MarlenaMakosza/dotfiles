# Trilium + Wofi Todo Capture

OUTDATED

Prosty system dodawania checkboxów do wybranych notatek w Trilium przez Wofi.

---

## 📦 Wymagania

* `bash`
* `curl`
* `wofi`
* `kwallet-query` (KWallet6)
* działający Trilium z włączonym ETAPI

---

# 🔧 Instalacja

## 1️⃣ Skopiuj skrypty

Upewnij się, że plik:

```
~/.config/myconfigs/trilium-rofi/addtodo
```

jest wykonywalny:

```bash
chmod +x ~/.config/myconfigs/trilium-rofi/addtodo
```

Utwórz symlink do `~/.local/bin`:

```bash
mkdir -p ~/.local/bin
ln -s ~/.config/myconfigs/trilium-rofi/addtodo ~/.local/bin/addtodo
```

Sprawdź:

```bash
command -v addtodo
```

Powinno zwrócić ścieżkę.

---

## 2️⃣ Skonfiguruj notes.conf

Edytuj:

```
~/.config/myconfigs/trilium-rofi/notes.conf
```

Musisz ustawić:

```bash
TRILIUM_URL="http://localhost:37840"
DEFAULT_NOTE_ID="TWOJE_ID"

NOTE_hl="ID_NOTATKI_HL"
NOTE_work="ID_NOTATKI_WORK"
NOTE_thesis="ID_NOTATKI_THESIS"

WALLET_FOLDER="Trilium"
WALLET_KEY="etapi-token"
```

### 🔍 Skąd wziąć ID notatki?

W Trilium:

* Otwórz notatkę
* W URL zobaczysz coś typu:

```
#root/abc123xyz
```

To `abc123xyz` to ID notatki.

---

## 3️⃣ Włącz ETAPI w Trilium

W Trilium:

1. Settings / Options
2. Włącz ETAPI
3. Wygeneruj API token

Skopiuj token.

---

## 4️⃣ Dodaj token do KWallet

Zapisz token w KWallet:

```bash
kwallet-query --write-password etapi-token --folder Trilium kdewallet
```

Wklej token z Trilium.

Jeśli KWallet nie działa, możesz użyć fallback:

```
~/.config/myconfigs/trilium-rofi/.etapi-token
```

i wkleić tam sam token (bez spacji, bez nowej linii).

---

## 5️⃣ Desktop entry (opcjonalnie)

Plik:

```
~/.local/share/applications/trilium-addtodo.desktop
```

Przykład:

```ini
[Desktop Entry]
Name=Trilium Add Todo
Type=Application
Exec=/home/TWOJ_LOGIN/.config/myconfigs/trilium-rofi/wofi-addtodo.sh
Terminal=false
Categories=Utility;
```

Po zapisaniu możesz uruchomić przez:

```bash
wofi --show drun
```

---

# 🚀 Użycie

Przez terminal:

```bash
addtodo hl: sprawdzić logi
addtodo work: !high fix bug
addtodo thesis: dodać przypisy
```

Przez Wofi:

* Uruchom launcher
* Wybierz „Trilium Add Todo”
* Wpisz treść (np. `hl: zadanie`)

---

# 🧠 Format komendy

```
[prefix:] [!priority] treść zadania
```

Przykłady:

```
hl: !high sprawdzić produkcję
work: fix navbar
thesis: !low dopisać wstęp
```

---

# ⚠️ Jeśli coś nie działa

Sprawdź:

* Czy `addtodo` jest w `$PATH`
* Czy `notes.conf` ma poprawne ID notatek
* Czy ETAPI jest włączone
* Czy token jest poprawny
* Czy `TRILIUM_URL` jest osiągalny

Test API:

```bash
curl -H "Authorization: Bearer TWÓJ_TOKEN" \
http://localhost:37840/etapi/notes/TWOJE_ID/content
```


# Config wofi minimal

exec_search=true
always_parse_args=true
