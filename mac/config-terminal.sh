#!/usr/bin/env bash

me=$(basename $0)


showHelp ()
{
  cat <<EndOfHelp

    Configures terminal theme and aliases

    Usage:
        $me [ -h | --help ]

EndOfHelp
}


log ()
{
  echo -e "\n[${me}] $1\n"
}


installOhMyZsh ()
{
  # install_script_url='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
  install_script_url='https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'

  log "Installing OhMyZsh"
  sh -c "$(curl -fsSL ${install_script_url})" || return 1
  return 0
}


copyOhMyZshConfigurations ()
{
  log "Copying OhMyZsh theme and aliases"
  cp -a ../configs/oh-my-zsh/* ~/.oh-my-zsh/custom/
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

installOhMyZsh &&
  copyOhMyZshConfigurations

exit 0
