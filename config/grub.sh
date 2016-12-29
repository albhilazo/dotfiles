#!/bin/bash

##################################################
##
##    Manage Grub configurations
##
##    Syntax: grub.sh <packages>
##            grub.sh [ -h | --help ]
##
##    Configs:
##            fixgrub       Repair/restore Grub2
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

for param in "$@"
do
  case "$param" in
    "-h" | "--help" )
      showHelp
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
