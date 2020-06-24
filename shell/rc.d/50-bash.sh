[ -z "$BASH_VERSION" ] && return
# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bind '"\C-o":"lfcd\C-m"'

export CLICOLOR=1

PS1='[\u@\h \W]\$ '
