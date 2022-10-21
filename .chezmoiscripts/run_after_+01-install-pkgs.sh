#!/bin/bash

# Utility functions
function keep_sudo() {
    while true; do
        sudo -v
        sleep 59
    done
}

function ssp() {
    echo -en "\033[1m"
    echo -en "\033[32m"
    echo -n "==> "
    echo -en "\033[39m"
    echo -en "CHEZMOI: ${1}"
    echo -e "\033[0m"
}

set -e

sudo -v
keep_sudo &

ssp "Installing necessary utilities"
sudo pacman -S base-devel git rustup
rustup toolchain install stable

ssp "Starting paru install"
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si --noconfirm
ssp "paru install complete"

# get chosen chezmoi chassis
# build package list
# install packages
# run post-install hooks
