#!/bin/bash
# most of this was taken from arch-install.zsh

USRNAME=tyrum
CHEZMOI_URL="https://github.com/tyrumus/dotfiles"

# setup locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# add sudo group
groupadd -g 27 sudo

# add our main user
useradd -m -s /usr/bin/zsh -G sudo ${USRNAME}

# prompt for main user's password
echo "Enter the main user's desired password:"
passwd ${USRNAME}

# pacman setup
mkdir -p /etc/pacman.conf.d
touch /etc/pacman.conf.d/dummy.conf
sed -i "s/\[options\]/\[options\]\\nInclude \= \/etc\/pacman.conf.d\/\*.conf/" /etc/pacman.conf
sed -i "s/#Color.*/Color/" /etc/pacman.conf
sed -i "s/#ParallelDownloads.*/ParallelDownloads = 5/" /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
sed -i "s/#MAKEFLAGS.*/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf

# update to latest packages
pacman -Syu --noconfirm

# install initial dependencies
pacman -Sy --needed --noconfirm chezmoi git zsh curl sudo

# enable passwordless use of sudo group
echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-nopasswd-wsl

# systemd setup
echo "KEYMAP=us" > /etc/vconsole.conf

# overwrite wsl.conf
echo "[boot]" > /etc/wsl.conf
echo "systemd=true" >> /etc/wsl.conf
echo "[user]" >> /etc/wsl.conf
echo "default=${USRNAME}" >> /etc/wsl.conf

# create the .zshrc for downloading chezmoi dotfiles
ZSHRC="/home/${USRNAME}/.zshrc"
echo > "${ZSHRC}"
chown ${USRNAME}:${USRNAME} "${ZSHRC}"
echo "rm ~/.zshrc" >> "${ZSHRC}"
echo "echo running chezmoi setup" >> "${ZSHRC}"
echo "chezmoi init ${CHEZMOI_URL}" >> "${ZSHRC}"

echo "Installation complete."
exit 0
