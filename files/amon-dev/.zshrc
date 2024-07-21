export LANG=en_US.UTF-8

# history
HISTSIZE=9999

# zsh
export PATH=$PATH:~/.local/bin
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=( "gentoo" )
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# direnv
eval "$(direnv hook zsh)"

# zoxide
eval "$(zoxide init zsh)"

alias cd=z
