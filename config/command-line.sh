#!/bin/bash

##################################################
##
##    Manage command line configurations
##
##    Syntax: command-line.sh <configs>
##            command-line.sh [ -h | --help ]
##
##    Configs:
##            gitconfig    User gitconfig file
##            oh-my-zsh    Custom shell theme and settings
##            fixgrub      Repair/restore Grub2
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


function checkGitInstalled
{
  type git &> /dev/null &&
    return 0

  echo -e "\nGit is not installed."
  echo -ne "Install it now? [Y/n] "
  read -s -n 1 confirm

  [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] &&
    echo -e "\n" &&
    return 1

  echo -e "\n"

  sudo apt-get install git &&
    return 0

  errors="${errors}\n[ERROR] git install failed."
  return 1
}


function setUserGitconfig
{
  if ! checkGitInstalled
  then
    errors="${errors}\n[ERROR] Git user config failed. Missing \"git\"."
    return 1
  fi

  echo -e "\nInsert default Git identity:"
  echo -ne "    name: "
  read git_name
  echo -ne "    email: "
  read git_email

  cp ${path}/../files/gitconfig ~/.gitconfig &&
    git config --global user.name "${git_name}" &&
    git config --global user.email "${git_email}" ||
    errors="${errors}\n[ERROR] Git user config failed."
}


function setOhMyZshCustomSettings
{
  cp -r ${path}/../files/oh-my-zsh/* ~/.oh-my-zsh/custom/ ||
    errors="${errors}\n[ERROR] Oh My Zsh custom settings failed."
}


function fixGrub2
{
  # From: http://howtoubuntu.org/how-to-repair-restore-reinstall-grub-2-with-a-ubuntu-live-cd

  echo -e "\nYou are now in the operating system containing the grub installation?"
  echo -ne "(Answer NO if you are using a Live OS or another partition) [y/N]? "
  read -s -n 1 notlive

  if [ -z "$notlive" ] || [ "$notlive" != 'Y' ] && [ "$notlive" != 'y' ]
  then
    echo -e "\nThe script will mount the main partition and chroot to it."
    echo -ne "Specify the partition containing the grub installation. Example: /dev/sda1\n\n\t/dev/"
    read partition

    sudo mount /dev/$partition /mnt

    sudo mount --bind /dev /mnt/dev &&
    sudo mount --bind /dev/pts /mnt/dev/pts &&
    sudo mount --bind /proc /mnt/proc &&
    sudo mount --bind /sys /mnt/sys

    sudo chroot /mnt
  fi

  echo -ne "\nSpecify the bootloader's drive. Example: /dev/sda\n\n\t/dev/"
  read drive

  grub-install /dev/$drive
  grub-install --recheck /dev/$drive
  update-grub

  if [ -z "$notlive" ] || [ "$notlive" != 'Y' ] && [ "$notlive" != 'y' ]
  then
    exit &&
    sudo umount /mnt/sys &&
    sudo umount /mnt/proc &&
    sudo umount /mnt/dev/pts &&
    sudo umount /mnt/dev &&
    sudo umount /mnt
  fi

  echo -e "\nShut down and turn your computer back on, and you will be met with the default Grub2 screen."
  echo -e "You may want to update grub or re-install burg however you like it."
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
    "gitconfig" )
      setUserGitconfig
    ;;
    "oh-my-zsh" )
      setOhMyZshCustomSettings
    ;;
    "fixgrub" )
      fixGrub2
    ;;
    * )
      errors="${errors}\n[ERROR] Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
