# Script to install Arch 32 bit version on Intel PC
# Tested on Sony VAIO ...

# Set KEYMAP, not persistent
# loadkeys sv-latin1

# Activate wifi
# wifi-menu
# ip a

# Sync
# pacman -Syyy

# Install git
# pacman -S git

# Clone script
# git clone https://github.com/bengtbengtsson/script

# chmod +x script/a1.sh script/a2.sh

# ./script/a1.sh

# Set ntp
timedatectl set-ntp true

# Sync repos
pacman -Syyy

# Install reflector
pacman -S --noconfirm reflector
reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy

# Partition drive/s
# 512M boot, 8GB swap, rest /

# Format drives
mkfs.ext2 -F /dev/sda1
mkfs.ext4 -F /dev/sda2
# mkswap /dev/...

# Mount drives
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
cp script/a2.sh /mnt
# swapon /dev/...

# Install base packages
# pacstrap /mnt base base-devel linux linux-lts linux-headers linux-lts-headers \
#  linux-firmware intel-ucode vi nano grep

pacstrap /mnt base linux-lts linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Change root
arch-chroot /mnt ./a2.sh

# Unmount all
umount -a

echo
echo "Press any key to reboot..."
echo
read -n 1
reboot
