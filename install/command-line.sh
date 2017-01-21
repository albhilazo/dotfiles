#!/bin/bash

##################################################
##
##    Install command line applications
##
##    Syntax: command-line.sh <packages>
##            command-line.sh [ -h | --help ]
##
##    Packages:
##            basics        Basic command line packages
##            oh-my-zsh     Customizable Zsh shell framework
##            ncdu          Disk space usage tool
##
##################################################


path=$(dirname $(readlink -f $0))  # Script path. Resolves symlinks
me=$(basename $0)  # script.sh
errors="\n"        # Container for error messages
download_path='/tmp/dotfiles'


# Print the help text at the top of this script
function showHelp
{
  echo -e "\ninstall/$me help:"
  sed '1,/\#\#\#\#/d;/\#\#\#\#/,$d;/ @/d;s/\#\#//g' $0
  exit 0
}


function installBasicPackages
{
  sudo apt-get install vim ||
    errors="${errors}\n[ERROR] vim install failed."
  sudo apt-get install git ||
    errors="${errors}\n[ERROR] git install failed."
  sudo apt-get install curl ||
    errors="${errors}\n[ERROR] curl install failed."
  sudo apt-get install rar ||
    errors="${errors}\n[ERROR] rar install failed."
}


function installOhMyZsh
{
  echo -ne "\nThis will change the default shell to Zsh. Continue? [Y/n]"
  read -s -n 1 confirm

  [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] &&
    echo -e "\n" &&
    return 1

  install_script_url='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'

  sudo apt-get install zsh &&
    sh -c "$(wget ${install_script_url} -O -)" ||
    errors="${errors}\n[ERROR] oh-my-zsh install failed."
}


function installNcdu
{
  sudo apt-get install ncdu ||
    errors="${errors}\n[ERROR] ncdu install failed."
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
      errors="${errors}\n[ERROR] Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0