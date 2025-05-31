# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

plugins=()


# User configuration

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(fzf --zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# https://github.com/nvm-sh/nvm#zsh
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

export LOCAL_PLATFORM_CONSUMPTION=true

export XDG_CONFIG_HOME="$HOME/.config"

alias tmux-nvim-open="$HOME/.config/scripts/tmux-nvim-open.sh"
alias tno="$HOME/.config/scripts/tmux-nvim-open.sh"

eval "$(zoxide init zsh)"

# gnu-sed as default sed
export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"

# Git shortcuts
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gca='git commit --amend'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gfo='git fetch origin'
alias gl='git log'
alias gpf='git push -f'
alias gpo='git pull origin'
alias gpom='git pull origin master'
alias gr='git rebase'
alias grc='git rebase --continue'
alias grm='git rebase master'
alias gs='git status'
alias gsw='git switch'
alias gswm='git switch master'

# General Aliases
alias v='nvim'
