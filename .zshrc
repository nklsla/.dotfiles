# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# Kubernetes
if [[ $commands[kubectl] ]]; then
  source <(kubectl completion zsh)
  alias kn="kubectl get nodes -n -all -o wide"
  alias kpp="kubectl get pods -A -o wide"
  alias kppe="kubectl get pods -A -o wide | grep -v Running"
  alias kp="kubectl get pods -o wide"
  alias kd="kubectl describe"
  alias k=kubectl
 fi
# [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
# alias kp="kubectl get pods -o wide"
# alias kpp="kubectl get pods -A -o wide"
# alias kn="kubectl get nodes -A -o wide"
# alias k=kubectl

# Docker
if [[ $commands[docker] ]]; then
  alias d=docker
  source ~/.dotfiles/.dockerautocomplete_zsh
fi
# alias d=docker
# source .dockerautocomplete_zsh

# Default
alias l=ls
alias ll="ls -lha"

# SSH - add private key
eval "$(ssh-agent)" 1>/dev/null
ssh-add -q /home/nkls/.ssh/github 

# Disable capslock and remap button to 'End'
setxkbmap -option caps:none
xmodmap -e "keycode 66 = End"

# SSH custom colors
# Set colors in ~/.ssh/config
ssh() {/usr/bin/ssh "$@"; konsoleprofile ColorScheme=Breath  }

# Sudoedit
export EDITOR=vim
alias sudoe="sudoedit @$"
