export EDITOR=nvim
if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export LAUNCHER='bemenu-run -bil 20'
    export TERMINAL=foot
else
    export LAUNCHER='rofi -show run'
    export TERMINAL=alacritty
fi
export WALLPAPER="$HOME/Pictures/mountains-purple.jpg"
