#!/bin/sh

#Bengt Bengtsson 2019-JUL-11

#General instructions
#Instructions on how to set up development environment for MIT 6.828 course
#Tested on OSX 10.13.6 (macOS High Sierra)

#SET UP OSX

#define project directory
PROJECT="$HOME"/test_project_2
if [ ! -d "$PROJECT" ]; then
	echo
  echo "No project directory defined, exiting"
  echo
  exit 1
fi

#Install homebrew
#Remove all programs installed by brew (if any)
#brew remove --force $(brew list) --ignore-dependencies
#brew install pkg-config glib pixman gcc@4.9 wget

# END OF SET UP OSX

#BUILD TOOLS

#used by ./configure, path to tools install (bin, lib etc)
PFX="$PROJECT"/tools

LD_LIBRARY_PATH="$PFX/lib"

#path to archived source files 
STORE="$PROJECT"/store

#path to build directory
BUILD="$PROJECT"/build

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

  tar xjf "$STORE/$PGM_SRC" -C "$BUILD"
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
    MAKEINFO=missing CC=/usr/local/bin/gcc-4.9
      
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

  PGM="qemu"
  PGM_GET="https://github.com/mit-pdos/6.828-qemu.git"

  if [ ! -d "$STORE/$PGM" ]; then
    git clone $PGM_GET "$STORE/$PGM"
  fi

  if [ -d "$BUILD/$PGM" ]; then
    rm -rf "$BUILD/$PGM"
  fi

  cp -r "$STORE/$PGM" "$BUILD"
  cd "$BUILD/$PGM"

  ./configure --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" 
  make
  make install

  rm -rf "$BUILD/$PGM"
}

echo
echo
echo "* * * * * * * * * * Building all tools needed for 6.828 * * * * * * * * * *"
echo
echo
sleep 1

#Uncomment below to install software
#build_gmp
#build_mpfr
#build_mpc
#build_binutils
#build_gcc
#build_gdb
#build_qemu

#Set up git


#Clone mit gits
JOS=jos
XV6=xv6

if [ ! -d "$PROJECT/$JOS" ]; then
  cd $PROJECT
  git clone https://pdos.csail.mit.edu/6.828/2018/jos.git $JOS
fi

if [ ! -d "$PROJECT/$XV6" ]; then
  cd $PROJECT
  git clone git://github.com/mit-pdos/xv6-public.git $XV6
fi
  
#Test the tools
export PATH=$PFX/bin:$PATH
cd $PROJECT/$JOS
make V=1
make clean
make qemu-nox-gdb

#WHAT ABOUT GDB? WHICH VERSION IS USED?