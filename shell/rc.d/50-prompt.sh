
# thanks cherryman, but mine is probably faster...
# min_path() {
#     dir="$1"

#     case "$dir" in
#         "$HOME")
#             echo '~'
#             return ;;
#         "$HOME"*)
#             dir="${dir#$HOME}"
#             minpath='~' ;;
#     esac

#     dir="${dir#/}"
#     while [ "$dir" != "${dir##*/}" ]; do
#         d="${dir%%/*}"
#         minpath="$minpath/${d%${d#?}}"
#         dir="${dir#*/}"
#     done

#     echo "$minpath/$dir"
#     unset minpath dir d
# }

esc() {
    if   [ "$BASH" ];     then echo "\[$*\]"
    elif [ "$ZSH_NAME" ]; then echo "%{$*%}"
    else echo "$*"
    fi
}

min_path() {
    case "$1" in
        "$HOME")
            echo '~';;

        "$XDG_CONFIG_HOME")
            echo '@';;
        "$XDG_CONFIG_HOME"*)
            echo '@'"$(basename "$1")";;

        "$HOME/.local/src")
            echo '+';;
        "$HOME/.local/src"*)
            echo '+'"$(basename "$1")";;

        *)
            echo "$(basename "$1")";;
    esac
}

esc="" # escape character
bld="$(esc "$esc[1m")"
blu="$(esc "$esc[34m")"
rst="$(esc "$esc[00m")"

export PS1='$(min_path "$PWD") '"$bld$blu$(whoami)$rst"' -> ' # colors added in shell's rc

unset ESC CLR_BLU CLR_RST
