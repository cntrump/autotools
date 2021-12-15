#!/usr/bin/env zsh

set -e

install_prefix=/usr/local

suffix=".tar.xz"
autoconf_pkg="autoconf-2.71"
automake_pkg="automake-1.16.5"
libtool_pkg="libtool-2.4.6"
gettext_pkg="gettext-0.21"

SDKROOT=`xcrun --sdk macosx --show-sdk-path`
CFLAGS="-arch arm64 -arch x86_64 -flto=thin -fembed-bitcode -mmacosx-version-min=10.9 --sysroot=${SDKROOT}"
CXXFLAGS="${CFLAGS}"
LDFLAGS="-flto=thin -fembed-bitcode -mmacosx-version-min=10.9 --sysroot=${SDKROOT}"
CC=clang
CXX=clang++

decompress_pkg() {
  tar -xJvf $1$suffix
}

make_install() {
  make -j
  sudo make install
}

decompress_pkg $autoconf_pkg
pushd $autoconf_pkg
./configure CC=$CC CXX=$CXX \
            CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
            LDFLAGS=$LDFLAGS \
            --prefix=$install_prefix
make_install
popd

decompress_pkg $automake_pkg
pushd $automake_pkg
./configure CC=$CC CXX=$CXX \
            CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
            LDFLAGS=$LDFLAGS \
            --prefix=$install_prefix
make_install
popd

decompress_pkg $libtool_pkg
pushd $libtool_pkg
./configure CC=$CC CXX=$CXX \
            CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
            LDFLAGS=$LDFLAGS \
            --program-prefix=g \
            --enable-shared=no \
            --prefix=$install_prefix
make_install
popd

decompress_pkg $gettext_pkg
pushd $gettext_pkg
./configure CC=$CC CXX=$CXX \
            CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
            LDFLAGS=$LDFLAGS \
            --enable-shared=no \
            --prefix=$install_prefix
make_install
popd
