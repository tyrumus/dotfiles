#!/usr/bin/zsh
# vim: ft=zsh

### INITIAL SCRIPT SETUP ###

# check for functioning internet connection
# probably pointless, since this script is intended to be downloaded from the internet
echo -n "Checking internet connection: "
curl https://archlinux.org &> /dev/null
if [[ $? = 0 ]]; then
    echo "SUCCESS"
else
    echo "FAIL: Unable to connect to archlinux.org"
    exit 1
fi

pacman -Sy
pacman -S --noconfirm gum &> /dev/null

alias ssp="gum style --foreground 45 --bold"
alias sp="gum style --foreground 45 --faint"
alias load="gum spin --spinner dot"

# verify boot mode (is it 64-bit UEFI?)
ssp "Verifying boot mode..."
if [[ $(cat /sys/firmware/efi/fw_platform_size) = "64" ]]; then
    gum style --foreground 2 --bold "SUCCESS"
else
    gum style --foreground 1 --bold "FAIL: 64-bit UEFI boot not detected."
    exit 1
fi

# exit script if any command returns nonzero
set -e

### USER INPUT FOR OPTIONS ###
echo
echo
gum style --foreground 45 --italic "Please answer the following prompts for unattended installation"

# prompt for root passwords
ssp "Enter password for root"
ROOT_PASSWD=""
ROOT_PASSWD_CONF="a"
ROOT_PASSWD=$(gum input --password --placeholder "Enter password" --cursor.foreground 45)
ROOT_PASSWD_CONF=$(gum input --password --placeholder "Confirm password" --cursor.foreground 45)
while [ ! "${ROOT_PASSWD}" = "${ROOT_PASSWD_CONF}" ]; do
    sp "Passwords don't match!"
    ROOT_PASSWD=$(gum input --password --placeholder "Enter password" --cursor.foreground 45)
    ROOT_PASSWD_CONF=$(gum input --password --placeholder "Confirm password" --cursor.foreground 45)
done
clear

# prompt for username
ssp "Enter username for sudoer account (default user)"
USRNAME=$(gum input --placeholder "Enter username" --cursor.foreground 45)
clear

# prompt for user password
ssp "Enter password for ${USRNAME}"
USER_PASSWD=""
USER_PASSWD_CONF="a"
USER_PASSWD=$(gum input --password --placeholder "Enter password" --cursor.foreground 45)
USER_PASSWD_CONF=$(gum input --password --placeholder "Confirm password" --cursor.foreground 45)
while [ ! "${USER_PASSWD}" = "${USER_PASSWD_CONF}" ]; do
    sp "Passwords don't match!"
    USER_PASSWD=$(gum input --password --placeholder "Enter password" --cursor.foreground 45)
    USER_PASSWD_CONF=$(gum input --password --placeholder "Confirm password" --cursor.foreground 45)
done
clear

# prompt for disk password
ssp "Enter password for disk encryption"
DISK_PASSWD=""
DISK_PASSWD_CONF="a"
DISK_PASSWD=$(gum input --password --placeholder "Enter password" --cursor.foreground 45)
DISK_PASSWD_CONF=$(gum input --password --placeholder "Confirm password" --cursor.foreground 45)
while [ ! "${DISK_PASSWD}" = "${DISK_PASSWD_CONF}" ]; do
    sp "Passwords don't match!"
    DISK_PASSWD=$(gum input --password --placeholder "Enter password" --cursor.foreground 45)
    DISK_PASSWD_CONF=$(gum input --password --placeholder "Confirm password" --cursor.foreground 45)
done
clear

# prompt for hostname
ssp "Enter hostname"
HOSTNAME=$(gum input --placeholder "Hostname")
clear

# prompt for timezone
ssp "Enter timezone"
TIMEZONE=$(gum input --value "Europe/Zurich")
clear

# prompt for drive info
ssp "Select storage device to install OS to. NOTE: This device will be wiped."
DATA=$(gum choose $(lsblk --nodeps --output name --list | grep -v NAME))
DRIVE="/dev/${DATA}"
clear

# prompt for chezmoi URL
set +e
ssp "Enter URL for chezmoi repository. Press ESC to not deploy."
CHEZMOI_URL=$(gum input --value "https://github.com/tyrumus/dotfiles")
clear
set -e

POTENTIAL_PACKAGES="base base-devel linux linux-firmware chezmoi dhcpcd git sudo systemd-ukify openresolv sbctl neovim plymouth wget zsh"
LAPTOP_PACKAGES="iwd"
ALL_PACKAGES="${POTENTIAL_PACKAGES} ${LAPTOP_PACKAGES} linux-lts nvidia nvidia-lts"

if [ ! -z "$(ls /sys/class/power_supply)" ]; then
    sp "Laptop power supply discovered"
    POTENTIAL_PACKAGES="${POTENTIAL_PACKAGES} ${LAPTOP_PACKAGES}"
fi
POTENTIAL_PACKAGES=$(echo ${POTENTIAL_PACKAGES} | sed -r "s/[ ]+/,/g")

# let user select which packages they want
ssp "Select packages to install. To select nothing, press Escape"
SELECTED_PACKAGES=$(gum choose --height=15 --no-limit --selected=${POTENTIAL_PACKAGES} ${=ALL_PACKAGES})
clear
PRETTY_SELECTED_PACKAGES=$(echo ${=SELECTED_PACKAGES} | sed -r "s/[\\n]+/ /g")

KERNEL_NAME=linux
if [[ "${SELECTED_PACKAGES}" == *"linux-lts"* ]]; then
    KERNEL_NAME=linux-lts
fi

USR_SHELL="/bin/bash"
if [[ "${SELECTED_PACKAGES}" == *"zsh"* ]]; then
    USR_SHELL="/usr/bin/zsh"
fi

MKINITCPIO_HOOKS="systemd autodetect modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck"
if [[ "${SELECTED_PACKAGES}" == *"plymouth"* ]]; then
    MKINITCPIO_HOOKS="systemd autodetect modconf kms keyboard sd-vconsole block plymouth sd-encrypt filesystems fsck"
fi

# let user set additional kernel parameters
ssp "Enter additional kernel parameters"
KERNEL_PARAMS=$(gum input --value "quiet splash")
clear

ssp --underline "Installation preferences"
sp "sudoer account       -> ${USRNAME}"
sp "Hostname             -> ${HOSTNAME}"
sp "Timezone             -> ${TIMEZONE}"
sp "OS Drive             -> ${DRIVE}"
if [ ! -z "${CHEZMOI_URL}" ]; then
    sp "Chezmoi URL          -> ${CHEZMOI_URL}"
else
    sp "Chezmoi URL          -> Not deploying"
fi
sp "Packages             -> ${PRETTY_SELECTED_PACKAGES}"
sp "All kernel params:   -> ${KERNEL_PARAMS}"
sp "Default shell        -> ${USR_SHELL}"
gum confirm "Proceed with install?" --selected.background=45 --selected.foreground=0

ssp "Starting unattended install..."

sp "Enabling NTP"
timedatectl set-ntp true

sp "Partitioning the disk"
echo 'label: gpt' | sfdisk "$DRIVE"
echo -e 'size=512MiB, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B\n size=-, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709' | sfdisk "$DRIVE"

if [ -b "${DRIVE}1" ]; then
    DRIVE_ESP="${DRIVE}1"
    DRIVE_ROOT="${DRIVE}2"
elif [ -b "${DRIVE}p1" ]; then
    DRIVE_ESP="${DRIVE}p1"
    DRIVE_ROOT="${DRIVE}p2"
else
    echo "Failed to parse partitions. Sorry for the mess..."
    exit 1
fi

sp "Configuring disk encryption"
echo -e "${DISK_PASSWD}" | cryptsetup luksFormat "${DRIVE_ROOT}"
echo -e "${DISK_PASSWD}" | cryptsetup open "${DRIVE_ROOT}" root
load --title "Creating ext4 filesystem" -- mkfs.ext4 /dev/mapper/root

sp "Creating EFI partition"
load --title "Creating FAT32 filesystem" -- mkfs.fat -F 32 ${DRIVE_ESP}

sp "Mounting filesystems"
mount /dev/mapper/root /mnt
mount --mkdir ${DRIVE_ESP} /mnt/efi

sp "Configuring swap"
mkswap -U clear --size 4G --file /mnt/swapfile
swapon /mnt/swapfile

ssp "Installing all packages"
pacstrap -K /mnt ${=SELECTED_PACKAGES}

# perform chrooted operations

ssp "Performing chrooted operations"
cat << EOF | arch-chroot /mnt
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "${HOSTNAME}" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 localhost.localdomain ${HOSTNAME}" >> /etc/hosts
groupadd -g 27 sudo
useradd -m -s ${USR_SHELL} -G sudo ${USRNAME}
systemctl enable dhcpcd.service
systemctl enable systemd-boot-update.service
mkdir -p /etc/pacman.conf.d
touch /etc/pacman.conf.d/dummy.conf
sed -i "s/\[options\]/\[options\]\\nInclude \= \/etc\/pacman.conf.d\/\*.conf/" /etc/pacman.conf
sed -i "s/#Color.*/Color/" /etc/pacman.conf
sed -i "s/#ParallelDownloads.*/ParallelDownloads = 5/" /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
sed -i "s/#MAKEFLAGS.*/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf
echo "%sudo ALL=(ALL) ALL" >> /etc/sudoers.d/10-${USRNAME}-chezmoi
echo "HOOKS=(${MKINITCPIO_HOOKS})" >> /etc/mkinitcpio.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "${KERNEL_PARAMS}" > /etc/kernel/cmdline
echo 'default_uki="/efi/EFI/Linux/arch-${KERNEL_NAME}.efi"' >> /etc/mkinitcpio.d/${KERNEL_NAME}.preset
echo 'fallback_uki="/efi/EFI/Linux/arch-${KERNEL_NAME}-fallback.efi"' >> /etc/mkinitcpio.d/${KERNEL_NAME}.preset
echo 'fallback_options="-S autodetect --no-cmdline"' >> /etc/mkinitcpio.d/${KERNEL_NAME}.preset
mkdir -p /efi/EFI/Linux
bootctl install
mkinitcpio -P
echo root:${ROOT_PASSWD} | chpasswd
echo ${USRNAME}:${USER_PASSWD} | chpasswd
pacman -Syu --noconfirm
echo > /home/${USRNAME}/.zshrc
chown ${USRNAME}:${USRNAME} /home/${USRNAME}/.zshrc
EOF
ssp "Finished chrooted operations"

# enable iwd
if [ ! -z $(echo ${SELECTED_PACKAGES} | grep iwd) ]; then
    sp "Setting up iwd"
    mkdir -p /mnt/var/lib/iwd
    cp -r /var/lib/iwd/* /mnt/var/lib/iwd
cat << EOF | arch-chroot /mnt
systemctl enable iwd.service
EOF
fi

# add self-destructing chezmoi install script
ssp "Adding finishing touches"
if [ ! -z "${CHEZMOI_URL}" ]; then
    ZSHRC="/mnt/home/${USRNAME}/.zshrc"
    sp "Adding Chezmoi init"
    echo "rm ~/.zshrc" >> "${ZSHRC}"
    echo "chezmoi init ${CHEZMOI_URL} --apply" >> "${ZSHRC}"
fi

sync
sp "Drives synced"

sp "Unmounting all the things"
swapoff /mnt/swapfile
umount -R /mnt
cryptsetup close root
ssp "Installation complete."
exit 0
