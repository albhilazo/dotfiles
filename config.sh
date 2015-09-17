#!/bin/bash

###########################################################################################
##    @author     Albert Hilazo                                                          ##
##    @version    1.4.0                                                                  ##
##                                                                                       ##
##    Custom user profile configurations                                                 ##
##                                                                                       ##
##    Syntax: config.sh <parameters>                                                     ##
##            config.sh [ -h | --help ]                                                  ##
##                                                                                       ##
##    Parameters:                                                                        ##
##            init         Sets needed config parameters                                 ##
##            binln        Sets a list of custom soft links to these scripts             ##
##            aliases      Sets a list of custom aliases for the current user            ##
##            newalias     Adds a new alias for the current user                         ##
##            dircolors    Sets a list of custom terminal colors for the current user    ##
##            gshell       Configure general gnome shell tweaks                          ##
##            gshellext    Configure gnome shell extensions                              ##
##            gshellcal    Set the default calendar application for gnome shell          ##
##            fixgrub      Repair/restore Grub2                                          ##
##            ntfs         Fix NTFS partition permissions                                ##
##                                                                                       ##
###########################################################################################


path=$(dirname $(readlink -f $0))    # Script path. Resolves symlinks.
me=$(basename $0)                    # script.sh
SNIPPETS_PATH=
WALLPAPERS_PATH=
wallpArray=''




function showHelp
{
    echo -e "\n$me help:"
    sed '1,/\#\#\#\#/d;/\#\#\#\#/,$d;/ @/d;s/\#\#//g' $0
    exit 0
}




# Edits this same script to set the needed paths
function setPaths
{
    echo -e "\nPress ENTER to skip or reset any path configuration."

    echo -ne "\nInsert the wallpapers folder path: "
    read wpath

    #[ -n "$wpath" ] && [ ! -d "$wpath" ] && echo "[ERROR] Invalid wallpapers path '$wpath'" && exit 1

    originalfile=$(readlink -f $0)
    tmpfile=/tmp/$me.tmp
    cat $0 | sed "s#^WALLPAPERS_PATH=[a-zA-Z0-9._-]*#WALLPAPERS_PATH=$wpath#g" > $tmpfile
    mv $tmpfile $originalfile

    echo -ne "\nInsert the snippets folder path: "
    read spath

    [ -n "$spath" ] && [ ! -d "$spath" ] && echo "[ERROR] Invalid snippets path '$spath'" && exit 1

    originalfile=$(readlink -f $0)
    tmpfile=/tmp/$me.tmp
    cat $0 | sed "s#^SNIPPETS_PATH=[a-zA-Z0-9._-]*#SNIPPETS_PATH=$spath#g" > $tmpfile
    mv $tmpfile $originalfile

    exit 0
}




# Sets a list of custom soft links to tools scripts
function binSoftLinks
{
    # TODO check if already exists
    # TODO check if path to .sh is correct (-f)
    echo -e "\nNew bin links:"
    sudo ln -s $path/get.sh /usr/bin/get && echo -e "\tget"
    sudo ln -s $path/$me /usr/bin/config && echo -e "\tconfig"
    if [ -z "$SNIPPETS_PATH" ] || [ ! -d "$SNIPPETS_PATH" ]
    then
        echo "[WARNING] Unable to find snippets path '$SNIPPETS_PATH'"
    else
        sudo ln -s $path/snippets/snippets.sh /usr/bin/snipp && echo -e "\tsnipp"
        sudo ln -s $path/snippets/snippets.sh /usr/bin/snippets && echo -e "\tsnippets"
    fi
    echo ""
}




# Sets a list of custom aliases for the current user
function userAliases
{
    # Check if .bash_aliases file exists
    if [ -f ~/.bash_aliases ]
    then
        echo -ne "\nThere's already a ~/.bash_aliases file. Overwrite? [Y/n]"
        read -s -n 1 confirm
        
        [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] && echo "" && return

        # Backup original
        cp ~/.bash_aliases ~/.bash_aliases.bak
    fi

    cat $path/files/bash_aliases > ~/.bash_aliases

    echo -e "\n\n\t~/.bash_aliases\n"
}




# Adds a new alias for the current user
function newAlias
{
    echo -ne "\nInsert alias name: "
    read newAliasName
    echo -ne "Insert alias command: "
    read newAliasCmd

    echo "alias $newAliasName='$newAliasCmd'" >> ~/.bash_aliases

    echo -e "\n\tAlias added."
    echo -e "\talias $newAliasName='$newAliasCmd'\n"
}




# Sets a list of custom terminal colors for the current user
function userDircolors
{
    # Check if .dircolors file exists
    if [ -f ~/.dircolors ]
    then
        echo -ne "\nThere's already a ~/.dircolors file. Overwrite? [Y/n]? "
        read -s -n 1 confirm
        
        [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] && echo "" && return

        # Backup original
        cp ~/.dircolors ~/.dircolors.bak
    fi

    cat $path/files/dircolors > ~/.dircolors

    echo -e "\n\n\t~/.dircolors\n"
}




function getWallpapersArray
{
    [ -z "$WALLPAPERS_PATH" ] || [ ! -d "$WALLPAPERS_PATH" ] && echo "[ERROR] Unable to find wallpapers path '$WALLPAPERS_PATH'" && return 1
    [ $(ls -1 $WALLPAPERS_PATH | wc -l) -eq 0 ] && echo "[ERROR] Empty wallpapers directory '$WALLPAPERS_PATH'" && return 1

    wallpArray="['$WALLPAPERS_PATH/$(ls -1 $WALLPAPERS_PATH | head -n 1)'"
    wallpapers=$(ls -1 $WALLPAPERS_PATH)

    while read row
    do
        wallpArray="$wallpArray, '$WALLPAPERS_PATH/$row'"
    done <<< "${wallpapers:2}"

    wallpArray="$wallpArray]"

    return 0
}




function setGnomeShellTweaks
{
    echo ""

    gsettings set org.gnome.desktop.interface clock-show-date true &&
    echo -e "Shell clock will show date.\n" ||
    echo -e "[ERROR] Shell clock configuration failed.\n"

    # From: http://askubuntu.com/questions/40779/how-do-i-install-a-deb-file-via-the-command-line/40781#40781
    sudo dpkg -i $path/files/dmz-cursor-theme_0.4.3ubuntu1_all.deb &&
    gsettings set org.gnome.desktop.interface cursor-theme DMZ-White &&
    echo -e "White mouse cursor theme configured.\n" ||
    echo -e "[ERROR] Mouse cursor theme configuration failed.\n"

    gsettings set org.gnome.shell.overrides button-layout :minimize,maximize,close &&
    gsettings set org.gnome.desktop.wm.preferences theme Numix &&
    gsettings set org.gnome.desktop.interface gtk-theme Numix &&
    gsettings set org.gnome.desktop.interface icon-theme Numix-Circle &&
    gsettings set org.gnome.shell.extensions.user-theme name elegance-colors &&
    echo -e "Interface themes configured.\n" ||
    echo -e "[ERROR] Interface themes configuration failed.\n"

    gsettings set org.gnome.nautilus.preferences sort-directories-first true &&
    echo -e "Nautilus will show directories first.\n" ||
    echo -e "[ERROR] Nautilus configuration failed.\n"

    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false &&
    gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action nothing &&
    gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action nothing &&
    echo -e "Laptop won't suspend when lid is closed.\n" ||
    echo -e "[ERROR] Laptop power configuration failed.\n"
}




function setGnomeShellExtensionsConfig
{
    # From: http://blogs.nologin.es/rickyepoderi/index.php?/archives/50-Gnome-Shell-Extensions.html

    echo ""

    sudo cp ~/.local/share/gnome-shell/extensions/backslide@codeisland.org/schemas/org.gnome.shell.extensions.backslide.gschema.xml \
        /usr/share/glib-2.0/schemas/ &&
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ &&
    gsettings set org.gnome.desktop.background picture-options stretched &&
    gsettings set org.gnome.shell.extensions.backslide delay 60 &&
    getWallpapersArray && gsettings set org.gnome.shell.extensions.backslide image-list "$wallpArray" &&
    echo -e "Backslide configured and wallpaper mode set to stretched.\n" ||
    echo -e "[ERROR] Backslide configuration failed.\n"

    sudo cp ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas/org.gnome.shell.extensions.dash-to-dock.gschema.xml \
        /usr/share/glib-2.0/schemas/ &&
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ &&
    gsettings set org.gnome.shell.extensions.dash-to-dock show-running false &&
    echo -e "Dash to Dock configured.\n" ||
    echo -e "[ERROR] Dash to Dock configuration failed.\n"

    sudo cp ~/.local/share/gnome-shell/extensions/transmission-daemon@patapon.info/schemas/org.gnome.shell.extensions.mediaplayer.gschema.xml \
        /usr/share/glib-2.0/schemas/org.gnome.shell.extensions.transmission-daemon.gschema.xml &&
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ &&
    gsettings set org.gnome.shell.extensions.transmission-daemon always-show false &&
    gsettings set org.gnome.shell.extensions.transmission-daemon host localhost &&
    gsettings set org.gnome.shell.extensions.transmission-daemon port 9091 &&
    gsettings set org.gnome.shell.extensions.transmission-daemon stats-numeric true &&
    gsettings set org.gnome.shell.extensions.transmission-daemon stats-torrents true &&
    echo -e "Transmission Indicator configured. Remember to allow remote access in Transmission preferences.\n" ||
    echo -e "[ERROR] Transmission Indicator configuration failed.\n"

    sudo cp ~/.local/share/gnome-shell/extensions/yawl@dbfin.com/schemas/org.gnome.shell.extensions.dbfin.yawl.gschema.xml \
        /usr/share/glib-2.0/schemas/ &&
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ &&
    gsettings set org.gnome.shell.extensions.dbfin.yawl icons-favorites false &&
    gsettings set org.gnome.shell.extensions.dbfin.yawl move-center false &&
    echo -e "Yawl configured.\n" ||
    echo -e "[ERROR] Yawl configuration failed.\n"
}




function setGnomeShellDefaultCalendar
{
    echo -ne "\nInsert default calendar command: "
    read newDefaultCal

    gsettings set org.gnome.desktop.default-applications.office.calendar exec "$newDefaultCal"

    echo -e "\n\tDefault calendar changed to: $newDefaultCal\n"
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




# TODO
function fixNtfsPermissions
{
    echo -e "\n\tJust add \"umask=0000,uid=1000,gid=1000\" to the mount options of the ntfs partition."
}




# Check params
[ $# -eq 0 ] && showHelp

for param in "$@"
do
    case "$param" in
        "-h" | "--help" )
            showHelp
        ;;
        "init" )
            setPaths
        ;;
        "binln" )
            binSoftLinks
        ;;
        "aliases" )
            userAliases
        ;;
        "newalias" )
            newAlias
        ;;
        "dircolors" )
            userDircolors
        ;;
        "gshell" )
            setGnomeShellTweaks
        ;;
        "gshellext" )
            setGnomeShellExtensionsConfig
        ;;
        "gshellcal" )
            setGnomeShellDefaultCalendar
        ;;
        "fixgrub" )
            fixGrub2
        ;;
        "ntfs" )
            fixNtfsPermissions
        ;;
        * )
            echo -e "\n[ERROR] Invalid parameter: $param"
            showHelp
        ;;
    esac
done


exec bash

exit 0