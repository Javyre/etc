#!/bin/sh

upload(){
    curl -sH 'Authorization: Client-ID 67328d13363251e'   \
         -F  'image=@-' https://api.imgur.com/3/image     \
         | sed 's|.*"link":"\([^"]*\)".*|\1|;s|\\\/|\/|g'
}

scrot_backend() {
    if [ -n "$WAYLAND_DISPLAY" ]; then 
        grim -g "$(slurp)" - "$@"
    elif [ -n "$DISPLAY" ]; then
        maim -su "$@"
    fi
}

copy_image() {
    if [ -n "$WAYLAND_DISPLAY" ]; then wl-copy
    elif [ -n "$DISPLAY" ]; then xclip -i -sel clip -t image/png
    fi
}

copy_text() {
    if [ -n "$WAYLAND_DISPLAY" ]; then wl-copy
    elif [ -n "$DISPLAY" ]; then xclip -i -sel clip
    fi
}

scrot_upload() { scrot_backend "$@" | upload | copy_text;     }
scrot_save()   { fname="$1"; shift; scrot_backend "$@" > "$fname"; }
scrot()        { scrot_backend "$@" | copy_image; }

# Screen record
screc() {
    if [ -z "$1" ]; then
        out=/tmp/demo.mp4
    else
        out="$1"
    fi

    slop -f "%wx%h +%x,%y" | {
        read -r size ofs

        echo "$size"

        ffmpeg -y                  \
               -f x11grab          \
               -framerate 25       \
               -video_size "$size" \
               -i :0.0"$ofs"       \
               "$out"
    }
}

case "$1" in
    imgur) upload ;;
    scrot)
        shift
        if [ "$1" = "-u" ]
        then shift; scrot_upload "$@"
        elif [ "$1" = "-o" ]
        then shift; scrot_save "$@"
        else 
            if [ "$1" = "--" ]; then
                shift
            fi
            scrot "$@"
        fi
        ;;
    screc)
        shift
        screc "$@"
        ;;

    audio-init)
        shift
        xdgtmux() {
            tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf" "$@"
        }
        xdgtmux new -ds audio \
            sh -c ~/.local/etc/root/service/jamyx/run \; \
            split-window sh -c "pavucontrol & pulseaudio -D && \
            pactl load-module module-jack-sink && \
            pactl load-module module-jack-source && \
            ~/.local/src/dev/Jamyxui2/jamyxui" \; \
            new-window -t:+ sh -c alsmixer \; \
            split-window -h sh -c mopidy \; \
            attach
        ;;

    ping)
        shift
        ping -c 1  google.com | sed -n 2p | cut -d= -f4 | cut -d' ' -f1 || echo 0
        ;;

    wayfire)
        shift
        (
            export XDG_SESSION_TYPE=wayland
            . "$XDG_CONFIG_HOME/shell/rc"
            dbus-launch wayfire 2>&1 >"$XDG_RUNTIME_DIR/wayfire.$(date +%F).log"
        )
        ;;

    *)
        echo "Invalid command: $1" >&2
esac 
