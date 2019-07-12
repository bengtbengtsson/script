#!/bin/bash -e

#OS X 'gcc' can't compile the gcc we need below
#uncomment below if homebrew's gcc48 not installed
#brew uninstall gcc@4.9 --force
#brew install gcc@4.9
#brew install wget

#used by ./configure
PFX=/Users/ben/6.828/tools
export LD_LIBRARY_PATH=$PFX/lib:$LD_LIBRARY_PATH
#this is where the binaries etc go
TOOLS_DIR="$PFX"

#this is where the source archives live
STORAGE_DIR=$PFX/../storage

#a temporary build-directory
BUILD_DIR=$PFX/../build_dir

echo "Building all tools needed for 6.828"
sleep 1

if false; then

if [ ! -d "$STORAGE_DIR" ]; then
	mkdir "$STORAGE_DIR"
fi

if [  -d "$BUILD_DIR" ]; then
	rm -rf "$BUILD_DIR"
fi
mkdir "$BUILD_DIR"

#if [  -d "$TOOLS_DIR" ]; then
#	rm -rf "$TOOLS_DIR"
# fi
#mkdir "$TOOLS_DIR"




############################# START GMP #################################
GMP_SRC=gmp-6.1.0.tar.bz2
GMP_DIR=gmp-6.1.0

echo "* * * * * Building $GMP_DIR * * * * *"
sleep 1

if [ ! -f "$STORAGE_DIR/$GMP_SRC" ]; then
	wget -P "$STORAGE_DIR" http://ftp.acc.umu.se/mirror/gnu.org/gnu/gmp/gmp-6.1.0.tar.bz2	
fi

if [  -d "$BUILD_DIR/$GMP_DIR" ]; then
	rm -rf "$BUILD_DIR/$GMP_DIR"
fi

tar xjf "$STORAGE_DIR/$GMP_SRC" -C "$BUILD_DIR"
cd "$BUILD_DIR/$GMP_DIR"
./configure --prefix=$PFX
make
make check
make install

rm -rf "$BUILD_DIR/$GMP_DIR"

############################# END GMP #################################


############################# START MPFR #################################
MPFR_SRC=mpfr-3.1.3.tar.bz2
MPFR_DIR=mpfr-3.1.3

echo "* * * * * Building $MPFR_DIR * * * * *"
sleep 1

if [ ! -f "$STORAGE_DIR/$MPFR_SRC" ]; then
	wget -P "$STORAGE_DIR" http://mpfr.loria.fr/mpfr-3.1.3/mpfr-3.1.3.tar.bz2	
fi

if [  -d "$BUILD_DIR/$MPFR_DIR" ]; then
	rm -rf "$BUILD_DIR/$MPFR_DIR"
fi

tar xjf "$STORAGE_DIR/$MPFR_SRC" -C "$BUILD_DIR"
cd "$BUILD_DIR/$MPFR_DIR"
./configure --prefix=$PFX --with-gmp=$PFX
make
make install

rm -rf "$BUILD_DIR/$MPFR_DIR"

############################# END MPFR #################################




############################# START MPC #################################
MPC_SRC=mpc-0.9.tar.gz
MPC_DIR=mpc-0.9

echo "* * * * * Building $MPC_DIR * * * * *"
sleep 1

if [ ! -f "$STORAGE_DIR/$MPC_SRC" ]; then
#       wget -P "$STORAGE_DIR" http://www.multiprecision.org/mpc/download/mpc-0.9.tar.gz	
	wget -P "$STORAGE_DIR" http://www.multiprecision.org/downloads/mpc-0.9.tar.gz	
fi

if [  -d "$BUILD_DIR/$MPC_DIR" ]; then
	rm -rf "$BUILD_DIR/$MPC_DIR"
fi

tar xzf "$STORAGE_DIR/$MPC_SRC" -C "$BUILD_DIR"
cd "$BUILD_DIR/$MPC_DIR"
./configure --prefix=$PFX --with-gmp=$PFX
make
make install

rm -rf "$BUILD_DIR/$MPC_DIR"

############################# END MPC #################################



############################# START BINUTILS #################################
BINUTILS_SRC=binutils-2.21.1.tar.bz2
BINUTILS_DIR=binutils-2.21.1

echo "* * * * * Building $BINUTILS_DIR * * * * *"
sleep 1

if [ ! -f "$STORAGE_DIR/$BINUTILS_SRC" ]; then
	wget -P "$STORAGE_DIR" http://ftpmirror.gnu.org/binutils/binutils-2.21.1.tar.bz2	
fi

if [  -d "$BUILD_DIR/$BINUTILS_DIR" ]; then
	rm -rf "$BUILD_DIR/$BINUTILS_DIR"
fi

tar xjf "$STORAGE_DIR/$BINUTILS_SRC" -C "$BUILD_DIR"
cd "$BUILD_DIR/$BINUTILS_DIR"
./configure --prefix=$PFX --target=i386-jos-elf --disable-werror
make
make install

rm -rf "$BUILD_DIR/$BINUTILS_DIR"

############################# END BINUTILS #################################


############################# START GCC #################################
GCC_SRC=gcc-4.8.0.tar.bz2
GCC_DIR=gcc-4.8.0

echo "* * * * * Building $GCC_DIR * * * * *"
sleep 1

if [ ! -f "$STORAGE_DIR/$GCC_SRC" ]; then
	wget -P "$STORAGE_DIR" ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-4.8.0/gcc-4.8.0.tar.bz2	
fi

if [  -d "$BUILD_DIR/$GCC_DIR" ]; then
	rm -rf "$BUILD_DIR/$GCC_DIR"
fi

tar xjf "$STORAGE_DIR/$GCC_SRC" -C "$BUILD_DIR"
cd "$BUILD_DIR/$GCC_DIR"
mkdir build
cd build
../configure --prefix=$PFX \
    --target=i386-jos-elf --disable-werror \
    --disable-libssp --disable-libmudflap --with-newlib \
    --without-headers --enable-languages=c \
    --with-gmp=$PFX --with-mpfr=$PFX --with-mpc=$PFX \
    CC=/usr/local/bin/gcc-4.9
#     CC=gcc
make all-gcc
make install-gcc
make all-target-libgcc
make install-target-libgcc

rm -rf "$BUILD_DIR/$GCC_DIR"

############################# END GCC #################################

 
############################# START GDB #################################
GDB_SRC=gdb-7.3.1.tar.bz2
GDB_DIR=gdb-7.3.1

echo "* * * * * Building $GDB_DIR * * * * *"
sleep 1

if [ ! -f "$STORAGE_DIR/$GDB_SRC" ]; then
	wget -P "$STORAGE_DIR" http://ftpmirror.gnu.org/gdb/gdb-7.3.1.tar.bz2
fi

if [  -d "$BUILD_DIR/$GDB_DIR" ]; then
	rm -rf "$BUILD_DIR/$GDB_DIR"
fi

tar xjf "$STORAGE_DIR/$GDB_SRC" -C "$BUILD_DIR"
cd "$BUILD_DIR/$GDB_DIR"
./configure --prefix=$PFX --target=i386-jos-elf --program-prefix=i386-jos-elf- \
    --disable-werror
make all
make install

rm -rf "$BUILD_DIR/$GDB_DIR"

############################# END GDB #################################

fi
############################# START QEMU #################################
echo "* * * * * Building QEMU * * * * *"
sleep 1

cd "$STORAGE_DIR"

#if [ ! -d "$STORAGE_DIR/qemu" ]; then
#	git clone https://github.com/geofft/qemu.git -b 6.828-1.7.0 "$STORAGE_DIR/qemu"
#fi

#if [  -d "$BUILD_DIR/qemu" ]; then
#	rm -rf "$BUILD_DIR/qemu"
#fi

#cp -r "$STORAGE_DIR/qemu" "$BUILD_DIR"
cd "$BUILD_DIR/qemu"

./configure --python=/usr/local/bin/python2 --disable-werror --disable-kvm --disable-sdl --prefix=$PFX --target-list="i386-softmmu x86_64-softmmu" 
#make
#make install

#rm -rf "$BUILD_DIR/qemu"

############################# END QEMU #################################

echo
echo "Test run of objdump"
echo
$PFX/bin/i386-jos-elf-objdump -i | head

echo
echo "Test run of gcc"
echo
$PFX/bin/i386-jos-elf-gcc -v

echo
echo
echo "* * * * * End of installation * * * * *"

