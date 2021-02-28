#!/usr/bin/env bash

cp ../configs/vscode/keybindings.mac.json ~/Library/Application\ Support/Code/User/keybindings.json
cp ../configs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

code --install-extension eamodio.gitlens
code --install-extension PeterJausovec.vscode-docker
code --install-extension mohsen1.prettify-json
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension annsk.alignment
code --install-extension naumovs.trailing-semicolon
code --install-extension sleistner.vscode-fileutils
code --install-extension johnpapa.vscode-peacock
