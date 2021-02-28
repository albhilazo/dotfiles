#!/usr/bin/env bash

me=$(basename $0)


showHelp ()
{
  cat <<EndOfHelp

    Configures Git

    Usage:
        $me [ -h | --help ]
    
EndOfHelp
}


log ()
{
  echo -e "\n[${me}] $1\n"
}


copyGitConfigurations ()
{
  log "Copying Git configuration, aliases and global ignore"
  cp ../configs/git/gitconfig ~/.gitconfig
  cp ../configs/git/gitignore ~/.gitignore
}


setGitIdentity ()
{
  log "Setting Git identity"

  echo -e "\nInsert default Git identity:"
  echo -n "    name: "
  read name
  echo -n "    email: "
  read email

  git config --global user.name "${name}" &&
    git config --global user.email "${email}"
}


setSecondaryGitIdentity ()
{
  log "Setting secondary Git identity"
  git config --global includeIf."gitdir:~/devel/repos/".path ".gitconfig-repos"
}


for argument in "$@"
do
  case "$argument" in
    "-h" | "--help" )
      showHelp
      exit 0
    ;;
    * )
      log "Invalid parameter"
      exit 1
    ;;
  esac
done

copyGitConfigurations &&
  setGitIdentity
setSecondaryGitIdentity

exit 0