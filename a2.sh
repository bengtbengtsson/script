# Set timezone
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

# Sync hardware clock to system time
hwclock --systohc

# Set locale
# Uncomment en_US.UTF-8 in /etc/locale.gen
sed -i '/#en_US.UTF-8.*/c\en_US.UTF-8 UTF-8' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set persistent keymap
echo "KEYMAP=sv-latin1" >> /etc/vconsole.conf

# Set hostname
echo "arch32" >> /etc/hostname

# Set hosts
# Update /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 arch32.localdomain arch32" >> /etc/hosts

# Install additional packages
pacman -S --noconfirm grub networkmanager wireless_tools wpa_supplicant dialog os-prober \
  mtools dosfstools reflector git man sudo bluez bluez-utils pulseaudio pulseaudio-bluetooth cups
  
# Update /etc/mkinitcpio.conf
sed -i '/^HOOKS.*/c\HOOKS=(base systemd udev autodetect modconf block filesystems keyboard sd-vconsole fsck)' /etc/mkinitcpio.conf
mkinitcpio -p linux-lts
  
# Install grub  
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Update services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable org.cups.cupsd

# Set root password
echo -e "updateme\nupdateme" | passwd

# Add user
useradd -mG wheel ben
echo -e "updateme\nupdateme" | passwd ben

# EDITOR=vi visudo # edit wheel group 
echo "%wheel ALL=(ALL) ALL" | sudo EDITOR="tee -a" visudo

# Exit chroot
exit
