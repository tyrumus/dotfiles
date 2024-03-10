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

# prompt for hostname
ssp "Enter hostname"
HOSTNAME=$(gum input --placeholder "Hostname")
clear

# prompt for timezone
ssp "Enter timezone"
TIMEZONE=$(gum input --value "Europe/Zurich")
clear

function display_drives() {
    sp "Boot drive           -> $1"
    sp "EFI system partition -> $2"
    sp "Swap space partition -> $3"
    sp "Root partition       -> $4"
}

# prompt for drive info
display_drives
ssp "Select device for boot drive. Cannot be a partition, and must be the device that has the EFI partition on it"
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE="/dev/${DATA}"
clear

display_drives ${DRIVE}
ssp "Select device or partition for EFI system partition. Must be the same storage device as selected for boot drive."
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE_ESP="/dev/${DATA}"
clear

display_drives ${DRIVE} ${DRIVE_ESP}
ssp "Select device or partition for swap space"
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE_SWAP="/dev/${DATA}"
clear

display_drives ${DRIVE} ${DRIVE_ESP} ${DRIVE_SWAP}
ssp "Select device or partition for root filesystem"
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE_ROOT="/dev/${DATA}"
clear

# prompt for chezmoi URL
ssp "Enter URL for chezmoi repository. Press ESC to not deploy."
CHEZMOI_URL=$(gum input --value "https://github.com/tyrumus/dotfiles")
clear

# prompt for chassis type
ssp "Select chassis type"
CHASSIS_TYPE=$(gum choose {desktop,laptop,convertible,server,tablet,handset,watch,embedded,vm,container})
hostnamectl chassis "${CHASSIS_TYPE}"
clear

POTENTIAL_PACKAGES="base base-devel efibootmgr linux linux-firmware chezmoi dhcpcd git sudo wget zsh"
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

ssp --underline "Installation preferences"
sp "sudoer account       -> ${USRNAME}"
sp "Hostname             -> ${HOSTNAME}"
sp "Timezone             -> ${TIMEZONE}"
display_drives ${DRIVE} ${DRIVE_ESP} ${DRIVE_SWAP} ${DRIVE_ROOT}
if [ ! -z "${CHEZMOI_URL}" ]; then
    sp "Chezmoi URL          -> ${CHEZMOI_URL}"
else
    sp "Chezmoi URL          -> Not deploying"
fi
sp "Chassis type:        -> ${CHASSIS_TYPE}"
sp "Packages             -> ${PRETTY_SELECTED_PACKAGES}"
gum confirm "Proceed with install?" --selected.background=45 --selected.foreground=0

ssp "Starting unattended install..."

sp "Enabling NTP"
timedatectl set-ntp true

sp "Creating filesystems"
load --title "Creating ext4 filesystem" -- mkfs.ext4 ${DRIVE_ROOT}
load --title "Creating swap space" -- mkswap ${DRIVE_SWAP}
load --title "Creating FAT32 filesystem" -- mkfs.fat -F 32 ${DRIVE_ESP}

sp "Mounting filesystems"
mount ${DRIVE_ROOT} /mnt
mkdir -p /mnt/boot
mount ${DRIVE_ESP} /mnt/boot
swapon ${DRIVE_SWAP}

ssp "Installing all packages"
pacstrap -K /mnt ${=SELECTED_PACKAGES}

ssp "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# perform chrooted operations
### NOTE: may need to add '-e 3' to the efibootmgr command if the motherboard deletes the boot entry on reboot

KERNEL_NAME=linux
if [[ "${SELECTED_PACKAGES}" == *"linux-lts"* ]]; then
    KERNEL_NAME=linux-lts
fi

ssp "Performing chrooted operations"
cat << EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "${HOSTNAME}" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 localhost.localdomain ${HOSTNAME}" >> /etc/hosts
groupadd sudo
useradd -m -s /usr/bin/zsh -G sudo ${USRNAME}
systemctl enable dhcpcd.service
sed -i "s/#Color.*/Color/" /etc/pacman.conf
sed -i "s/#ParallelDownloads.*/ParallelDownloads = 5/" /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
sed -i "s/#MAKEFLAGS.*/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf
echo "%sudo ALL=(ALL) ALL" >> /etc/sudoers.d/10-${USRNAME}-chezmoi
mkinitcpio -P
efibootmgr -c -g -d ${DRIVE} -p 1 -L "Arch Linux" -l /vmlinuz-${KERNEL_NAME} -u "root=PARTUUID=$(blkid -o value -s PARTUUID ${DRIVE_ROOT}) rw quiet i915.force_probe=56a0 initrd=/initramfs-${KERNEL_NAME}.img"
echo root:${ROOT_PASSWD} | chpasswd
echo ${USRNAME}:${USER_PASSWD} | chpasswd
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
    sp "Adding Chezmoi init"
cat >>/mnt/home/${USRNAME}/.zshrc <<EOL
rm \$0
chezmoi init ${CHEZMOI_URL} --apply
EOL
fi

load --title "Syncing drives" -- sync
sp "Drives synced"

sp "Unmounting all the things"
umount -R /mnt
swapoff ${DRIVE_SWAP}
ssp "Installation complete."
exit 0
