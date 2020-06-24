export PATH="$PATH:$HOME/.local/bin"
 
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

# required to be owned by the user
[ ! -d /tmp/javyre ] && mkdir /tmp/javyre
export XDG_RUNTIME_DIR="/tmp/javyre"
 
export XDG_CONFIG_HOME="$HOME/.local/etc"
export XDG_CACHE_HOME="$HOME/.local/var/cache"
export XDG_DATA_HOME="$HOME/.local/share"
 
export LOG_HOME="$HOME/.local/var/log"

