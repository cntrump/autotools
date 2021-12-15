# autotools

Build and install autotools on macOS without any package managers.

- [autoconf](https://www.gnu.org/software/autoconf/)
- [automake](https://www.gnu.org/software/automake/)
- [libtool](https://www.gnu.org/software/automake/) (by adding prefix `g`: `glibtool`)
- [gettext](https://www.gnu.org/software/gettext/)

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

```
export LIBTOOLIZE=glibtoolize
$LIBTOOLIZE --version
```

Or

```
export libtoolize=glibtoolize
$libtoolize
```
