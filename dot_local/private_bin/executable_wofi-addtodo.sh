#!/usr/bin/env bash
set -euo pipefail

LINE="$(wofi --dmenu --prompt 'addtodo:' </dev/null || true)"
LINE="$(printf '%s' "$LINE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
[[ -z "$LINE" ]] && exit 0

# pozwól wpisywać albo "addtodo coś", albo samo "web: coś"
if [[ "$LINE" == addtodo* ]]; then
  ARGS="${LINE#addtodo}"
else
  ARGS="$LINE"
fi

ARGS="$(printf '%s' "$ARGS" | sed 's/^[[:space:]]*//')"

exec ~/.local/bin/addtodo $ARGS
