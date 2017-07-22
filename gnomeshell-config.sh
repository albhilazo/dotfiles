#!/bin/bash

path=$(dirname $(readlink -f $0))  # Script path. Resolves symlinks
me=$(basename $0)  # script.sh
errors="\n"        # Container for error messages
download_path='/tmp/dotfiles'
files_path="${path}/files"


function showHelp
{
  cat <<EndOfHelp

    Manage Gnome Shell configuration

    Usage:
        $me <configs>
        $me [ -h | --help ]

    Configs:
        clockformat   Gnome clock format
        whitecursor   White mouse cursor
        windowbtns    Window buttons (min, max, close)
        nautilus      Nautilus preferences

EndOfHelp

  exit 0
}


function logError
{
  errors="${errors}\n[ERROR] $1"
}


function setClockFormat
{
  gsettings set org.gnome.desktop.interface clock-format '24h' &&
    gsettings set org.gnome.desktop.interface clock-show-date true &&
    gsettings set org.gnome.desktop.interface clock-show-seconds false ||
    logError "clock format config failed"
}


function setWhiteMouseCursor
{
  sudo apt-get install -y dmz-cursor-theme &&
    gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White' ||
    logError "white mouse cursor config failed"
}


function setWindowButtons
{
  gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' ||
    logError "window buttons config failed"
}


function setNautilus
{
  gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view' &&
    gsettings set org.gnome.nautilus.preferences search-view 'list-view' &&
    gsettings set org.gnome.nautilus.preferences sort-directories-first true &&
    gsettings set org.gnome.nautilus.preferences show-hidden-files false ||
    logError "Nautilus config failed"
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
      logError "Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
