
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
if [ "$BASH" ]; then
    bld="$(esc "$esc[1m")"
    blu="$(esc "$esc[34m")"
    red="$(esc "$esc[31m")"
    rst="$(esc "$esc[00m")"
elif [ "$ZSH_NAME" ]; then
    bld="$(esc $'\e[1m')"
    blu="$(esc $'\e[34m')"
    red="$(esc $'\e[31m')"
    rst="$(esc $'\e[00m')"
fi

if [ "$ZSH_NAME" ]; then
    setopt prompt_subst
fi

export PS1='$(
    exit_stat=$?
    printf "%s %s%s%s%s -> "                                            \
        "$(min_path "$PWD")"                                            \
        "'"$bld"'"                                                      \
        "$([ $exit_stat -eq 0 ] && echo "'"$blu"'" || echo "'"$red"'")" \
        "$(whoami)"                                                     \
        "'"$rst"'"
)'

unset -v esc bld blu red rst
unset -f esc
