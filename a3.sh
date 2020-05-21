# Back after reboot into the new system

# Update /etc/mkinitcpio.conf
# HOOKS=(base systemd udev udev autodetect modconf block filesystems keyboard sd-console fsck)
# mkinitcpio -p linux-lts # Not sure of this command
# Maybe all this could have been done just before grub in a2.sh ?

# Start network
# nmcli dev wifi con Bengtsson password "password without qoutes" name homewifi
# Next time use: nmcli con up id homewifi

# Install drivers for the graphics card
pacman -S xf86-video-amdgpu

# Install the display server, and some more
pacman -S xorg xorg-xinit xorg-twm xorg-clock xterm
# Test with startx

# Install xfce4
pacman -S xfce4 xfce4-goodies
# Test with startxfce4
