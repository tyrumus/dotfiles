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

sp() {
    echo -en "\033[1m"
    echo -en "\033[34m"
    echo -n "  -> "
    echo -en "\033[39m"
    echo -en "$1"
    echo -e "\033[0m"
}

set -e

sudo -v
keep_sudo &

ssp "Installing necessary utilities"
sudo pacman -S base-devel git rustup
rustup toolchain install stable

sp "Starting paru install"
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si --noconfirm
sp "paru install complete"

# get chosen chezmoi chassis
export CHEZMOI_CHASSIS=$(chezmoi execute-template "{{ .chassistype }}")

# build package list
ssp "Building package list"

# install packages
ssp "Installing all packages"
# paru --sudoloop --batchinstall --noconfirm --skipreview -Syu ${=PACKAGES}

# chezmoi reminders
export CHEZMOI_REMINDERS="$HOME/.cache/chezmoi-reminders.txt"

# run post-install scripts
ssp "Running post-install scripts"

if [[ -f ${CHEZMOI_REMINDERS} ]]; then
cat >>~/.cache/chezmoi-reminders.zsh <<EOL
#!/usr/bin/zsh

echo "Don't forget to configure the following stuff and things when you're ready:"

cat $CHEZMOI_REMINDERS

echo "Delete ${0} to stop these reminders."
EOL
fi
