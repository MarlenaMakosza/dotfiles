#!/usr/bin/env bash
# Run once on chezmoi apply — installs VSCodium extensions via Open VSX.
# MS Marketplace extensions (ms-*) are excluded; install manually via VSIX.

extensions=(
  aaron-bond.better-comments
  akamud.vscode-theme-onedark
  aliariff.auto-add-brackets
  Anthropic.claude-code
  bradlc.vscode-tailwindcss
  continue.continue
  dbaeumer.vscode-eslint
  denoland.vscode-deno
  ecmel.vscode-html-css
  esbenp.prettier-vscode
  firefox-devtools.vscode-firefox-debug
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  Gruntfuggly.todo-tree
  hashicorp.terraform
  james-yu.latex-workshop
  jebbs.plantuml
  mhutchie.git-graph
  mikestead.dotenv
  paulmolluzzo.convert-css-in-js
  PKief.material-icon-theme
  psioniq.psi-header
  rangav.vscode-thunder-client
  redhat.vscode-xml
  redhat.vscode-yaml
  RoscoP.ActiveFileInStatusBar
  rvest.vs-code-prettier-eslint
  SergeyEgorov.folder-color
  shd101wyy.markdown-preview-enhanced
  spywhere.guides
  steoates.autoimport
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-polish
  svelte.svelte-vscode
  techer.open-in-browser
  uloco.theme-bluloco-light
  waderyan.gitblame
  WallabyJs.quokka-vscode
  wayou.vscode-todo-highlight
  webhint.vscode-webhint
  wix.vscode-import-cost
  xyz.local-history
  yandeu.five-server
  yzhang.markdown-all-in-one
  Zignd.html-css-class-completion
)

for ext in "${extensions[@]}"; do
  codium --install-extension "$ext" || echo "FAILED: $ext"
done
