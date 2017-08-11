#!/bin/bash

path=$(dirname $(readlink -f $0))  # Script path. Resolves symlinks
me=$(basename $0)  # script.sh
errors="\n"        # Container for error messages
download_path='/tmp/dotfiles'
files_path="${path}/files"


function showHelp
{
  cat <<EndOfHelp

    Install command line applications

    Usage:
        $me <packages>
        $me [ -h | --help ]

    Packages:
        basics        Basic command line packages
        oh-my-zsh     Customizable Zsh shell framework
        docker        Docker and Docker Compose
        ncdu          Disk space usage tool

EndOfHelp

  exit 0
}


function logError
{
  errors="${errors}\n[ERROR] $1"
}


function installBasicPackages
{
  sudo apt-get install -y vim ||
    logError "vim install failed"

  sudo apt-get install -y git ||
    logError "git install failed"

  sudo apt-get install -y curl ||
    logError "curl install failed"

  sudo apt-get install -y rar ||
    logError "rar install failed"
}


function installOhMyZsh
{
  echo -ne "\nThis will change the default shell to Zsh. Continue? [Y/n]"
  read -s -n 1 confirm

  [ -n "$confirm" ] && [ "$confirm" != 'Y' ] && [ "$confirm" != 'y' ] &&
    echo -e "\n" &&
    return 1

  install_script_url='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'

  sudo apt-get install -y zsh &&
    sh -c "$(wget ${install_script_url} -O -)" ||
    logError "oh-my-zsh install failed"

  cp -r ${files_path}/oh-my-zsh/* ~/.oh-my-zsh/custom/ ||
    logError "oh-my-zsh custom configuration failed"
}


function installDocker
{
  install_script="${download_path}/get-docker.sh"

  curl -fsSL get.docker.com -o "${install_script}" &&
    sudo sh "${install_script}" &&
    sudo usermod -aG docker "$(id --user --name)" ||
    logError "docker install failed"

  compose_latest_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
  compose_release_url="https://github.com/docker/compose/releases/download/${compose_latest_version}/docker-compose-$(uname -s)-$(uname -m)"
  compose_download_path="${download_path}/docker-compose"

  curl -L "${compose_release_url}" > "${compose_download_path}" &&
    sudo cp "${compose_download_path}" /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose ||
    logError "docker-compose install failed"
}


function installNcdu
{
  sudo apt-get install -y ncdu ||
    logError "ncdu install failed"
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
    "basics" )
      installBasicPackages
    ;;
    "oh-my-zsh" )
      installOhMyZsh
    ;;
    "docker" )
      installDocker
    ;;
    "ncdu" )
      installNcdu
    ;;
    * )
      logError "Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
