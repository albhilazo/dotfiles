#!/usr/bin/env bash

me=$(basename $0)
user_configs_path="${HOME}/Library/Application Support/Code/User"
user_settings_file="${user_configs_path}/settings.json"
user_keybindings_file="${user_configs_path}/keybindings.json"


function showHelp {
  cat <<EndOfHelp
    
    Sets user configurations and installs extensions for VSCode
    
    Usage:
        $me [ -h | --help ]

EndOfHelp
}


function log {
  echo -e "\n[${me}] $1\n"
}


function prepareJsonFile {
  json_file=$1
  # if file doesn't exist or is empty, reset it
  [ ! -s "${json_file}" ] && echo '{}' > "${json_file}"
}


function setConfig {
  line_to_set=$1
  cat "${user_settings_file}" | jq "${line_to_set}" | tee "${user_settings_file}"
}


function setUserConfigs {
  prepareJsonFile "${user_settings_file}"
  setConfig '."files.autoSave" = "onFocusChange"'
}


for argument in "$@"
do
  case "$argument" in
    "-h" | "--help" )
      showHelp
      exit 0
    ;;
    * )
      log "Invalid parameter"
      exit 1
    ;;
  esac
done

setUserConfigs

exit 0

#cat "${user_settings_file}" | jq '."files.autoSave" = "onFocusChange"' | tee "${user_settings_file}"

code --install-extension eamodio.gitlens
#code --install-extension PeterJausovec.vscode-docker
code --install-extension mohsen1.prettify-json
#code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension hideoo.trailing
code --install-extension sleistner.vscode-fileutils
#code --install-extension johnpapa.vscode-peacock
