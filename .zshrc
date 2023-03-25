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
alias kp="kubectl get pods -A -o wide"
alias kn="kubectl get nodes -A -o wide"
alias k=kubectl
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Default
alias l=ls
alias ll="ls -lha"

# SSH
eval "$(ssh-agent)" 1>/dev/null
ssh-add -q /home/nkls/.ssh/github 

# Disable capslock and remap button to 'End'
setxkbmap -option caps:none
xmodmap -e "keycode 66 = End"

# SSH custom colors
# Set colors in ~/.ssh/config
ssh() {/usr/bin/ssh "$@"; konsoleprofile ColorScheme=Breath  }
