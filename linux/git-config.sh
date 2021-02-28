#!/bin/bash

path=$(dirname $(readlink -f $0))  # Script path. Resolves symlinks
me=$(basename $0)  # script.sh
errors="\n"        # Container for error messages
download_path='/tmp/dotfiles'
files_path="${path}/files"


function showHelp
{
  cat <<EndOfHelp

    Manage Git configuration

    Usage:
        $me --name <user.name> --email <user.email>
        $me [ -h | --help ]

EndOfHelp

  exit 0
}


function logError
{
  errors="${errors}\n[ERROR] $1"
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

  logError "git install failed"
  return 1
}


function setUserGitconfig
{
  name=$1
  email=$2

  if ! checkGitInstalled
  then
    logError "Git user config failed. Missing \"git\""
    return 1
  fi

  if [ -z "$name" ] || [ -z "$email" ]
  then
    echo -e "\nInsert default Git identity:"
    echo -ne "    name: "
    read name
    echo -ne "    email: "
    read email
  fi

  cp ../configs/git/gitconfig ~/.gitconfig &&
    git config --global user.name "${name}" &&
    git config --global user.email "${email}" ||
    logError "Git user config failed"
}


mkdir -p "$download_path"

if [ $# -eq 0 ]
then
  setUserGitconfig
elif [ $# -eq 4 ] && [ $1 == '--name' ] && [ $3 == '--email' ]
then
  setUserGitconfig "$2" "$4"
else
  showHelp
fi

echo -e "$errors\n"


exit 0
