alias ls='exa -al --color=always --group-directories-first'
alias doom="~/.config/emacs/bin/doom"

# === Display profiles ===
alias disp-gaming='display-gaming'
alias disp-dual='display-dual'
alias disp-multi='display-multitask'
alias disp-triple='display-triple'
alias disp-triple-top='display-triple-top'
alias disp-work='display-work-lazy'
alias disp-work-hard='display-work-hard'
alias disp-cycle='display-cycle'

# Szybki podgląd aktualnego stanu ekranów
alias disp-now='kscreen-doctor -o | grep -E "^Output:|enabled|Geometry:|Scale:|priority"'

# Debug: pokaż tylko aktywne monitory
alias disp-active='kscreen-doctor -o | awk "/Output:/{o=\$0} /enabled/{print o}"'

alias catpic='kitty +kitten icat'
alias klawa='tastenbrett -m pc104alt -l pl'
alias pacdiff='sudo DIFFPROG=meld pacdiff'

# === Git ===
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gcl='git clone'
alias gc='git commit'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gca='git commit --amend'
alias gp='git push'
alias gpoa='git push origin --all'
alias gl='git pull'
alias glo='git log --oneline'
alias glog='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias grv='git remote -v'
alias gst='git stash'
alias gstp='git stash pop'

# === Git submodules ===
alias gsmu='git submodule update --init --recursive'
alias gsms='git submodule status'
alias gsma='git submodule add'

# === Git worktree ===
alias gwl='git worktree list'
alias gwr='git worktree remove'
alias gwp='git worktree prune'
alias gwa='git worktree add'

# === Lazy git ===
alias lg='lazygit'
alias lwt='lazyworktree'

# === Worktrunk ===
alias wtn='wt switch --create'   # new worktree
alias wts='wt switch'            # switch existing
alias wtl='wt list'              # status
alias wtr='wt remove'            # cleanup
alias wtm='wt merge main'        # merge do main
