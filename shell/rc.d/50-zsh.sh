if ! [ -n "$ZSH_VERSION" ]; then
    return
fi

bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
