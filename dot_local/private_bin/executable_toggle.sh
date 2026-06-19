#!/usr/bin/env bash
set -euo pipefail

PIDFILE="$HOME/.cache/mouseless/mouseless.pid"

if [[ -f "$PIDFILE" ]]; then
  pid="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
    exec "$HOME/.config/myconfigs/mouseless/stop.sh"
  fi
fi

exec "$HOME/.config/myconfigs/mouseless/start.sh"
