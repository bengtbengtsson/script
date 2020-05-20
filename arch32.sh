# Script to install Arch 32 bit version on Intel PC
# Tested on Sony VAIO ...

# Set KEYMAP, not persistent
# loadkeys sv-latin1

# Activate wifi
# wifi-menu

# Set ntp
timedatectl set-ntp true

# Sync repos
pacman -Syyy

# Install reflector
pacman -S reflector
reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy

# Partition drive/s
# 512M boot, 8GB swap, rest /

# Format drives
# mkfs.ext2 /dev/...
# mkfs.ext4 /dev/...
# mkswap /dev/...

# Mount drives
# mount /dev/... /mnt
# mkdir /mnt/boot
# mount /dev/... /mnt/boot
# swapon /dev/...

# Install base packages
pacstrap /mnt base base-devel linux linux-lts linux-headers linux-lts-headers \
  linux-firmware intel-ucode vi nano grep

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Change root
arch-chroot /mnt

# Set timezone
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

# Sync hardware clock to system time
hwclock --systohc

# Set locale
# Uncomment en_US.UTF-8 in /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set persistent keymap
echo "KEYMAP=sv-latin1" >> /etc/vconsole.conf

# Set hostname
# Add arch32 in /etc/hostname

# Set hosts
# Update /etc/hosts
# 127.0.0.1 localhost
# ::1 localhost
# 127.0.1.1. arch32.localdomain arch32

# Set root password
# passwd

# Install additional packages
pacman -S grub networkmanager wireless_tools wpa_supplicant dialog os-prober \
  mtools dosfstools reflector git man
  
# Install grub  
grub-install /dev/...  
grub-mkconfig -o /boot/grub/grub.cfg

# Update services
systemctl enable NetworkManager

# Add user
useradd -mG wheel ben
passwd ben
EDITOR=vi visudo # edit wheel group 
