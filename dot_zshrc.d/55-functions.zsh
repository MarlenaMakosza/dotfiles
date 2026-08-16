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
    --cpu-moe \
    -fa on \
    -ctk q8_0 \
    -ctv q8_0 \
    -c 131072 \
    -np 1 \
    -t 22 \
    -tb 24
}
