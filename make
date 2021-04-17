#!/bin/sh -e

HM_TAR='https://foosoft.net/projects/homemaker/dl/homemaker_linux_amd64.tar.gz' 
bootstrap() {
    if ! [ -x .bin/homemaker ]; then
        curl "$HM_TAR" --output homemaker.tar.gz
        tar -xzf homemaker.tar.gz
        mkdir -p .bin
        mv homemaker_linux_amd64/homemaker .bin/
        rm -r homemaker.tar.gz homemaker_linux_amd64
    fi
}

sync() {
    .bin/homemaker -variant="$(hostname)" "$@" etc.toml .

    echo "Copying root files..."
    chmod a+x root/etc/sv/*/run
    sudo cp -r root/etc/sv/sv-* /etc/sv/
    sudo cp root/etc/bash/bashrc.d/rc-*.sh /etc/bash/bashrc.d/
}

bootstrap
sync "$@"
