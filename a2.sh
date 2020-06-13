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

# Install drivers for the graphics card
pacman -S --noconfirm xf86-video-amdgpu

# Install the display server, and some more
# pacman -S --noconfirm xorg
# pacman -S xorg xorg-xinit xorg-twm xorg-clock xterm
# Test with startx
# Install xfce4
# pacman -S --noconfirm xfce4 xfce4-goodies
# Test with startxfce4

# Install dwm
pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xsetroot chromium nitrogen picom
cp /etc/X11/xinit/xinitrc /home/ben/.xinitrc
sed '51,55d' /home/ben/.xinitrc
 echo "setxkbmap se &" >> /home/ben/.xinitrc
 echo "xrandr --output Virtual-1 --mode 1600x900 &" >> /home/ben/.xinitrc
 echo "picom -f &" >> /home/ben/.xinitrc
 echo "exec dwm" >> /home/ben/.xinitrc
 

# Exit chroot
exit

# Back after reboot into the new system

# Start network
# nmcli dev wifi con Bengtsson password "password without qoutes" name homewifi
# Next time use: nmcli con up id homewifi
