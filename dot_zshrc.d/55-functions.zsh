# === Markdown to PDF ===
mdtopdf() {
  pandoc "$1" -o "${1:r}.pdf" \
    --pdf-engine=xelatex \
    -V geometry:margin=2.5cm \
    -H <(printf '\\usepackage{titlesec}\n\\newcommand\\sectionbreak{\\clearpage}')
}

# === Local llama-server: Qwen3-Coder-Next ===
llama-3coder() {
  llama-server \
    -m "$HOME/Models/llama.cpp-cache/models--bartowski--huihui-ai_Qwen3-Coder-Next-abliterated-GGUF/snapshots/4b24fbac95c8496ceb09c3e95d15f9f9d11427d4/huihui-ai_Qwen3-Coder-Next-abliterated-Q5_K_M/huihui-ai_Qwen3-Coder-Next-abliterated-Q5_K_M-00001-of-00002.gguf" \
    --alias qwen3coder_bartkowski_hui \
    --host 0.0.0.0 \
    --port 8080 \
    --no-mmap \
    -ngl all \
    --n-cpu-moe 35 \
    --temperature 0.2 \
    -fa on \
    -ctk q8_0 \
    -ctv q8_0 \
    -c 131072 \
    -np 1 \
    -t 16 \
    -tb 24
}

llama-deepseek() {
  llama-server \
    -m "$HOME"/Models/llama.cpp-cache/DeepSeek-Coder-V2-Instruct-0724-GGUF/DeepSeek-Coder-V2-Instruct-0724-Q4_K_M-00001-of-00004.gguf \
    --alias deepseek_coder_v2_bartowski \
    --host 0.0.0.0 \
    --port 8080 \
    --no-mmap \
    -ngl all \
    --no-kv-offload \
    --cpu-moe \
    -fa on \
    -ctk q8_0 \
    -ctv q8_0 \
    -c 16384 \
    -np 1 \
    -t 22 \
    -tb 24
}

# === Git: delete local branches already merged into the main branch ===
# Usage:  gbclean        show what would be deleted
#         gbclean -f     actually delete them
#
# Only touches local branches, never the remote, and uses `git branch -d`
# (lowercase) so git itself refuses to drop anything unmerged.
gbclean() {
  git rev-parse --git-dir >/dev/null 2>&1 || {
    print -u2 "gbclean: not a git repository"
    return 1
  }

  # main branch = whatever origin/HEAD points at, else main, else master
  local base
  base=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
  base=${base#origin/}
  if [[ -z $base ]]; then
    for b in main master; do
      git show-ref --verify --quiet "refs/heads/$b" && base=$b && break
    done
  fi
  [[ -z $base ]] && {
    print -u2 "gbclean: cannot determine the main branch"
    return 1
  }

  git fetch --prune --quiet

  local -a stale
  stale=(${(f)"$(git branch --merged "$base" --format='%(refname:short)' | grep -vx "$base")"})

  # never delete the branch that is currently checked out
  local current
  current=$(git branch --show-current)
  stale=(${stale:#$current})

  if (( ${#stale} == 0 )); then
    print "gbclean: nothing to clean (base: $base)"
    return 0
  fi

  if [[ $1 == "-f" || $1 == "--force" ]]; then
    print "gbclean: deleting ${#stale} branch(es) merged into $base"
    git branch -d ${stale[@]}
  else
    print "gbclean: merged into $base, would delete ${#stale} branch(es):"
    printf '  %s\n' ${stale[@]}
    print "\nrun 'gbclean -f' to delete them"
  fi
}
