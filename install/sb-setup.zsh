#!/usr/bin/zsh

set -e

if [ "$EUID" != 0 ]; then
    echo "Must run script as root."
    exit 1
fi

sbctl status
# TODO: verify Setup Mode status

sbctl create-keys
sbctl enroll-keys

sbctl status
# TODO: verify Setup Mode status

sbctl verify | xargs sbctl sign -s

sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi

sbctl verify

bootctl set-oneshot auto-reboot-to-firmware-setup

echo "Reboot when ready."
