#!/usr/bin/env bash
set -euo pipefail

APP="$HOME/Downloads/Mouseless.AppImage"   # <- ZMIEŃ, jeśli masz inną ścieżkę
PIDFILE="$HOME/.cache/mouseless/mouseless.pid"
LOG="$HOME/.cache/mouseless/mouseless.log"

stop_group() {
  local pid="$1"
  # Kill whole process group created by setsid (pgid==pid)
  kill -TERM -- "-$pid" 2>/dev/null || true
  sleep 0.25
  kill -KILL -- "-$pid" 2>/dev/null || true
}

if [[ -f "$PIDFILE" ]]; then
  pid="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
    echo "$(date -Is) stopping group pid=$pid" >>"$LOG"
    stop_group "$pid"
    rm -f "$PIDFILE"
    echo "$(date -Is) stopped group pid=$pid" >>"$LOG"
    exit 0
  fi
fi

# Fallback by path (in case pidfile is missing)
echo "$(date -Is) fallback stop by path: $APP" >>"$LOG"
pkill -TERM -f "$APP" 2>/dev/null || true
sleep 0.25
pkill -KILL -f "$APP" 2>/dev/null || true
rm -f "$PIDFILE"
