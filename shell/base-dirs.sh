# required to be owned by the user
[ ! -d /tmp/"$USER" ] && mkdir /tmp/"$USER"
export XDG_RUNTIME_DIR="/tmp/$USER"
 
export XDG_CONFIG_HOME="<%= "$XDGC" %>"
export XDG_CACHE_HOME="<%= "$XDGCACHE" %>"
export XDG_DATA_HOME="<%= "$XDGD" %>"
 
export LOG_HOME="<%= "$LOGH" %>"
