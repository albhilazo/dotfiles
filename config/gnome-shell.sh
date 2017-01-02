#!/bin/bash

##################################################
##
##    Manage Gnome Shell configurations
##
##    Syntax: gnome-shell.sh <packages>
##            gnome-shell.sh [ -h | --help ]
##
##    Configs:
##            clockformat   Gnome clock format
##            whitecursor   White mouse cursor
##            windowbtns    Window buttons (min, max, close)
##            nautilus      Nautilus preferences
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


function setClockFormat
{
  gsettings set org.gnome.desktop.interface clock-format '24h' &&
    gsettings set org.gnome.desktop.interface clock-show-date true &&
    gsettings set org.gnome.desktop.interface clock-show-seconds false ||
    errors="${errors}\n[ERROR] clock format config failed."
}


function setWhiteMouseCursor
{
  sudo apt-get install dmz-cursor-theme &&
    gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White' ||
    errors="${errors}\n[ERROR] white mouse cursor config failed."
}


function setWindowButtons
{
  gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' ||
    errors="${errors}\n[ERROR] window buttons config failed."
}


function setNautilus
{
  gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view' &&
    gsettings set org.gnome.nautilus.preferences search-view 'list-view' &&
    gsettings set org.gnome.nautilus.preferences sort-directories-first true &&
    gsettings set org.gnome.nautilus.preferences show-hidden-files false ||
    errors="${errors}\n[ERROR] Nautilus config failed."
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
    "clockformat" )
      setClockFormat
    ;;
    "whitecursor" )
      setWhiteMouseCursor
    ;;
    "windowbtns" )
      setWindowButtons
    ;;
    "nautilus" )
      setNautilus
    ;;
    * )
      errors="${errors}\n[ERROR] Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
