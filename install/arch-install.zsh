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
CHEZMOI_URL="https://github.com/legostax/dotfiles"


# prompt for passwords beforehand
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

echo "==> Starting unattended install..."

timedatectl set-ntp true

mkfs.ext4 ${DRIVE_ROOT}
mkswap ${DRIVE_SWAP}
mkfs.fat -F 32 ${DRIVE_ESP}

mount ${DRIVE_ROOT} /mnt
mkdir -p /mnt/boot
mount ${DRIVE_ESP} /mnt/boot
swapon ${DRIVE_SWAP}

# check if this is a laptop (has battery present)
if [ ! -z "$(ls -a /sys/class/power_supply)" ]; then
    PACKAGES="${PACKAGES} ${LAPTOP_PACKAGES}"
    # copy network configs
    mkdir -p /mnt/var/lib/iwd
    cp -r /var/lib/iwd/* /mnt/var/lib/iwd
fi

# check if this machine has an NVIDIA device
if [ ! -z "$(lspci | grep -i nvidia)" ]; then
    PACKAGES="${PACKAGES} ${NVIDIA_PACKAGES}"
fi

pacstrap /mnt ${=PACKAGES}

genfstab -U /mnt >> /mnt/etc/fstab

# perform chrooted operations
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
EOF

# perform laptop chrooted operations
cat << EOF | arch-chroot /mnt
systemctl enable iwd.service
EOF

# add self-destructing chezmoi install script
cat >>/mnt/home/${USRNAME}/.zshrc <<EOL
rm \$0
chezmoi init ${CHEZMOI_URL}
chezmoi apply
EOL

echo "==> Syncing drives..."
sync
echo "==> Drives synced."

umount -R /mnt
swapoff ${DRIVE_SWAP}
echo "==> Installation complete."
