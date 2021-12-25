#!/usr/bin/env zsh

set -e

install_prefix=$INSTALL_PREFIX
if [ "$install_prefix" = "" ]; then
  install_prefix=/usr/local
fi

export PATH=$install_prefix/bin:$PATH

suffix=".tar.xz"
autoconf_pkg="autoconf-2.71"
automake_pkg="automake-1.16.5"
libtool_pkg="libtool-2.4.6"
bison_pkg="bison-3.8.2"
gettext_pkg="gettext-0.21"

SDKROOT=`xcrun --sdk macosx --show-sdk-path`
CFLAGS="-arch arm64 -arch x86_64 -flto=thin -fembed-bitcode -mmacosx-version-min=10.9 --sysroot=${SDKROOT}"
CXXFLAGS="${CFLAGS}"
LDFLAGS="-flto=thin -fembed-bitcode -mmacosx-version-min=10.9 --sysroot=${SDKROOT}"
CC=clang
CXX=clang++

unzip_and_build() {
  tar -xJvf $1$suffix
  pushd $1
  args=("$@")
  ./configure ${args[@]:1}
  make -j
  sudo make install
  popd
}

unzip_and_build $autoconf_pkg \
                CC=$CC CXX=$CXX \
                CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
                LDFLAGS=$LDFLAGS \
                --prefix=$install_prefix

unzip_and_build $automake_pkg \
                CC=$CC CXX=$CXX \
                CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
                LDFLAGS=$LDFLAGS \
                --prefix=$install_prefix

unzip_and_build $libtool_pkg \
                CC=$CC CXX=$CXX \
                CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
                LDFLAGS=$LDFLAGS \
                --program-prefix=g \
                --enable-shared=no \
                --prefix=$install_prefix

unzip_and_build $bison_pkg \
                CC=$CC CXX=$CXX \
                CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
                LDFLAGS=$LDFLAGS \
                M4=m4 \
                --prefix=$install_prefix

unzip_and_build $gettext_pkg \
                CC=$CC CXX=$CXX \
                CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
                LDFLAGS=$LDFLAGS \
                --disable-java \
                --enable-shared=no \
                --prefix=$install_prefix

export LIBTOOLIZE=glibtoolize

[ -d pkg-config ] && rm -rf pkg-config
git clone --depth=1 https://gitlab.freedesktop.org/pkg-config/pkg-config.git pkg-config
pushd pkg-config
./autogen.sh --no-configure
./configure CC=$CC CXX=$CXX \
            CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS \
            LDFLAGS=$LDFLAGS \
            --with-internal-glib \
            --enable-shared=no \
            --prefix=$install_prefix
make -j
sudo make install
popd