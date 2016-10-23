#!/bin/bash

##################################################
##
##    Install desktop applications
##
##    Syntax: desktop.sh <packages>
##            desktop.sh [ -h | --help ]
##
##    Packages:
##            chrome        Google Chrome browser
##            sublime-text  Sublime Text 3 editor
##            guake         Guake dropdown terminal
##            grub-cust     Grub customizer
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


function checkCurlInstalled
{
  type curl &> /dev/null &&
    return 0

  echo -e "\nThis action requires \"curl\" to be installed."
  echo -ne "Install it along with a set of basic packages? [Y/n]"
  read -s -n 1 confirm

  [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] &&
    echo -e "\n" &&
    return 1

  echo -e "\n"
  ${path}/command-line.sh basics
}


function installGoogleChrome
{
  latest_url='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
  deb_file="${download_path}/google-chrome.deb"

  wget --output-document "$deb_file" "$latest_url" &&
    sudo dpkg -i --force-depends "$deb_file"
  sudo apt-get install -f
}


function installSublimeText
{
  checkCurlInstalled ||
    errors="${errors}\n[ERROR] sublime-text install failed. Missing \"curl\"." &&
    return 1

  updatecheck_url='http://www.sublimetext.com/updates/3/stable/updatecheck?platform=linux&arch=x64'
  latest_version_regex='(?<="latest_version": )[0-9]+'
  latest_version=$(curl -s "$updatecheck_url" | grep -Po "$latest_version_regex")

  latest_url="https://download.sublimetext.com/sublime-text_build-${latest_version}_amd64.deb"
  deb_file="${download_path}/sublime-text-3.deb"

  wget --output-document "$deb_file" "$latest_url" &&
    sudo dpkg -i "$deb_file" ||
    errors="${errors}\n[ERROR] sublime-text install failed."
}


function installGuake
{
  sudo apt-get install guake &&
    cp /usr/share/applications/guake.desktop ~/.config/autostart/ ||
    errors="${errors}\n[ERROR] guake install failed."
}


function installGrubCustomizer
{
  sudo add-apt-repository ppa:danielrichter2007/grub-customizer &&
    sudo apt-get update &&
    sudo apt-get install grub-customizer ||
    errors="${errors}\n[ERROR] grub-customizer install failed."
}


# Check params
[ $# -eq 0 ] && showHelp

for param in "$@"
do
  case "$param" in
    "-h" | "--help" )
      showHelp
    ;;
    "chrome" )
      installGoogleChrome
    ;;
    "sublime-text" )
      installSublimeText
    ;;
    "guake" )
      installGuake
    ;;
    "grub-cust" )
      installGrubCustomizer
    ;;
    * )
      echo -e "\n[ERROR] Invalid parameter: $param"
      showHelp
    ;;
  esac
done

echo -e "$errors\n"


exit 0
