# Custom aliases


# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


# ls
alias ll='ls -lh'
alias la='ls -lAh'
alias lt='ls -ltrh'


# git
alias g='git'


# docker
alias d='docker'
alias dc='docker-compose'
alias d-run='docker run -ti --rm'
alias d-run-v='docker run -ti --rm -w /code -v $(pwd):/code'
alias dc-run='docker-compose run --rm'
alias d-clean='docker system prune --force --volumes'
alias d-rm-exited='docker rm $(docker ps -a -f status=exited -q)'
alias d-rmi-dangling='docker rmi $(docker images -f dangling=true -q)'
alias d-volume-rm-dangling='docker volume rm $(docker volume ls -f dangling=true -q)'


# other
alias clr='clear'

alias aws='docker run --rm -ti -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "$(pwd):/project" mesosphere/aws-cli'


# new
