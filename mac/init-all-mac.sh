#!/usr/bin/env bash

me=$(basename $0)


showHelp ()
{
  cat <<EndOfHelp
    
    Installs Homebrew before running the configuration scripts
    
    Usage:
        $me [ -h | --help ]

EndOfHelp
}


log ()
{
  echo -e "\n[${me}] $1\n"
}


askConfirmation ()
{
  log "This will install Homebrew and run the configuration scripts"
  echo -n "Continue? [y/N] "
  read -s -n 1 confirm
  echo -e "\n"

  [ -z "$confirm" ] && return 1
  [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] && return 1
  return 0
}


installHomebrew ()
{
  log "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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

askConfirmation || exit 1
installHomebrew

exit 0
