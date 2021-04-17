# required to be owned by the user
[ ! -d /tmp/"$USER" ] && mkdir /tmp/"$USER"
export XDG_RUNTIME_DIR="/tmp/$USER"
 
export XDG_CONFIG_HOME="$HOME/{{ .Env.XDGC }}"
export XDG_CACHE_HOME="$HOME/{{ .Env.XDGCACHE }}"
export XDG_DATA_HOME="$HOME/{{ .Env.XDGD }}"
 
export LOG_HOME="$HOME/{{ .Env.LOGH }}"
