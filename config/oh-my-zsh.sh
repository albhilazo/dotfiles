#!/bin/bash

##################################################
##
##    Manage Oh My Zsh configurations
##
##    Syntax: oh-my-zsh.sh <packages>
##            oh-my-zsh.sh [ -h | --help ]
##
##    Configs:
##            custom    Custom settings
##
##################################################


path=$(dirname $(readlink -f $0))  # Script path. Resolves symlinks
me=$(basename $0)  # script.sh
errors="\n"        # Container for error messages
download_path='/tmp/dotfiles'


# Print the help text at the top of this script
function showHelp
{
  echo -e "\nconfig/$me help:"
  sed '1,/\#\#\#\#/d;/\#\#\#\#/,$d;/ @/d;s/\#\#//g' $0
  exit 0
}


function setCustomSettings
{
  cp -r ${path}/../files/oh-my-zsh/* ~/.oh-my-zsh/custom/ ||
    errors="${errors}\n[ERROR] Oh My Zsh custom settings failed."
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
    "custom" )
      setCustomSettings
    ;;
    * )
      errors="${errors}\n[ERROR] Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
