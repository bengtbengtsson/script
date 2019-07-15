#!/bin/bash
set -e

#Bengt Bengtsson 2019-JUL-11

#General instructions
#Instructions on how to set up development environment for MIT 6.828 course
#Tested on OSX 10.13.6 (macOS High Sierra) and Debian 10

#define project directory
PROJECT="$HOME"/6.828
if [ ! -d "$PROJECT" ]; then
	echo
  echo "No project directory defined, exiting"
  echo
  exit 1
fi

#used by ./configure, path to tools install (bin, lib etc)
PFX="$PROJECT"/tools
LD_LIBRARY_PATH="$PFX/lib"
COMPILER=""
PYTHON2="python"
PATCH_QEMU=false

#path to archived source files 
STORE="$PROJECT"/store

#path to build directory
BUILD="$PROJECT"/build

function create_directories {
  if [ ! -d "$STORE" ]; then
    mkdir "$STORE"
  fi

  if [ -d "$BUILD" ]; then
    rm -rf "$BUILD"
  fi
  mkdir "$BUILD"

  if [ ! -d "$PFX" ]; then
    mkdir "$PFX"
  fi  
}

function prepare_osx {
  #Install homebrew
  #Remove all programs installed by brew (if needed)
  #brew remove --force --ignore-dependencies $(brew list) 
  brew install pkg-config
  brew install glib
  brew install pixman
  brew install gcc@4.9
  brew install wget
  brew install python@2
  brew install python
  COMPILER="--CC=/usr/local/bin/gcc-4.9"
  PYTHON2="/usr/local/bin/python2"
}

function install_guest_additions {
  #Install Virtual Box Guest Additions
  sudo apt-get update 
  sudo apt-get upgrade -y
  sudo apt-get install build-essential module-assistant -y
  sudo m-a prepare -y
  sudo sh /media/cdrom/VBoxLinuxAdditions.run
  sudo shutdown -r now
}

function prepare_debian_10 {
  sudo apt install libsdl1.2-dev libtool-bin libglib2.0-dev libz-dev \
    libpixman-1-dev wget gcc-multilib gdb -y

  PATCH_QEMU=true  
}

function build_gmp {
  echo
  echo
  echo "* * * * * * * * * * Building GMP * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM="gmp-5.0.2"
  PGM_SRC="gmp-5.0.2.tar.bz2"
  PGM_GET="ftp://ftp.gmplib.org/pub/gmp-5.0.2/gmp-5.0.2.tar.bz2"

  if [ ! -f "$STORE/$PGM_SRC" ]; then
    wget -P "$STORE" "$PGM_GET"
  fi

  if [  -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  tar xjf "$STORE/$PGM_SRC" -C "$BUILD"
  cd "$BUILD/$PGM"
  ./configure --prefix=$PFX
  make
  make check
  make install

  rm -rf "$BUILD/$PGM"
}

function build_mpfr {
  echo
  echo
  echo "* * * * * * * * * * Building MPFR * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM="mpfr-3.1.2"
  PGM_SRC="mpfr-3.1.2.tar.bz2"
  PGM_GET="https://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.bz2"

  if [ ! -f "$STORE/$PGM_SRC" ]; then
    wget -P "$STORE" "$PGM_GET"
  fi

  if [  -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  tar xjf "$STORE/$PGM_SRC" -C "$BUILD"
  cd "$BUILD/$PGM"
  ./configure --prefix=$PFX --with-gmp=$PFX
  make
  make check
  make install

  rm -rf "$BUILD/$PGM"
}

function build_mpc {
  echo
  echo
  echo "* * * * * * * * * * Building MPC * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM="mpc-0.9"
  PGM_SRC="mpc-0.9.tar.gz"
  PGM_GET="http://www.multiprecision.org/downloads/mpc-0.9.tar.gz"

  if [ ! -f "$STORE/$PGM_SRC" ]; then
    wget -P "$STORE" "$PGM_GET"
  fi

  if [  -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  tar zxf "$STORE/$PGM_SRC" -C "$BUILD"
  cd "$BUILD/$PGM"
  ./configure --prefix=$PFX --with-gmp=$PFX
  make
  make check
  make install

  rm -rf "$BUILD/$PGM"
}

function build_binutils {
  echo
  echo
  echo "* * * * * * * * * * Building BINUTILS * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM="binutils-2.21.1"
  PGM_SRC="binutils-2.21.1.tar.bz2"
  PGM_GET="http://ftpmirror.gnu.org/binutils/binutils-2.21.1.tar.bz2"

  if [ ! -f "$STORE/$PGM_SRC" ]; then
    wget -P "$STORE" "$PGM_GET"
  fi

  if [  -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  tar xjf "$STORE/$PGM_SRC" -C "$BUILD"
  cd "$BUILD/$PGM"
  ./configure --prefix=$PFX --target=i386-jos-elf --disable-werror
  make
  make install

  rm -rf "$BUILD/$PGM"
}

function build_gcc {
  echo
  echo
  echo "* * * * * * * * * * Building GCC * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM="gcc-4.6.4"
  PGM_SRC="gcc-core-4.6.4.tar.bz2"
  PGM_GET="http://ftpmirror.gnu.org/gcc/gcc-4.6.4/gcc-core-4.6.4.tar.bz2"

  if [ ! -f "$STORE/$PGM_SRC" ]; then
    wget -P "$STORE" "$PGM_GET"
  fi

  if [ -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  tar xjf "$STORE/$PGM_SRC" -C "$BUILD"
  cd "$BUILD/$PGM"
  mkdir build
  cd build
  
  ../configure --prefix=$PFX \
    --target=i386-jos-elf --disable-werror \
    --disable-libssp --disable-libmudflap --with-newlib \
    --without-headers --enable-languages=c \
    --with-gmp=$PFX --with-mpfr=$PFX --with-mpc=$PFX \
    MAKEINFO=missing $COMPILER
      
  make all-gcc
  make install-gcc
  make all-target-libgcc
  make install-target-libgcc

  rm -rf "$BUILD/$PGM"
}

function build_gdb {
  echo
  echo
  echo "* * * * * * * * * * Building GDB * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM="gdb-7.3.1"
  PGM_SRC="gdb-7.3.1.tar.bz2"
  PGM_GET="http://ftpmirror.gnu.org/gdb/gdb-7.3.1.tar.bz2"

  if [ ! -f "$STORE/$PGM_SRC" ]; then
    wget -P "$STORE" "$PGM_GET"
  fi

  if [ -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  tar xjf "$STORE/$PGM_SRC" -C "$BUILD"
  cd "$BUILD/$PGM"

  ./configure --prefix=$PFX --target=i386-jos-elf --program-prefix=i386-jos-elf- \
    --disable-werror
  make all
  make install 

  rm -rf "$BUILD/$PGM"
}

function build_qemu {
  echo
  echo
  echo "* * * * * * * * * * Building QEMU * * * * * * * * * *"
  echo
  echo
  sleep 1

  PGM=qemu
  PGM_GET="https://github.com/mit-pdos/6.828-qemu.git"

  cd $STORE
  git clone $PGM_GET $PGM
  
  if [ ! -d "$STORE/$PGM" ]; then
    echo "No $STORE/$PGM created. Aborting"
    exit 1
  fi

  if [ -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi


  cp -r "$STORE/$PGM" "$BUILD"
  
  if $PATCH_QEMU
  then
    echo "STARTING PATCH"
    cd "$BUILD"
    PATCH_DATA='diff -ruN qemu/qga/commands-posix.c qemu-mod/qga/commands-posix.c
    --- qemu/qga/commands-posix.c	2019-07-15 07:29:50.001000000 +0200
    +++ qemu-mod/qga/commands-posix.c	2019-07-15 07:32:20.361000000 +0200
    @@ -28,6 +28,7 @@\n #include "qapi/qmp/qerror.h"
     #include "qemu/queue.h"
     #include "qemu/host-utils.h"
    +#include <sys/sysmacros.h>
     
     #ifndef CONFIG_HAS_ENVIRON
     #ifdef __APPLE__'
    
    echo -e "$PATCH_DATA" > myPatch
    patch -p0 < myPatch
    rm myPatch
  fi
  
  cd "$BUILD/$PGM"
  ./configure --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" \
    --python=$PYTHON2 $COMPILER
  make
  make install

  rm -rf "$BUILD/$PGM"
}

function setup_git {
  #Generate new key
  ssh-keygen -t rsa -b 4096 -C bengt.bengtsson@gmail.com
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  #Update github with the new key
  #Copy content from ~/.ssh/id_rsa.pub
  #Update with the new key at github settings
  git config --global user.email bengt.bengtsson@gmail.com
  git config --global user.name "Bengt Bengtsson"
}

function clone_repos {
  if [ ! -d "$PROJECT/jos" ]; then
    cd $PROJECT
    git clone https://github.com/bengtbengtsson/mit-2018.git jos
    cd $PROJECT/jos
    git remote rename origin private
    git remote add origin https://pdos.csail.mit.edu/6.828/2018/jos.git
  fi
  

  if [ ! -d "$PROJECT/xv6" ]; then
    cd $PROJECT
    git clone git://github.com/mit-pdos/xv6-public.git xv6
  fi
}

function create_setup {
 cd $PROJECT
 echo "export PATH=$PROJECT/tools/bin:$PATH" > setup.sh
 chmod +x setup.sh
}

echo
echo
echo "* * * * * * * * * * Building all tools needed for 6.828 * * * * * * * * * *"
echo
echo
sleep 1

#Uncomment below to install software etc
#install_guest_additions
#prepare_debian_10
#prepare_osx
#create_directories
#build_gmp
#build_mpfr
#build_mpc
#build_binutils
#build_gcc
#build_gdb
#build_qemu
#setup_git
#clone_repos
#create_setup

#Test the tools
#export PATH=$PFX/bin:$PATH
#cd $PROJECT/$JOS
#make V=1
#make clean
#make qemu-noxdiff -ruN qemu/qga/commands-posix.c qemu-mod/qga/commands-posix.c
