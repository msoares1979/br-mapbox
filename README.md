# Buildroot External for Mapbox

This external extension contains packages definitions for building the (Mapbox
Qt SDK)[2] for (Buildroot)[1].

These configurations where heavily inspired on (meta-mapbox)[3] Github
repository.

## Dependencies

- Toolchain with C++ support
- Toolchain with wchar support
- OpenGL or OpenGL ES2 support
- Qt5 modules


## Usage

There is a `configure.sh` script to automate your building. It basically fetches
2016-02 version of buildroot and points it to the `br-external` structure.

    make BR2_EXTERNAL=$PWD/br-external -C buildroot O=$PWD/output/fancyboard qemu_x86_64_defconfig

## Caveats

- Does not compile on UCLIBC-based toolchain
- `qemu_x86_64_defconfig` target is not a good choice due to its bad framebuffer
  support
- Not tested on real hardware



[1]: https://buildroot.org
[2]: https://github.com/mapbox/mapbox-gl-native/tree/master/platform/qt
[3]: https://github.com/mapbox/meta-mapbox
