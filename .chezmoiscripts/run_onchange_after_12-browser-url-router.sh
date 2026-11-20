#!/usr/bin/env bash
set -euo pipefail

# KDE apps open links via kdeglobals BrowserApplication, not mimeapps.list
kwriteconfig6 --file kdeglobals --group General --key BrowserApplication url-router.desktop
