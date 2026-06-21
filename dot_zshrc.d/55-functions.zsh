# === Markdown to PDF ===
mdtopdf() {
  pandoc "$1" -o "${1:r}.pdf" \
    --pdf-engine=xelatex \
    -V geometry:margin=2.5cm \
    -H <(printf '\\usepackage{titlesec}\n\\newcommand\\sectionbreak{\\clearpage}')
}
