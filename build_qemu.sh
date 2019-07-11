#!/bin/bash -e

PFX=$HOME/work_qemu/output
cd $HOME/work_qemu

############################# START QEMU #################################
#git clone https://github.com/mit-pdos/6.828-qemu.git qemu

cd qemu

#1st try
#./configure --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" 
#ERROR: pkg-config binary 'pkg-config' not found
#remedy -> brew install pkg-config

#2nd try
#./configure --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" 
#ERROR: glib-2.12 gthread-2.0 is required to compile QEMU
#remedy -> brew install glib

#3rd try
#./configure --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" 
#ERROR: pixman >= 0.21.8 not present
#remedy -> brew install pixman

#4th try
#./configure --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" 
#configure PASS

#5th try
#make
make install

############################# END QEMU #################################