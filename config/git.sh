#!/bin/bash

##################################################
##
##    Manage Git configurations
##
##    Syntax: git.sh <packages>
##            git.sh [ -h | --help ]
##
##    Configs:
##            userconfig    User gitconfig file
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


# Check params
[ $# -eq 0 ] && showHelp

mkdir -p "$download_path"

for param in "$@"
do
  case "$param" in
    "-h" | "--help" )
      showHelp
    ;;
    "userconfig" )
      setUserGitconfig
    ;;
    * )
      errors="${errors}\n[ERROR] Invalid parameter: $param"
    ;;
  esac
done

echo -e "$errors\n"


exit 0
