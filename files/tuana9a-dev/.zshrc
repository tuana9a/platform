export LANG=en_US.UTF-8

# history
HISTSIZE=9999

# zsh
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/usr/local/go/bin
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=( "gentoo" )
plugins=(git zsh-autosuggestions aws gcloud kubectl kubectx)
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

PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %F{blue}%(!.%1~.%~) ${vcs_info_msg_0_}%F{white}($(kubectx_prompt_info)) %F{blue}%(!.#.$)%k%b%f '

# r2
alias r2='aws s3api --endpoint-url "$S3_ENDPOINT_URL"'
