#!/bin/bash

path=$(dirname $(readlink -f $0))  # Script path. Resolves symlinks
me=$(basename $0)  # script.sh
errors="\n"        # Container for error messages
download_path='/tmp/dotfiles'
files_path="${path}/files"


function showHelp
{
  cat <<EndOfHelp

    Install command line applications

    Usage:
        $me <packages>
        $me [ -h | --help ]

    Packages:
        basics        Basic command line packages
        oh-my-zsh     Customizable Zsh shell framework
        ncdu          Disk space usage tool

EndOfHelp

  exit 0
}


function logError
{
  errors="${errors}\n[ERROR] $1"
}


function installBasicPackages
{
  sudo apt-get install -y vim ||
    logError "vim install failed"

  sudo apt-get install -y git ||
    logError "git install failed"

  sudo apt-get install -y curl ||
    logError "curl install failed"

  sudo apt-get install -y rar ||
    logError "rar install failed"
}


function installOhMyZsh
{
  echo -ne "\nThis will change the default shell to Zsh. Continue? [Y/n]"
  read -s -n 1 confirm

  [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] &&
    echo -e "\n" &&
    return 1

  install_script_url='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'

  sudo apt-get install -y zsh &&
    sh -c "$(wget ${install_script_url} -O -)" ||
    logError "oh-my-zsh install failed"

  cp -r ${files_path}/oh-my-zsh/* ~/.oh-my-zsh/custom/ ||
    logError "oh-my-zsh custom configuration failed"
}


function installNcdu
{
  sudo apt-get install -y ncdu ||
    logError "ncdu install failed"
}


# Check params
[ $# -eq 0 ] && showHelp

mkdir -p "$download_path"

for param in "$@"
do
  case "$param" in
    "-h" | "--help" )
      showHelp
    ;;
    "basics" )
      installBasicPackages
    ;;
    "oh-my-zsh" )
      installOhMyZsh
    ;;
    "ncdu" )
      installNcdu
    ;;
    * )
      logError "Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
