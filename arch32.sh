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

# Copy script/arch32.sh to script/arch32_2.sh
# In script/arch32_2.sh remove everything before, and including 'arch-chroot /mnt'
# In script/arch32.sh remove everything after 'arch-chroot /mnt', leaving only "... exit umount and reboot..."

# chmod +x arch32_2.sh

# chmod +x script/arch32.sh
# ./script/arch32.sh

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
cp script/arch32_2.sh /mnt
# swapon /dev/...

# Install base packages
# pacstrap /mnt base base-devel linux linux-lts linux-headers linux-lts-headers \
#  linux-firmware intel-ucode vi nano grep

pacstrap /mnt base linux-lts linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Change root
arch-chroot /mnt ./arch32_2.sh

# Set timezone
# ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

# Sync hardware clock to system time
# hwclock --systohc

# Set locale
# Uncomment en_US.UTF-8 in /etc/locale.gen
# locale-gen
# echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set persistent keymap
# echo "KEYMAP=sv-latin1" >> /etc/vconsole.conf

# Set hostname
# Add arch32 in /etc/hostname

# Set hosts
# Update /etc/hosts
# 127.0.0.1 localhost
# ::1 localhost
# 127.0.1.1 arch32.localdomain arch32

# Set root password
# passwd

# Install additional packages
# pacman -S grub networkmanager wireless_tools wpa_supplicant dialog os-prober \
#  mtools dosfstools reflector git man sudo

pacman -S --noconfirm grub networkmanager wireless_tools wpa_supplicant dialog os-prober
  
# Install grub  
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Update services
systemctl enable NetworkManager

# Add user
# useradd -mG wheel ben
# passwd ben
# EDITOR=vi visudo # edit wheel group 

# Exit chroot
exit

# Unmount all
umount -a

echo
echo "Press any key to reboot..."
echo
read -n 1
reboot
