export LUA_ROCKS_TREE="$XDG_DATA_HOME/luarocks"
alias luarocks='luarocks --tree $LUA_ROCKS_TREE'
export PATH="$LUA_ROCKS_TREE/bin:$PATH"
