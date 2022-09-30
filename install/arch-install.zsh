#!/usr/bin/zsh
# vim: ft=zsh

### EDIT THESE AS NEEDED


### INITIAL SCRIPT SETUP ###

# check for functioning internet connection
# probably pointless, since this script is intended to be downloaded from the internet
echo -n "Checking internet connection: "
ping -c 1 archlinux.org &> /dev/null
if [[ $? = 0 ]]; then
    echo "SUCCESS"
else
    echo "FAIL: Unable to connect to archlinux.org"
    exit 1
fi

pacman -S --noconfirm gum &> /dev/null


### FUNCTIONS ###


### USER INPUT FOR OPTIONS ###

# verify boot mode (is it UEFI?)
gum style --foreground 45 --bold "Verifying boot mode..."
ls /sys/firmware/efi/efivars &> /dev/null
if [[ $? = 0 ]]; then
    gum style --foreground 2 --bold "SUCCESS"
else
    gum style --foreground 1 --bold "FAIL: UEFI boot not detected."
    exit 1
fi

echo
echo
gum style --foreground 45 --italic "Please answer the following prompts for unattended installation"

# prompt for root passwords
ROOT_PASSWD=""
ROOT_PASSWD_CONF="a"
while [ ! "${ROOT_PASSWD}" = "${ROOT_PASSWD_CONF}" ]; do
    ROOT_PASSWD=$(gum input --password --placeholder "Enter root password" --cursor.foreground 45)
    ROOT_PASSWD_CONF=$(gum input --password --placeholder "Confirm root password" --cursor.foreground 45)
done

# prompt for username
USRNAME=$(gum input --placeholder "Enter sudoer username" --cursor.foreground 45)

# prompt for user password
USER_PASSWD=""
USER_PASSWD_CONF="a"
while [ ! "${USER_PASSWD}" = "${USER_PASSWD_CONF}" ]; do
    USER_PASSWD=$(gum input --password --placeholder "Enter password for ${USRNAME}" --cursor.foreground 45)
    USER_PASSWD_CONF=$(gum input --password --placeholder "Confirm ${USRNAME} password" --cursor.foreground 45)
done

# prompt for hostname
HOSTNAME=$(gum input --placeholder "smokedcheese")

# prompt for timezone
TIMEZONE=$(gum input --value "Europe/Zurich")

# prompt for drive info
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE_ESP="/dev/${DATA}"
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE_SWAP="/dev/${DATA}"
DATA=$(gum choose $(lsblk --output name --list | grep -v NAME))
DRIVE_ROOT="/dev/${DATA}"

# prompt for chezmoi URL
CHEZMOI_URL=$(gum input --value "https://github.com/tyrumus/dotfiles")

# prompt for chassis type
SUCCESS=1
CHASSIS_TYPE=$(gum choose {desktop,laptop,convertible,server,tablet,handset,watch,embedded,vm,container})
hostnamectl chassis "${CHASSIS_TYPE}"

# TODO: prompt to edit these lists
PACKAGES="base base-devel efibootmgr linux-lts linux-firmware chezmoi dhcpcd git sudo wget zsh"
LAPTOP_PACKAGES="iwd"
NVIDIA_PACKAGES="nvidia-lts nvidia-settings"
exit 0

ssp "Starting unattended install..."

sp "Enabling NTP"
timedatectl set-ntp true

sp "Creating filesystems"
mkfs.ext4 ${DRIVE_ROOT}
mkswap ${DRIVE_SWAP}
mkfs.fat -F 32 ${DRIVE_ESP}

sp "Mounting filesystems"
mount ${DRIVE_ROOT} /mnt
mkdir -p /mnt/boot
mount ${DRIVE_ESP} /mnt/boot
swapon ${DRIVE_SWAP}

# check if this is a laptop (has battery present)
sps "Checking if this is a laptop: "
LAPTOP=1
if [ ! -z "$(ls -a /sys/class/power_supply)" ]; then
    LAPTOP=0
    spe "SUCCESS"
    PACKAGES="${PACKAGES} ${LAPTOP_PACKAGES}"

    # copy network configs
    sp "Copying network configs from installer's iwd"
    mkdir -p /mnt/var/lib/iwd
    cp -r /var/lib/iwd/* /mnt/var/lib/iwd
else
    spe "FAIL: This is not a laptop"
fi

# check if this machine has an NVIDIA device
sps "Checking if NVIDIA card is present: "
NVIDIA=1
if [ ! -z "$(lspci | grep -i nvidia)" ]; then
    NVIDIA=0
    spe "SUCCESS"
    PACKAGES="${PACKAGES} ${NVIDIA_PACKAGES}"
else
    spe "FAIL: No NVIDIA card"
fi

ssp "Installing all packages"
pacstrap /mnt ${=PACKAGES}

ssp "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# perform chrooted operations
# may need to add the following flag to the efibootmgr command if the motherboard deletes the boot entry on reboot
# -e 3
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
efibootmgr -c -g -d ${DRIVE} -p 1 -L "Arch Linux" -l /vmlinuz-linux-lts -u "root=PARTUUID=$(blkid -o value -s PARTUUID ${DRIVE_ROOT}) rw quiet initrd=/initramfs-linux-lts.img"
echo root:${ROOT_PASSWD} | chpasswd
echo ${USRNAME}:${USER_PASSWD} | chpasswd
hostnamectl chassis "${CHASSIS_TYPE}"
EOF

# perform laptop chrooted operations
if [ $LAPTOP = 0]; then
    ssp "Performing chrooted operations for laptop"
cat << EOF | arch-chroot /mnt
systemctl enable iwd.service
EOF
fi

# add self-destructing chezmoi install script
ssp "Adding finishing touches"
sp "Adding Chezmoi init"
cat >>/mnt/home/${USRNAME}/.zshrc <<EOL
rm \$0
chezmoi init ${CHEZMOI_URL}
EOL

sp "Syncing drives"
sync
sp "Drives synced"

sp "Unmounting all the things"
umount -R /mnt
swapoff ${DRIVE_SWAP}
ssp "Installation complete."
