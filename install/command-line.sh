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
##
##################################################


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
  sudo apt-get install rar ||
    errors="${errors}\n[ERROR] rar install failed."
}


# Check params
[ $# -eq 0 ] && showHelp

for param in "$@"
do
  case "$param" in
    "-h" | "--help" )
      showHelp
    ;;
    "basics" )
      installBasicPackages
    ;;
    * )
      echo -e "\n[ERROR] Invalid parameter: $param"
      showHelp
    ;;
  esac
done

echo -e "$errors\n"


exit 0
