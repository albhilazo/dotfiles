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
##            screenrec     Simple Screen Recorder
##            gimp          Gimp with plugins, filters and effects
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
  echo -ne "Install it now? [Y/n] "
  read -s -n 1 confirm

  [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] &&
    echo -e "\n" &&
    return 1

  echo -e "\n"

  sudo apt-get install curl &&
    return 0

  errors="${errors}\n[ERROR] curl install failed."
  return 1
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
  if ! checkCurlInstalled
  then
    errors="${errors}\n[ERROR] sublime-text install failed. Missing \"curl\"."
    return 1
  fi

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


function installSimpleScreenRecorder
{
  sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder &&
    sudo apt-get update &&
    sudo apt-get install simplescreenrecorder ||
    errors="${errors}\n[ERROR] simplescreenrecorder install failed."
}


function installGimp
{
  sudo add-apt-repository ppa:otto-kesselgulasch/gimp &&
    sudo apt-get update &&
    sudo apt-get install gimp &&
    sudo apt-get install gimp-plugin-registry gimp-gmic ||  # Plugins, filters and effects
    errors="${errors}\n[ERROR] gimp install failed."
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
    "screenrec" )
      installSimpleScreenRecorder
    ;;
    "gimp" )
      installGimp
    ;;
    * )
      errors="${errors}\n[ERROR] Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
