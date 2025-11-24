export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto

# for vim mode
export KEYTIMEOUT=1
bindkey -v

plugins=(git vi-mode)


source $ZSH/oh-my-zsh.sh

MODE_INDICATOR="%B%F{cyan}<%b%f"

export EDITOR=nvim

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
