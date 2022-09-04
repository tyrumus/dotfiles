#!/usr/bin/zsh

### EDIT THESE AS NEEDED
DRIVE="/dev/sda"
DRIVE_ESP="${DRIVE}1"
DRIVE_SWAP="${DRIVE}2"
DRIVE_ROOT="${DRIVE}3"
USRNAME="urmum"
HOSTNAME="smokedcheese"
TIMEZONE="Europe/Zurich"
PACKAGES="base base-devel efibootmgr linux-lts linux-firmware chezmoi dhcpcd git sudo wget zsh"
LAPTOP_PACKAGES="iwd"
NVIDIA_PACKAGES="nvidia-lts nvidia-settings"
CHEZMOI_URL="https://github.com/tyrumus/dotfiles"


### SPECIAL PRINT FUNCTIONS ###
ssp() {
    echo -en "\033[1m"
    echo -en "\033[32m"
    echo -n "==> "
    echo -en "\033[39m"
    echo -en "INSTALL: ${1}"
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
sps() {
    echo -en "\033[1m"
    echo -en "\033[34m"
    echo -n "  -> "
    echo -en "\033[39m"
    echo -en "$1"
}
spe() {
    echo -en "$1"
    echo -e "\033[0m"
}

ssp "Verifying all the things..."
# verify boot mode (is it UEFI?)
sps "Verifying boot mode: "
ls /sys/firmware/efi/efivars &> /dev/null
if [[ $? = 0 ]]; then
    spe "SUCCESS"
else
    spe "FAIL: UEFI boot not detected. Continuing install."
fi

# check for functioning internet connection
# probably pointless, since this script is intended to be downloaded from the internet
sps "Checking internet connection: "
ping -c 1 archlinux.org &> /dev/null
if [[ $? = 0 ]]; then
    spe "SUCCESS"
else
    spe "FAIL: Unable to connect to archlinux.org"
    exit 1
fi

# prompt for passwords beforehand
ssp "Please answer the following prompts for unattended installation"
ROOT_PASSWD=""
ROOT_PASSWD_CONF="a"
while [ ! "${ROOT_PASSWD}" = "${ROOT_PASSWD_CONF}" ]; do
    echo -n "Enter the password for root: "
    read -rs ROOT_PASSWD </dev/tty
    echo

    echo -n "Confirm root password: "
    read -rs ROOT_PASSWD_CONF </dev/tty
    echo
done

USER_PASSWD=""
USER_PASSWD_CONF="a"
while [ ! "${USER_PASSWD}" = "${USER_PASSWD_CONF}" ]; do
    echo -n "Enter the password for ${USRNAME}: "
    read -rs USER_PASSWD </dev/tty
    echo

    echo -n "Confirm ${USRNAME} password: "
    read -rs USER_PASSWD_CONF </dev/tty
    echo
done

# prompt for chassis type
SUCCESS=1
echo "the following chassis types are defined: \"desktop\", \"laptop\", \"convertible\", \"server\", \"tablet\", \"handset\", \"watch\", \"embedded\", as well as the special chassis types \"vm\" and \"container\""
while [ ! $SUCCESS = 0 ]; do
    echo -n "Enter the chassis type: "
    read -r CHASSIS_TYPE </dev/tty

    if [[ ! "${CHASSIS_TYPE}" = "" ]]; then
        hostnamectl chassis "${CHASSIS_TYPE}"

        if [[ $? = 0 ]]; then
            SUCCESS=0
        fi
    fi
done

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
