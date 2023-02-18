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

  echo -e "\nInsert default Git identity"
  read -p "    name: " name
  read -p "    email: " email

  git config --global user.name "${name}" &&
    git config --global user.email "${email}"
}


setSecondaryGitIdentity ()
{
  log "Setting secondary Git identity"

  echo -e "\nInsert the path that will use a different identity"
  read -p "    path: " gitdirPath

  echo -e "\nInsert Git identity for this path"
  read -p "    name: " name
  read -p "    email: " email

  mkdir -pv ${gitdirPath/#~/$HOME}
  parsedPath=$(echo "${gitdirPath}" | sed "s/~//g" | sed "s/\//-/g")
  gitconfigPath=~/.gitconfig${parsedPath}

  cat > ${gitconfigPath} <<EndOfGitconfig
[user]
    name = ${name}
    email = ${email}
EndOfGitconfig

  [[ "${gitdirPath}" != */ ]] && gitdirPath="${gitdirPath}/" # Ensure trailing slash
  git config --global includeIf."gitdir:${gitdirPath}".path "${gitconfigPath}"
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
      showHelp
      exit 1
    ;;
  esac
done

copyGitConfigurations &&
  setGitIdentity
setSecondaryGitIdentity

exit 0
