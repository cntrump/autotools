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

build() {
  tar -xJvf $1$suffix
  pushd $1
  args=("$@")
  ./configure ${args[@]:1}
  make -j
  sudo make install
  popd
}

build $autoconf_pkg \
        CC=$CC CXX=$CXX \
        CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
        LDFLAGS=$LDFLAGS \
        --prefix=$install_prefix

build $automake_pkg \
        CC=$CC CXX=$CXX \
        CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
        LDFLAGS=$LDFLAGS \
        --prefix=$install_prefix

build $libtool_pkg \
        CC=$CC CXX=$CXX \
        CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
        LDFLAGS=$LDFLAGS \
        --program-prefix=g \
        --enable-shared=no \
        --prefix=$install_prefix

build $gettext_pkg \
        CC=$CC CXX=$CXX \
        CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
        LDFLAGS=$LDFLAGS \
        --enable-shared=no \
        --prefix=$install_prefix
