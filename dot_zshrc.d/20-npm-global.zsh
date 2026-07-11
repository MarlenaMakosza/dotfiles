export NPM_CONFIG_PREFIX="$HOME/.local/share/npm-global"
case ":$PATH:" in
  *":$NPM_CONFIG_PREFIX/bin:"*) ;;
  *) export PATH="$NPM_CONFIG_PREFIX/bin:$PATH" ;;
esac
