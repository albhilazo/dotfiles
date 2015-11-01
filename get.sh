#!/bin/bash

##########################################################################
##    @author     Albert Hilazo                                         ##
##    @version    1.2.1                                                 ##
##                                                                      ##
##    Set of package installations                                      ##
##                                                                      ##
##    Syntax: get.sh <packages>                                         ##
##            get.sh [ -h | --help ]                                    ##
##                                                                      ##
##    Packages:                                                         ##
##            basics      Basic command line packages                   ##
##            utweak      Ubuntu tweak                                  ##
##            burg        Burg graphical bootloader                     ##
##            grubcst     Grub/Burg customizer                          ##
##            themes      Faience, Numix and Elegance Colors themes     ##
##            extras      Extra codecs and Java JDK                     ##
##            aptik       Automated package backup and restore          ##
##            nauterm     Nautilus "Open in Terminal" plugin            ##
##            imgtools    Nautilus Image Tools                          ##
##            msfonts     Microsoft core fonts                          ##
##            jupiter     Jupiter battery manager                       ##
##            tlp         TLP battery manager                           ##
##            bumblebee   Nvidia Optimus GPU switching                  ##
##            xboxdrv     Ubuntu Xbox controller driver                 ##
##            guake       Guake Terminal                                ##
##            fnlterm     Final Term terminal emulator                  ##
##            betty       Siri-like assistant for the command line      ##
##            trs         Google Translate client for the command line  ##
##            termnot     Terminal notifications                        ##
##            ncdu        Disk space usage tool                         ##
##            gpie        Gnome Pie launcher                            ##
##            california  California calendar                           ##
##            subtext     Sublime Text 2 editor                         ##
##            brackets    Brackets web code editor                      ##
##            gimp        Gimp with plugins, filters and effects        ##
##            qbitt       Qbittorrent                                   ##
##            vlc         VLC media player                              ##
##            screenrec   Simple Screen Recorder                        ##
##            nuvola      Nuvola player for google play music           ##
##            rhythmgm    Rhythmbox Google Play Music Plugin            ##
##            pudtag      Puddletag audio tag editor                    ##
##            selene      Selene media encoder/converter                ##
##                                                                      ##
##########################################################################


me=$(basename $0)    # script.sh
errors='\n'




function showHelp
{
    echo -e "\n$me help:"
    sed '1,/\#\#\#\#/d;/\#\#\#\#/,$d;/ @/d;s/\#\#//g' $0
    exit 0
}




# Basic command line packages
function Basics
{
    sudo apt-get install vim ||
    errors="$errors[ERROR] vim installation failed."
    sudo apt-get install gksu ||
    errors="$errors[ERROR] gksu installation failed."
    sudo apt-get install rar ||
    errors="$errors[ERROR] rar installation failed."
    sudo apt-get install git ||
    errors="$errors[ERROR] git installation failed."
    # TODO: configure git
}




function UbuntuTweak
{
    # From: http://www.ubuntugeek.com/how-to-install-ubuntu-tweak-0-7-0-in-ubuntu-12-04-precise.html
    # Or: http://ubuntu-tweak.com/downloads/
    sudo add-apt-repository ppa:tualatrix/ppa &&
    sudo apt-get update
    sudo apt-get install ubuntu-tweak ||
    errors="$errors\n[ERROR] ubuntu-tweak installation failed."
}




function Burg
{
    # From: http://linuxg.net/how-to-install-burg-on-ubuntu-13-04-12-10-12-04-and-linux-mint-15-14-13/
    sudo add-apt-repository ppa:n-muench/burg &&
    sudo apt-get update
    sudo apt-get install burg burg-themes burg-emu ||
    errors="$errors\n[ERROR] burg installation failed."

    echo -ne "\nSpecify the bootloader's drive. Example: /dev/sda\n\n\t/dev/"
    read drive

    sudo burg-install /dev/$drive
    sudo update-burg
    # TODO: add theme here
    echo -e "\n\tAdd themes to /boot/burg/themes and run:\n\t\tsudo update-burg"
    echo -e "\tTo configure Burg run the command:\n\t\tsudo burg-emu -D"

    echo -ne "\nPress any key to continue... "
    read -s -n 1 confirm
}




function GrubCustomizer
{
    # From: http://www.ubuntugeek.com/how-to-install-grub-customizer-in-ubuntu-13-04.html
    sudo add-apt-repository ppa:danielrichter2007/grub-customizer &&
    sudo apt-get update
    sudo apt-get install grub-customizer ||
    errors="$errors\n[ERROR] grub-customizer installation failed."
}




function Themes
{
    # From: http://www.webupd8.org/2013/01/beautiful-mediterraneannight-gtk-36.html
    sudo add-apt-repository ppa:webupd8team/themes
    # From: http://numixproject.org/
    sudo add-apt-repository ppa:numix/ppa
    # From: http://satya164.deviantart.com/art/Gnome-Shell-Elegance-Colors-305966388
    sudo add-apt-repository ppa:satyajit-happy/themes

    sudo apt-get update
    sudo apt-get install mediterraneannight-gtk-theme faience-azur-dark ||
    errors="$errors\n[ERROR] mediterranean and faience themes installation failed."
    sudo apt-get install numix-gtk-theme numix-icon-theme numix-icon-theme-circle numix-icon-theme-shine ||
    errors="$errors\n[ERROR] numix themes installation failed."
    sudo apt-get install gnome-shell-theme-elegance-colors ||
    errors="$errors\n[ERROR] elegance-colors theme installation failed."
}




function UbuntuExtrasJava
{
    sudo apt-get install ubuntu-restricted-extras
    sudo apt-get install icedtea-7-plugin openjdk-7-jre
    sudo apt-get install openjdk-7-jdk
}




function Aptik
{
    # From: http://www.omgubuntu.co.uk/2014/01/reinstall-apps-on-ubuntu-fresh-install
    sudo add-apt-repository ppa:teejee2008/ppa &&
    sudo apt-get update
    sudo apt-get install aptik ||
    errors="$errors\n[ERROR] aptik installation failed."
}




function NautilusOpenTerminal
{
    # From: http://askubuntu.com/questions/207442/how-to-add-open-terminal-here-to-nautilus-context-menu
    sudo apt-get install nautilus-open-terminal ||
    errors="$errors\n[ERROR] nautilus-open-terminal installation failed."
    nautilus -q
}




function NautilusImageTools
{
    # From: http://www.webupd8.org/2013/12/manipulate-images-in-nautilus-or-nemo.html
    sudo add-apt-repository ppa:atareao/nautilus-extensions &&
    sudo apt-get update
    sudo apt-get install nautilus-image-tools ||
    errors="$errors\n[ERROR] nautilus-image-tools installation failed."
}




function MsCoreFonts
{
    sudo apt-get install ttf-mscorefonts-installer
}




function Jupiter
{
    sudo add-apt-repository ppa:jolicloud-team/ppa &&
    sudo apt-get update
    sudo apt-get install jupiter ||
    errors="$errors\n[ERROR] jupiter installation failed."
}




function TLP
{
    # From: http://www.webupd8.org/2013/04/improve-power-usage-battery-life-in.html
    sudo apt-get remove laptop-mode-tools
    sudo add-apt-repository ppa:linrunner/tlp &&
    sudo apt-get update
    sudo apt-get install tlp tlp-rdw ||
    errors="$errors\n[ERROR] tlp installation failed."
    sudo tlp start
}




function Bumblebee
{
    # From: http://www.webupd8.org/2013/04/bumblebee-321-released-with-ubuntu-1304.html
    sudo add-apt-repository ppa:bumblebee/stable &&
    sudo apt-get update
    sudo apt-get install bumblebee ||
    errors="$errors\n[ERROR] bumblebee installation failed."

    sudo apt-get install primus
    sudo apt-get install primus-libs-ia32

    echo -e "
    To configure Bumblebee you must decide if you want to use Nouveau or the proprietary Nvidia drivers.
    If you want to use the proprietary Nvidia drivers, take a look at the version you've installed (e.g.: nvidia-304),
    then, open the bumblebee configuration file as root with a text editor:
        gksu gksu gedit /etc/bumblebee/bumblebee.conf

    And in this file, change:
        \"Driver\" to \"Driver=nvidia\"
        \"KernelDriver\" to \"KernelDriver=nvidia-VERSION\" (e.g.: nvidia-304)
        \"LibraryPath\" to \"LibraryPath=/usr/lib/nvidia-VERSION:/usr/lib32/nvidia-VERSION\"
        (e.g.: LibraryPath=/usr/lib/nvidia-304:/usr/lib32/nvidia-304)
        \"XorgModulePath\" to \"XorgModulePath=/usr/lib/nvidia-VERSION/xorg,/usr/lib/xorg/modules\"
        (e.g.: XorgModulePath=/usr/lib/nvidia-304/xorg,/usr/lib/xorg/modules)

    To run a game or application using the dedicated GPU (Nvidia), use the following command:
        primusrun APP-EXECUTABLE"

    echo -ne "\nPress any key to continue... "
    read -s -n 1 confirm
}




function UbuntuXboxControllerDriver
{
    # From: http://www.omgubuntu.co.uk/2014/06/ubuntu-xbox-controller-support-xboxdrv-driver
    sudo apt-add-repository ppa:rael-gc/ubuntu-xboxdrv &&
    sudo apt-get update
    sudo apt-get install ubuntu-xboxdrv ||
    errors="$errors\n[ERROR] ubuntu-xboxdrv installation failed."

    echo -e "\nYou may want to reboot your computer to ensure that the new driver takes precedence over the default one."
    echo -e "You can adjust specific settings via the Joystick pane in the Software Centre."

    echo -ne "\nPress any key to continue... "
    read -s -n 1 confirm
}




function Guake
{
    sudo apt-get install guake ||
    errors="$errors\n[ERROR] guake installation failed."
}




function FinalTerm
{
    # http://finalterm.org
    # https://github.com/p-e-w/finalterm
    sudo add-apt-repository ppa:finalterm/daily &&
    sudo apt-get update
    sudo apt-get install finalterm ||
    errors="$errors\n[ERROR] finalterm installation failed."
}




function Betty
{
    # From: http://www.webupd8.org/2014/05/betty-is-like-siri-or-google-now-for.html
    sudo apt-get install ruby curl
    sudo apt-get install git
    cd /opt && sudo git clone https://github.com/pickhardt/betty
}




function GoogleTranslateCLI
{
    # From: http://www.webupd8.org/2014/03/google-translate-cli-lets-you-translate.html
    sudo apt-get install gawk wget
    cd /tmp
    wget https://github.com/soimort/google-translate-cli/archive/master.tar.gz
    tar -xvf master.tar.gz
    cd google-translate-cli-master/
    sudo make install
}




function TerminalNotifications
{
    # From: http://www.webupd8.org/2013/01/notifies-terminal-commands-completed-undistract-me.html
    sudo add-apt-repository ppa:undistract-me-packagers/daily &&
    sudo apt-get update
    sudo apt-get install undistract-me ||
    errors="$errors\n[ERROR] undistract-me installation failed."

    echo -e "\n\tRemember to enable \"Run command as login shell\" in terminal preferences so notifications can work."

    echo -ne "\nPress any key to continue... "
    read -s -n 1 confirm
}




function ncdu
{
    # From: http://www.binarytides.com/check-disk-usage-linux-ncdu/
    sudo apt-get install ncdu ||
    errors="$errors\n[ERROR] ncdu installation failed."
}




function GnomePie
{
    # From: http://www.omgubuntu.co.uk/2015/04/gnome-pie-launcher-ubuntu-ppa
    sudo add-apt-repository ppa:simonschneegans/testing -y &&
    sudo apt-get update
    sudo apt-get install gnome-pie ||
    errors="$errors\n[ERROR] gnome-pie installation failed."
}




function CaliforniaCalendar
{
    # From: http://www.omgubuntu.co.uk/2014/05/california-calendar-app-hits-yorba-daily-ppa
    sudo add-apt-repository ppa:yorba/daily-builds &&
    sudo apt-get update
    sudo apt-get install california ||
    errors="$errors\n[ERROR] california installation failed."
}




function SublimeText
{
    # From: http://www.webupd8.org/2011/03/sublime-text-2-ubuntu-ppa.html
    sudo add-apt-repository ppa:webupd8team/sublime-text-2 &&
    sudo apt-get update
    sudo apt-get install sublime-text ||
    errors="$errors\n[ERROR] sublime-text installation failed."
}




function Brackets
{
    # From: http://www.webupd8.org/2013/11/install-brackets-in-ubuntu-via-ppa-open.html
    sudo add-apt-repository ppa:webupd8team/brackets &&
    sudo apt-get update
    sudo apt-get install brackets ||
    errors="$errors\n[ERROR] brackets installation failed."
}




function Gimp
{
    # From: http://www.webupd8.org/2013/02/gimp-284-released-install-it-in-ubuntu.html
    sudo add-apt-repository ppa:otto-kesselgulasch/gimp &&
    sudo apt-get update
    sudo apt-get install gimp ||
    errors="$errors\n[ERROR] gimp installation failed."

    # From the same PPA you can also install GIMP Plugin Registry which is a collection of hundreds of GIMP plugins:
    sudo apt-get install gimp-plugin-registry

    # G'MIC is also available in this PPA. It's a tool that comes with a huge list of filters and effects:
    sudo apt-get install gimp-gmic
}




function Qbittorrent
{
    # From: http://www.webupd8.org/2013/10/cross-platform-bittorrent-client.html
    sudo add-apt-repository ppa:hydr0g3n/qbittorrent-stable &&
    sudo apt-get update
    sudo apt-get install qbittorrent ||
    errors="$errors\n[ERROR] qbittorrent installation failed."
}




function VLCMediaPlayer
{
    sudo apt-get install vlc ||
    errors="$errors\n[ERROR] vlc installation failed."
}




function SimpleScreenRecorder
{
    # From: http://www.omgubuntu.co.uk/2013/12/simple-screen-recorder-linux
    sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder &&
    sudo apt-get update
    sudo apt-get install simplescreenrecorder ||
    errors="$errors\n[ERROR] simplescreenrecorder installation failed."
}




function NuvolaPlayer
{
    # From: http://www.omgubuntu.co.uk/2011/11/getting-started-with-google-music-on-ubuntu
    sudo add-apt-repository ppa:nuvola-player-builders/stable &&
    sudo apt-get update
    sudo apt-get install nuvolaplayer ||
    errors="$errors\n[ERROR] nuvolaplayer installation failed."
}




function RythmboxGoogleMusic
{
    # From: http://www.webupd8.org/2013/08/rhythmbox-google-play-music-plugin.html
    sudo add-apt-repository ppa:nvbn-rm/ppa &&
    sudo apt-get update
    sudo apt-get install rhythmbox-gmusic python-dateutil python-requests python-validictory ||
    errors="$errors\n[ERROR] rhythmbox-gmusic installation failed."

    echo -e "\n\tEnable in the Rythmbox plugin menu"
    echo -e "\n\tIf it doesn't work, install python-google-oauth2client:"
    echo -e "\thttps://code.google.com/p/google-api-python-client/downloads/detail?name=python-google-oauth2client_1.2.0-1_all.deb"

    echo -ne "\nPress any key to continue... "
    read -s -n 1 confirm
}




function Puddletag
{
    # From: http://www.webupd8.org/2012/08/audio-tag-editor-puddletag-100-stable.html
    sudo add-apt-repository ppa:webupd8team/puddletag &&
    sudo apt-get update
    sudo apt-get install puddletag ||
    errors="$errors\n[ERROR] puddletag installation failed."
}




function SeleneMediaEncoder
{
    # From: http://www.webupd8.org/2014/06/convert-audio-video-files-with-selene.html
    sudo apt-add-repository ppa:teejee2008/ppa &&
    sudo apt-get update
    sudo apt-get install selene ||
    errors="$errors\n[ERROR] selene installation failed."
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
            Basics
        ;;
        "utweak" )
            UbuntuTweak
        ;;
        "burg" )
            Burg
        ;;
        "grubcst" )
            GrubCustomizer
        ;;
        "themes" )
            Themes
        ;;
        "extras" )
            UbuntuExtrasJava
        ;;
        "aptik" )
            Aptik
        ;;
        "nauterm" )
            NautilusOpenTerminal
        ;;
        "imgtools" )
            NautilusImageTools
        ;;
        "msfonts" )
            MsCoreFonts
        ;;
        "jupiter" )
            Jupiter
        ;;
        "tlp" )
            TLP
        ;;
        "bumblebee" )
            Bumblebee
        ;;
        "xboxdrv" )
            UbuntuXboxControllerDriver
        ;;
        "guake" )
            Guake
        ;;
        "fnlterm" )
            FinalTerm
        ;;
        "betty" )
            Betty
        ;;
        "trs" )
            GoogleTranslateCLI
        ;;
        "termnot" )
            TerminalNotifications
        ;;
        "ncdu" )
            ncdu
        ;;
        "gpie" )
            GnomePie
        ;;
        "california" )
            CaliforniaCalendar
        ;;
        "subtext" )
            SublimeText
        ;;
        "brackets" )
            Brackets
        ;;
        "gimp" )
            Gimp
        ;;
        "qbitt" )
            Qbittorrent
        ;;
        "vlc" )
            VLCMediaPlayer
        ;;
        "screenrec" )
            SimpleScreenRecorder
        ;;
        "nuvola" )
            NuvolaPlayer
        ;;
        "rhythmgm" )
            RythmboxGoogleMusic
        ;;
        "pudtag" )
            Puddletag
        ;;
        "selene" )
            SeleneMediaEncoder
        ;;
        * )
            echo -e "\n[ERROR] Invalid parameter: $param"
            showHelp
        ;;
    esac
done

echo -e "$errors\n"


exit 0