# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  (
    dcg_claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
    case "$dcg_claude_dir" in
      "~") dcg_claude_dir="$HOME" ;;
      "~/"*) dcg_claude_dir="$HOME/${dcg_claude_dir#"~/"}" ;;
    esac
    case "$dcg_claude_dir" in
      /*) ;;
      *) dcg_claude_dir="$PWD/$dcg_claude_dir" ;;
    esac
    dcg_claude_settings="${dcg_claude_dir%/}/settings.json"
    if { [ -n "${CLAUDE_CONFIG_DIR:-}" ] || [ -f "$dcg_claude_settings" ]; } && \
       { [ ! -f "$dcg_claude_settings" ] || \
         ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
           "$dcg_claude_settings" &>/dev/null; }; then
      printf '\033[1;33m[dcg] Hook missing from %s — run: dcg install\033[0m\n' "$dcg_claude_settings"
    fi
  )
fi
