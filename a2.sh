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
