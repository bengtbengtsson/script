# Back after reboot into the new system

# Start network
# nmcli dev wifi con Bengtsson password "password without qoutes" name homewifi
# Next time use: nmcli con up id homewifi

# Install drivers for the graphics card
pacman -S xf86-video-amdgpu

# Install the display server, and some more
pacman -S xorg
# pacman -S xorg xorg-xinit xorg-twm xorg-clock xterm
# Test with startx

# Install xfce4
pacman -S xfce4 xfce4-goodies
# Test with startxfce4

# reboot
