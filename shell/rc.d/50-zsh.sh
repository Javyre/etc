if ! [ -n "$ZSH_VERSION" ]; then
	return
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bindkey -e
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

if command -v exa >/dev/null; then
	alias ls=exa
fi
