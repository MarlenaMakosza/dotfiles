# --- Banner + fastfetch (tylko interaktywnie) ---
if is_interactive; then
  if command -v figlet >/dev/null 2>&1; then
    figlet -f big "Dragon Cave"
  fi
  print

  if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
  fi
fi
