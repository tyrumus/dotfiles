#!/usr/bin/zsh

### EDIT THESE AS NEEDED
DRIVE="/dev/sda"
USRNAME="urmum"
HOSTNAME="smokedcheese"
TIMEZONE="Europe/Zurich"
PACKAGES="base efibootmgr linux-lts linux-firmware chezmoi dhcpcd git sudo wget zsh"
LAPTOP_PACKAGES="iwd"
NVIDIA_PACKAGES="nvidia-lts"
CHEZMOI_URL="https://github.com/you/your-dotfiles.git"



# calculated variables
# partitions
DRIVE_ESP="${DRIVE}1"
DRIVE_SWAP="${DRIVE}2"
DRIVE_ROOT="${DRIVE}3"

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
echo "Color" >> /etc/pacman.conf
echo "ParallelDownloads = 5" >> /etc/pacman.conf
echo "MAKEFLAGS=\"-j$(nproc)\"" >> /etc/makepkg.conf
echo "%sudo ALL=(ALL) ALL" >> /etc/sudoers.d/10-${USRNAME}-chezmoi
mkinitcpio -P
efibootmgr -c -g -d ${DRIVE} -p 1 -L "Arch Linux" -l /vmlinuz-linux-lts -u "root=PARTUUID=$(blkid -o value -s PARTUUID ${DRIVE_ROOT}) rw quiet initrd=/initramfs-linux-lts.img"
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

echo "==> Installation complete."
echo "==> Configure static IP address stuff now, if you want it."
echo "==> Finish installation by running the following:"
echo "arch-chroot /mnt"
echo "passwd"
echo "passwd ${USRNAME}"
echo "exit"
echo "reboot"
