[ -z "$BASH_VERSION" ] && return
# Not much we can do about bash...

# Also see $XDG_CONFIG_HOME/root/custom-rc.sh
#  where I hard-code the sourceing in the /etc/bash/bashrc.d/

export HISTFILE="$XDG_DATA_HOME/bash/history"
