#!/usr/bin/env bash
set -euo pipefail

APP="$HOME/Downloads/Mouseless.AppImage"   # <- ZMIEŃ, jeśli masz inną ścieżkę
PIDFILE="$HOME/.cache/mouseless/mouseless.pid"
LOG="$HOME/.cache/mouseless/mouseless.log"

mkdir -p "$(dirname "$PIDFILE")"
chmod +x "$APP" 2>/dev/null || true

# If already running, do nothing
if [[ -f "$PIDFILE" ]]; then
  pid="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
    echo "$(date -Is) already running pid=$pid" >>"$LOG"
    exit 0
  fi
fi

# Start in new session (new process group), detach from KDE shortcut
# Capture PID reliably via $!
nohup setsid "$APP" >>"$LOG" 2>&1 < /dev/null &
pid=$!

echo "$pid" > "$PIDFILE"
echo "$(date -Is) started pid=$pid app=$APP" >>"$LOG"
