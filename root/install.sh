#!/usr/bin/env sh

sdir="$HOME/.local/etc/root"

sudo cp "$sdir/custom-rc.sh" /etc/bash/bashrc.d/custom-rc.sh

sudo cp "$sdir/vlogger" /etc/vlogger
