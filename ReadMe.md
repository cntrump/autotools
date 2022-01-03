# autotools

Build and install autotools on macOS without any package managers.

- [autoconf](https://www.gnu.org/software/autoconf/)
- [automake](https://www.gnu.org/software/automake/)
- [libtool](https://www.gnu.org/software/automake/) (by adding prefix `g`: `glibtool`)
- [gettext](https://www.gnu.org/software/gettext/)
    - depend on [bison](https://www.gnu.org/software/bison/) 
- [pkg-config](https://gitlab.freedesktop.org/pkg-config/pkg-config)
- [patch](https://savannah.gnu.org/projects/patch/)
- [tar](https://ftp.gnu.org/gnu/tar/)

## Build and install

Install CommandLine tools at first:

```
xcode-select --install
```

Install to `/usr/local`

```
./build_and_install.sh
```

## Use GNU Libtool

Build pkg-config from source:

```bash
export LIBTOOLIZE=glibtoolize

pushd pkg-config
./autogen.sh --no-configure
./configure --with-internal-glib
make -j
make install
popd
```