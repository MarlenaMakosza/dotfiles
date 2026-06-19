#!/bin/bash
# Zmienia jasność wszystkich monitorów przez KDE D-Bus (skala 0-10000)
#
# Użycie:
#   brightness-all.sh 10     → jaśniej o 10% (liczba dodatnia)
#   brightness-all.sh -10    → ciemniej o 10% (liczba ujemna)
#   brightness-all.sh up     → jaśniej o 10%
#   brightness-all.sh down   → ciemniej o 10%
#   brightness-all.sh set 70 → ustaw 70%
#
# W OpenDeck "Dial rotate" wpisz: ~/.local/bin/brightness-all.sh %d

ARG=${1:-up}

case "$ARG" in
    up)     MODE="delta"; DELTA_PCT=10 ;;
    down)   MODE="delta"; DELTA_PCT=-10 ;;
    set)    MODE="set";   SET_PCT=${2:-50} ;;
    -[0-9]*) MODE="delta"; DELTA_PCT=$(( ARG * 5 )) ;;
    [0-9]*) MODE="delta"; DELTA_PCT=$(( ARG * 5 )) ;;
    *)      echo "Nieznana opcja: $ARG" >&2; exit 1 ;;
esac

mapfile -t DISPLAYS < <(qdbus6 org.kde.ScreenBrightness /org/kde/ScreenBrightness \
    org.kde.ScreenBrightness.DisplaysDBusNames 2>/dev/null)

if [ ${#DISPLAYS[@]} -eq 0 ]; then
    echo "Brak monitorów KDE" >&2
    exit 1
fi

for D in "${DISPLAYS[@]}"; do
    PATH_D="/org/kde/ScreenBrightness/$D"
    MAX=$(qdbus6 org.kde.ScreenBrightness "$PATH_D" \
        org.kde.ScreenBrightness.Display.MaxBrightness 2>/dev/null)
    [ -z "$MAX" ] && continue

    if [ "$MODE" = "set" ]; then
        TARGET=$(( SET_PCT * MAX / 100 ))
    else
        CURRENT=$(qdbus6 org.kde.ScreenBrightness "$PATH_D" \
            org.kde.ScreenBrightness.Display.Brightness 2>/dev/null)
        [ -z "$CURRENT" ] && continue
        DELTA=$(( DELTA_PCT * MAX / 100 ))
        TARGET=$(( CURRENT + DELTA ))
        (( TARGET < 0 ))   && TARGET=0
        (( TARGET > MAX )) && TARGET=$MAX
    fi

    qdbus6 org.kde.ScreenBrightness "$PATH_D" \
        org.kde.ScreenBrightness.Display.SetBrightness "$TARGET" 0
done
