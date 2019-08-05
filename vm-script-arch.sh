#!/bin/bash

# stop at first error
set -e

VBoxManage createvm --name Arch-Linux-2 --ostype=ArchLinux_64 --register

VBoxManage modifyvm Arch-Linux-2 --bridgeadapter1 enp3s0
VBoxManage modifyvm Arch-Linux-2 --nic1 bridged --cableconnected1 on
#VBoxManage modifyvm Arch-Linux-2 --nic1 bridged --nictype1 82540EM --cableconnected1 on 

VBoxManage modifyvm Arch-Linux-2 --memory 4096
VBoxManage modifyvm Arch-Linux-2 --firmware efi64
VBoxManage createhd \
    --filename "/home/ben/VirtualBox VMs/Arch-Linux-2/Arch-Linux-2.vdi" --size 60000 --format VDI

VBoxManage storagectl Arch-Linux-2 --name "SATA Controller" --add sata --controller IntelAhci

VBoxManage storageattach Arch-Linux-2 --storagectl "SATA Controller" \
    --port 0 --device 0 --type hdd \
    --medium "/home/ben/VirtualBox VMs/Arch-Linux-2/Arch-Linux-2.vdi"

VBoxManage storagectl Arch-Linux-2 --name "IDE Controller" --add ide --controller PIIX4


VBoxManage storageattach Arch-Linux-2 --storagectl "IDE Controller" --port 1 --device 0 \
   --type dvddrive --medium /home/ben/arch-linux/archlinux-2019.08.01-x86_64.iso

#VBoxManage startvm Arch-Linux-2