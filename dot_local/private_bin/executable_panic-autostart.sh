#!/bin/zsh

pgrep -x texstudio > /dev/null || texstudio &
pgrep -x zeditor > /dev/null || zeditor /mnt/games/source/studia/Thesis/ &

qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Switch to Desktop 3"
