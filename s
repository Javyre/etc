#!/bin/sh

upload(){
    curl -sH 'Authorization: Client-ID 67328d13363251e'   \
         -F  'image=@-' https://api.imgur.com/3/image     \
         | sed 's|.*"link":"\([^"]*\)".*|\1|;s|\\\/|\/|g'
}

scrot_upload() { maim -s "$@" | upload | xclip -sel clip;     }
scrot()        { maim -s "$@" | xclip -sel clip -t image/png; }

case "$1" in
    imgur) upload ;;
    scrot)
        shift
        if [ "$1" = "-u" ];
        then shift; scrot_upload "$@"
        else 
            if [ "$1" = "--" ]; then
                shift
            fi
            scrot "$@"
        fi
        ;;
    *)
        echo "Invalid command: $1" >&2
esac 
