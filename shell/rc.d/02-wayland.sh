if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ] ; then
    # https://github.com/swaywm/sway/issues/595
    export _JAVA_AWT_WM_NONREPARENTING=1

    export QT_QPA_PLATFORM=wayland-egl

    export ELM_DISPLAY=wl

    export MOZ_ENABLE_WAYLAND=1
fi
