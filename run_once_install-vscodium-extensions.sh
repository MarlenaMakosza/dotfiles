#!/usr/bin/env bash
# Run once on chezmoi apply — installs VSCodium extensions via Open VSX.
# MS Marketplace extensions (ms-*) are excluded; install manually via VSIX.

extensions=(
  4ops.terraform
  aaron-bond.better-comments
  akamud.vscode-theme-onedark
  aliariff.auto-add-brackets
  Anthropic.claude-code
  bradlc.vscode-tailwindcss
  Codeium.codeium
  dbaeumer.vscode-eslint
  denoland.vscode-deno
  DotJoshJohnson.xml
  eamodio.gitlens
  ecmel.vscode-html-css
  esbenp.prettier-vscode
  firefox-devtools.vscode-firefox-debug
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  Gruntfuggly.todo-tree
  hashicorp.terraform
  humao.rest-client
  jcs090218.Ellsp
  jebbs.plantuml
  mark-wiemer.vscode-autohotkey-plus-plus
  mhutchie.git-graph
  mikestead.dotenv
  paulmolluzzo.convert-css-in-js
  peakchen90.open-html-in-browser
  PKief.material-icon-theme
  psioniq.psi-header
  rangav.vscode-thunder-client
  redhat.vscode-xml
  redhat.vscode-yaml
  ritwickdey.LiveServer
  RobbOwen.synthwave-vscode
  RooVeterinaryInc.roo-cline
  RoscoP.ActiveFileInStatusBar
  rvest.vs-code-prettier-eslint
  sdras.night-owl
  SergeyEgorov.folder-color
  shd101wyy.markdown-preview-enhanced
  spywhere.guides
  steoates.autoimport
  streetsidesoftware.code-spell-checker
  svelte.svelte-vscode
  techer.open-in-browser
  tomoki1207.pdf
  waderyan.gitblame
  WallabyJs.quokka-vscode
  wayou.vscode-todo-highlight
  webhint.vscode-webhint
  wix.vscode-import-cost
  xyz.local-history
  yzhang.markdown-all-in-one
  Zignd.html-css-class-completion
  zokugun.cron-tasks
)

for ext in "${extensions[@]}"; do
  codium --install-extension "$ext" || echo "FAILED: $ext"
done
