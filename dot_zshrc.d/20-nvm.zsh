export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# wrapper uruchamiający nvm w osobnej sesji bash (nvm nie wspiera zsh natywnie)
nvm() {
  bash -lc "source ~/.nvm/nvm.sh && nvm $*"
}
