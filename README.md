# Javyre/etc

To link and generate the files to the proper places:
```sh
./make
```

For other options:
```sh
./make -h
```

# Notes

- `tmux-256color` terminfo needs to be installed from the `ncurses-term`
    package in void. (`ncurses-base` doesn't contain tmux's definition)
    Bash  will break in tmux if this is missing.

- `$XDG_CONFIG_HOME` is semi-hardcoded in the configs for now. Run a
    quick `rg \.local/etc` to get an idea of it.
