# Javyre/etc

To link files to the proper places:
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

# TODO

- Use go templates with homemaker to get `$XDG_CONFIG_HOME` in places
    where it must be hardcoded (chicken-egg problems like `root/custom-rc.sh`).

- Use homemaker to replace `root/install.sh`
